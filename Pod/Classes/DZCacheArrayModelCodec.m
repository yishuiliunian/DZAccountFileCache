//
//  DZCacheArrayModelCodec.m
//  Pods
//
//  Created by stonedong on 16/10/25.
//
//

#import "DZCacheArrayModelCodec.h"
#import <YYModel.h>
@implementation DZCacheArrayModelCodec
- (instancetype) initWithContainerClass:(Class)containerClass
{
    self = [super init];
    if (!self) {
        return self;
    }
    _containerClass = containerClass;
    return self;
}
- (id)decode:(NSData *)data error:(NSError *__autoreleasing *)error
{
    NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error != NULL && *error) {
        return array;
    }
    if (!array) {
        return array;
    }
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSMutableArray* decodeArray = [NSMutableArray new];
    for (NSDictionary* dic in array) {
        if (![dic isKindOfClass:[NSDictionary class]]) {

            return nil;
        }
        id object = [_containerClass yy_modelWithJSON:dic];
        if (object) {
            [decodeArray addObject:object];
        }
    }
    return decodeArray;
}

- (NSData*) encode:(id)object error:(NSError *__autoreleasing *)error
{
    if (![object isKindOfClass:[NSArray class]]) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"com.dzpqzb.file.cache.error" code:-94 userInfo:@{NSLocalizedDescriptionKey:@"数据类型错误期望为NSArray"}];
        }
        return nil;
    }
    NSArray* array = object;
    NSMutableArray* encodeArray = [NSMutableArray new];
    for (id ob  in array) {
        if (![ob isKindOfClass:_containerClass]) {
            if (error != NULL) {
                NSString* msg = [NSString stringWithFormat:@"数据类型错误期望为%@，But got %@", _containerClass, ob];
                *error = [NSError errorWithDomain:@"com.dzpqzb.file.cache.error" code:-94 userInfo:@{NSLocalizedDescriptionKey:msg}];
            }
            return nil;
        }
        NSDictionary* dic = [ob yy_modelToJSONObject];
        [encodeArray addObject:dic];
    }
    return [encodeArray yy_modelToJSONData];
}

- (NSString*) fileCodecVersion
{
    return @"1.0.0";
}
@end
