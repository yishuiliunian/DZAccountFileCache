//
//  DZFileCache.m
//  Pods
//
//  Created by baidu on 16/10/25.
//
//

#import "DZFileCache.h"

@interface DZFileCache ()
{
    id _lastCachedObject;
    BOOL _lastCachedObjectChanged;
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
    return self;
}

- (id) lastCachedObject
{
    if (!_lastCachedObject) {
        NSError* error = nil;
        _lastCachedObject = [self dumpObject:&error];
        _lastCachedObjectChanged = YES;
    }
    return _lastCachedObject;
}

- (void) setLastCachedObject:(id)lastCachedObject
{
    if (lastCachedObject != _lastCachedObject) {
        _lastCachedObject = lastCachedObject;
        _lastCachedObjectChanged = YES;
    }
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

    if (!_lastCachedObjectChanged) {
        return YES;
    }
    NSData* data = [_codec encode:_lastCachedObject error:error];
    if (error != NULL && *error != nil) {
        return NO;
    }
    if (data == nil) {
        if([[NSFileManager defaultManager] removeItemAtPath:_filePath error:error])
        {
            _lastCachedObjectChanged = NO;
            return YES;
        } else {
            return NO;
        }
    }

    if(![data writeToFile:_filePath options:NSDataWritingAtomic error:error]) {
        return NO;
    }
    _lastCachedObjectChanged = NO;
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
    id object = [_codec decode:data error:error];
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
@end
