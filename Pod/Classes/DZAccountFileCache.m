//
//  DZAccountFileCache.m
//  Pods
//
//  Created by baidu on 16/10/25.
//
//

#import "DZAccountFileCache.h"
#import "DZFileUtils.h"
#import "DZAuthSession.h"
#import "YHAccountData.h"
#import "DZLogger.h"
@interface DZAccountFileCache()
{
    NSMutableDictionary* _cacheContainer;
    NSRecursiveLock* _threadLock;
}
@end

@implementation DZAccountFileCache
+ (DZAccountFileCache*) activeCache
{
   return   [[YHAccountData shareFactory] shareInstanceFor:[self class] withInitBlock:^(DZAccountFileCache* cache) {
        [cache initWithRootPath:DZDocumentsSubPath(DZActiveAuthSession.userID)];
    }];
}

- (instancetype) initWithRootPath:(NSString *)rootPath
{
    self = [super init];
    if (!self) {
        return self;
    }
    _rootPath = rootPath;
    _threadLock = [[NSRecursiveLock alloc] init];
    _cacheContainer = [NSMutableDictionary new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveMemoryWaringNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flushAllCache) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flushAllCache) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flushAllCache) name:UIApplicationDidEnterBackgroundNotification object:nil];
    return self;
}

- (DZFileCache*) fileCacheWithName:(NSString *)fileName codec:(id<DZFileCodecInterface>)codec
{
    NSString* filePath = DZPathJoin(_rootPath, fileName);
    [_threadLock lock];
    DZFileCache* cache = [_cacheContainer objectForKey:filePath];
    if (!cache) {
        cache = [[DZFileCache alloc] initWithFilePath:filePath codec:codec];
        [_cacheContainer setObject:cache forKey:filePath];
    }
    [_threadLock unlock];
    return cache;
}

- (void) reciveMemoryWaringNotification:(NSNotificationCenter*)notification
{
    [_threadLock lock];
    for (DZFileCache * cache in _cacheContainer.allValues) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0) , ^{
            [cache flush:nil];
            [cache unloadMemory];
        });
    }
    [_threadLock unlock];
}

- (void) flushAllCache
{
    [_threadLock lock];
    for (DZFileCache* cache in _cacheContainer.allValues) {
        NSError* error;
        if(![cache flush:&error])
        {
            DDLogError(@"缓存%@写入失败%@", cache.filePath, error);
        };
    }
    [_threadLock unlock];
}

@end
