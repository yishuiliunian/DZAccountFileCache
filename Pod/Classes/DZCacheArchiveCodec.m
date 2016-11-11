//
//  DZCacheArchiveCodec.m
//  Pods
//
//  Created by baidu on 2016/11/11.
//
//

#import "DZCacheArchiveCodec.h"

@implementation DZCacheArchiveCodec
//对数据进行编码 NSData --> id
- (id) decode:(NSData*)data error:(NSError* __autoreleasing*)error
{
    return  [NSKeyedUnarchiver unarchiveObjectWithData:data];

}
//对数据进行解码 id --> NSData
- (NSData*) encode:(id)object error:(NSError* __autoreleasing*)error
{
    NSData* allItemsData = [NSKeyedArchiver archivedDataWithRootObject:object];
    return allItemsData;
}
//
- (NSString*) fileCodecVersion {
    return @"1.0.0";
}

@end
