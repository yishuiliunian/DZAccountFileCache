//
// Created by stonedong on 16/12/27.
//

#import <Foundation/Foundation.h>

#import "DZFileCodecInterface.h"
@interface DZCacheKeyModelCodec : NSObject <DZFileCodecInterface>
@property  (nonatomic, strong, readonly)  Class modelClass;
- (instancetype) initWithModelClass:(Class)modelClass;
@end