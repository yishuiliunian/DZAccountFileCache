//
//  DZFileCache.m
//  Pods
//
//  Created by baidu on 16/10/25.
//
//

#import "DZFileCache.h"

static NSString* const kDZFileCacheData = @"data";
static NSString* const kDZFileCacheVersion = @"version";
@interface DZFileCache ()
{
    id _lastCachedObject;
    BOOL _lastCachedObjectChanged;
    NSRecursiveLock * _lock;
}
@end

@implementation DZFileCache
@dynamic lastCachedObject;

- (void) dealloc
{
    [self close];
}
- (instancetype) initWithFilePath:(NSString *)path codec:(id<DZFileCodecInterface>)codec
{
    self = [super init];
    if (!self) {
        return self;
    }
    _filePath = path;
    _codec = codec;
    _lastCachedObjectChanged = NO;
    _lock = [NSRecursiveLock new];
    return self;
}

- (id) lastCachedObject
{
    [_lock lock];
    if (!_lastCachedObject) {
        NSError* error = nil;
        id object = [self dumpObject:&error];
        _lastCachedObject = object;
        _lastCachedObjectChanged = YES;
    }
    [_lock unlock];
    return _lastCachedObject;
}

- (void) setLastCachedObject:(id)lastCachedObject
{
    [_lock lock];
    if (lastCachedObject != _lastCachedObject) {
        _lastCachedObject = lastCachedObject;
        _lastCachedObjectChanged = YES;
    }
    [_lock unlock];
}


- (BOOL) flush:(NSError *__autoreleasing *)error
{
    if (!_codec) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"com.dzpqzb.file.cache.error" code:-88 userInfo:@{NSLocalizedDescriptionKey:@"The Codec is nil ,please set some value"}];
        }
        return NO;
    }
    if (!_filePath) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"com.dzpqzb.file.cache.error" code:-88 userInfo:@{NSLocalizedDescriptionKey:@"The FilePath is nil ,please set some value"}];
        }
        return NO;
    }
    [_lock lock];
    BOOL  changed = _lastCachedObject;
    id object  = _lastCachedObject;
    [_lock unlock];
    if (!changed) {
        return YES;
    }
    NSData* data = [_codec encode:object error:error];
    if (error != NULL && *error != nil) {
        return NO;
    }
    if (data == nil) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
            if([[NSFileManager defaultManager] removeItemAtPath:_filePath error:error])
            {
                [_lock lock];
                _lastCachedObjectChanged= NO;
                [_lock unlock];;
                return YES;
            } else {
                return NO;
            }
        } else {
            [_lock lock];
            _lastCachedObjectChanged = NO;
            [_lock unlock];
            return YES;
        }
    }
    NSMutableDictionary* fileDic = [NSMutableDictionary new];
    fileDic[kDZFileCacheData] =[data base64EncodedStringWithOptions:0];
    
    NSString* version = [_codec fileCodecVersion];
    fileDic[kDZFileCacheVersion] = version;
    
    NSData* fileData = [NSJSONSerialization dataWithJSONObject:fileDic options:0 error:error];
    if (error != NULL && *error != nil) {
        return NO;
    }
    if (fileData == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"com.dzpqzb.error.filecache" code:-99 userInfo:@{NSLocalizedDescriptionKey:@"文件数据要编码失败!"}];
            
        }
        return NO;
    }
    if(![fileData writeToFile:_filePath options:NSDataWritingAtomic error:error]) {
        return NO;
    }
    [_lock lock];
    _lastCachedObjectChanged = NO;
    [_lock unlock];
    return YES;
}

- (id) dumpObject:(NSError* __autoreleasing*)error
{
    if (!_codec) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"com.dzpqzb.file.cache.error" code:-88 userInfo:@{NSLocalizedDescriptionKey:@"The Codec is nil ,please set some value"}];
        }
        return NO;
    }
    if (!_filePath) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"com.dzpqzb.file.cache.error" code:-88 userInfo:@{NSLocalizedDescriptionKey:@"The FilePath is nil ,please set some value"}];
        }
        return NO;
    }
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:_filePath]) {
        return nil;
    }
    
    NSData* data = [NSData dataWithContentsOfFile:_filePath];
    if (!data) {
        return nil;
    }
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    if (error != NULL && *error != nil) {
        return nil;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];
        return nil;
    }
    if (dic == nil) {
        return nil;
    }
    NSString* contentString = dic[kDZFileCacheData];
    NSData* contentData  = [[NSData alloc] initWithBase64EncodedString:contentString options:0];
    NSString* version = dic[kDZFileCacheVersion];
    
    if (version && ![version isEqualToString:[_codec fileCodecVersion]]) {
        [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];
        return nil;
    }
    id object = [_codec decode:contentData error:error];
    if (error != NULL && *error != nil) {
        return nil;
    }
    return object;
}

- (void) close
{
    NSError* error;
    [self flush:&error];
    if ([self.manageDelegate respondsToSelector:@selector(fileCacheWillClose:)]) {
        [self.manageDelegate fileCacheWillClose:self];
    }
}

- (void)unloadMemory {
    [_lock lock];
    _lastCachedObject = nil;
    [_lock unlock];
}
@end
