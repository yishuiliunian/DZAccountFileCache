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
@interface DZAccountFileCache : NSObject
@property (nonatomic, strong, readonly) NSString* rootPath;
- (instancetype) initWithRootPath:(NSString*)rootPath;
- (DZFileCache*) fileCacheWithName:(NSString*)fileName codec:(id<DZFileCodecInterface>)codec;
@end