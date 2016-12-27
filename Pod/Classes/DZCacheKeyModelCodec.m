//
// Created by stonedong on 16/12/27.
//

#import <AMapSearch/AMapSearchKit/AMapSearchAPI.h>
#import "DZCacheKeyModelCodec.h"
#import "NSObject+YYModel.h"


@implementation DZCacheKeyModelCodec

- (instancetype)initWithModelClass:(Class)modelClass {
    self = [super init];
    if (!self) {
        return self;
    }
    _modelClass = modelClass;
    return self;
}
- (id) decode:(NSData *)data error:(NSError *__autoreleasing *)error
{
    NSDictionary * dictionary = [data yy_modelToJSONObject];
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"com.dzpqzb.codec" code:-88 userInfo:@{NSLocalizedDescriptionKey:@"输入的数据类型不是Dictionary"}];
        }
        return nil;
    }

    NSMutableDictionary * objects = [NSMutableDictionary new];
    for (NSString * key in dictionary.allKeys) {
        NSDictionary * value = dictionary[key];
        id object = [_modelClass yy_modelWithDictionary:value];
        if (object) {
            objects[key]  = object;
        }
    }
    return objects;
}

- (NSData*) encode:(id)object error:(NSError *__autoreleasing *)error
{
    if ([object isKindOfClass:[NSDictionary class]]) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"com.dzpqzb.codec" code:-88 userInfo:@{NSLocalizedDescriptionKey:@"输入的数据类型不是Dictionary"}];
        }
        return nil;
    }
    NSDictionary * dic = (NSDictionary *)object;
    return [dic yy_modelToJSONData];
}

- (NSString*) fileCodecVersion
{
    return @"1.0.0";
}
@end