//
//  DZCacheJSONCodec.m
//  Pods
//
//  Created by baidu on 16/10/25.
//
//

#import "DZCacheJSONCodec.h"

@implementation DZCacheJSONCodec
- (id) decode:(NSData *)data error:(NSError *__autoreleasing *)error
{
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
}

- (NSData*) encode:(id)object error:(NSError *__autoreleasing *)error
{
   return  [NSJSONSerialization dataWithJSONObject:object options:0 error:error];
}

- (NSString*) fileCodecVersion
{
    return @"1.0.0";
}
@end
