//
//  DZFileCodecInterface.h
//  Pods
//
//  Created by baidu on 16/10/25.
//
//

#import <Foundation/Foundation.h>

@protocol DZFileCodecInterface <NSObject>
//对数据进行编码 NSData --> id
- (id) decode:(NSData*)data error:(NSError* __autoreleasing*)error;
//对数据进行解码 id --> NSData
- (NSData*) encode:(id)object error:(NSError* __autoreleasing*)error;
//
- (NSString*) fileCodecVersion;
@end
