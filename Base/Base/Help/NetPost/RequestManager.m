//
//  RequestManager.m
//  Sahara
//
//  Created by Chen on 15/6/12.
//  Copyright (c) 2015年 bodecn. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager

//上传请求
+ (void)PostUrl:(NSString *)url loding:(NSString *)loding dic:(NSDictionary *)dic response:(void (^)(id))response
{
    /**
     *  @brief  检查是否网络畅通
     */
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if (status == AFNetworkReachabilityStatusNotReachable) {
             [SVProgressHUD showErrorWithStatus:@"无网络连接！"];
             return;
         }
     }];
    [afNetworkReachabilityManager stopMonitoring];
    //加载图
    if (loding) {
        [SVProgressHUD showWithStatus:loding];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer   = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer.timeoutInterval = 20;
    //responseSerializer
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableSet *acceptContentType = [[responseSerializer acceptableContentTypes] mutableCopy];
    [acceptContentType addObject:@"text/html"];
    [responseSerializer setAcceptableContentTypes:acceptContentType];
    manager.responseSerializer = responseSerializer;
    //请求
    [manager POST:url
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              response(responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              response(nil);
          }];
    
}

//上传图片
+(void)updatePic:(NSData *)data response:(void (^)(id response))callBack
{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
                                    multipartFormRequestWithMethod:@"POST"
                                    URLString:@""
                                    parameters:nil
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                        [formData appendPartWithFileData:data name:@"111" fileName:@"avatar.png" mimeType:@"image/jpeg"];
                                    }
                                    error:nil];

    AFURLSessionManager *manager = [[AFURLSessionManager alloc]
                                    initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:&progress
                                                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                                  
                                                                  if (error)
                                                                  {
                                                                      callBack(nil);
                                                                      
                                                                  } else
                                                                  {
                                                                      callBack(responseObject);
                                                                  }
                                                                  
                                                              }];
    [uploadTask resume];
}




//
+ (NSString *)JsonStr:(id)obj
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:NSJSONWritingPrettyPrinted// Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
/*
+ (NSString *)ReWritePostUrl:(NSString *)url obj:(id)obj TheOrder:(NSArray*)order {
    
    if (!obj) {
        return url;
    }
    __block NSString *urlStr = [url stringByAppendingString:@"?"];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = obj;
        if (order.count > 0) {
            [order enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString * key = obj;
                urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[dic objectForKey:key]]];
            }];
        } else {
            [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
            }];
        }
        
        urlStr = [urlStr stringByReplacingCharactersInRange:NSMakeRange(urlStr.length - 1, 1) withString:@""];
        urlStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlStr, NULL, NULL,  kCFStringEncodingUTF8));
    }
    return urlStr;
}
*/
@end
