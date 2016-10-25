//
//  DZAccountFileCache.h
//  Pods
//
//  Created by baidu on 16/10/25.
//
//

#import <Foundation/Foundation.h>
#import "DZFileCache.h"
#import "DZFileCodecInterface.h"
#import "DZCacheJSONCodec.h"
#import "DZCacheArrayModelCodec.h"

@interface DZAccountFileCache : NSObject
+ (DZAccountFileCache*) activeCache;
@property (nonatomic, strong, readonly) NSString* rootPath;
- (instancetype) initWithRootPath:(NSString*)rootPath;
- (DZFileCache*) fileCacheWithName:(NSString*)fileName codec:(id<DZFileCodecInterface>)codec;
@end
