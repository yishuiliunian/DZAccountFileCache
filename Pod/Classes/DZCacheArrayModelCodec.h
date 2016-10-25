//
//  DZCacheArrayModelCodec.h
//  Pods
//
//  Created by stonedong on 16/10/25.
//
//

#import <Foundation/Foundation.h>
#import "DZFileCodecInterface.h"
@interface DZCacheArrayModelCodec : NSObject <DZFileCodecInterface>
@property (nonatomic, strong,readonly)Class containerClass;
- (instancetype) initWithContainerClass:(Class)containerClass;
@end
