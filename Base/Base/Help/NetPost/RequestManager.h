//
//  RequestManager.h
//  Sahara
//
//  Created by Chen on 15/6/12.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface RequestManager : NSObject

+ (void)PostUrl:(NSString *)url
         loding:(NSString *)loding
            dic:(NSDictionary *)dic
       response:(void(^)(id response))response;

//上传图片
+ (void)updatePic:(NSData *)data
         response:(void (^)(id response))callBack;
@end
