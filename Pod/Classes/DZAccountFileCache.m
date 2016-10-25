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
    return self;
}

- (DZFileCache*) fileCacheWithName:(NSString *)fileName codec:(id<DZFileCodecInterface>)codec
{
    NSString* filePath = DZFileInSubPath(_rootPath, fileName);
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
    NSArray* allKeys = [_cacheContainer allKeys];
    [_cacheContainer removeAllObjects];
    [_threadLock unlock];
}

@end
