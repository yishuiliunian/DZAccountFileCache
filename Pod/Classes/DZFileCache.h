//
//  DZFileCache.h
//  Pods
//
//  Created by baidu on 16/10/25.
//
//

#import <Foundation/Foundation.h>
#import "DZFileCodecInterface.h"

@class DZFileCache;
@protocol DZFileCacheManageDelegate <NSObject>
@optional
- (void) fileCacheWillClose:(DZFileCache*)cache;
@end


@interface DZFileCache : NSObject
@property (nonatomic, weak) id<DZFileCacheManageDelegate> manageDelegate;
@property (nonatomic, strong, readonly) NSString* filePath;
@property (nonatomic, strong, readonly) id<DZFileCodecInterface> codec;
@property (nonatomic, strong) NSString* contentVersion;
@property (nonatomic, strong) id lastCachedObject;
//
- (instancetype) initWithFilePath:(NSString*)path codec:(id<DZFileCodecInterface>)codec;
- (BOOL) flush:(NSError *__autoreleasing *)error;
- (id) dumpObject:(NSError* __autoreleasing*)error;
- (void) close;
- (void) unloadMemory;
@end

@interface DZFileCache (Convience)
@property  (nonatomic, strong, getter=lastCachedObject, setter=setLastCachedObject:) NSArray * cachedArray;
@property  (nonatomic, strong, getter=lastCachedObject, setter=setLastCachedObject:) NSDictionary* cachedDictionary;
@end
