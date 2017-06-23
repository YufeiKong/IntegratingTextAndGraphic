//
//  NetWorkTool.m
//  WECAST
//
//  Created by 张芳涛 on 2016/11/20.
//  Copyright © 2016年 张芳涛. All rights reserved.
//

#import "NetWorkTool.h"
#import "AFNetworking.h"
typedef NS_ENUM(NSInteger,RequestMethod){
    GET,
    POST,
    DOWNLOAD,
    UPLOAD
};
static NSString         *base_url = nil;
static NSTimeInterval   time_out = 60.0f;
static NSDictionary     *common_params = nil;
@implementation NetWorkTool
+ (void)setBaseUrl:(NSString *)url {
    base_url = url;
}

+ (void)setTimeout:(NSTimeInterval)timeout {
    time_out = timeout;
}

+ (void)setCommonParams:(NSDictionary *)params {
    common_params = params;
}

+ (NSString *)print:(NSString *)url params:(NSDictionary *)params
{
    NSMutableString *absURL = [NSMutableString string];
    [absURL appendString:url];
    __block BOOL first = YES;
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *keyvalue;
        if (first == YES)
        {
            keyvalue = [NSString stringWithFormat:@"?%@=%@",key,obj];
            first = NO;
        }
        else
        {
            keyvalue = [NSString stringWithFormat:@"&%@=%@",key,obj];
        }
        
        [absURL appendString:keyvalue];
    }];
    return absURL;
}

+ (NSURLSessionTask *)GET:(NSString *)url Params:(NSDictionary *)params Success:(RequestSuccess)success Failure:(RequestFailure)failure {
    return [self RequestWithUrl:url RequestMethod:GET Params:params FileArray:nil Success:(RequestSuccess)success Failure:(RequestFailure)failure];
}

+ (NSURLSessionTask *)POST:(NSString *)url Params:(NSDictionary *)params Success:(RequestSuccess)success Failure:(RequestFailure)failure {
    return [self RequestWithUrl:url RequestMethod:POST Params:params FileArray:nil Success:success Failure:failure];
}

+ (NSURLSessionTask *)UPLOADSINGLEFILE:(NSString *)url Params:(NSDictionary *)params FileData:(NSData *)filedata Name:(NSString *)name FileName:(NSString *)filename MimeType:(NSString *)mimeType Success:(RequestSuccess)success Failure:(RequestFailure)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"data"] = filedata;
    dict[@"name"] = name;
    dict[@"filename"] = filename;
    dict[@"mimeType"] = mimeType;
    return [self RequestWithUrl:url RequestMethod:UPLOAD Params:params FileArray:@[dict] Success:success Failure:failure];
}

+ (NSURLSessionTask *)UPLOADMULTIFILE:(NSString *)url Params:(NSDictionary *)params FileArray:(NSArray *)fileArray Success:(RequestSuccess)success Failure:(RequestFailure)failure {
    return [self RequestWithUrl:url RequestMethod:UPLOAD Params:params FileArray:fileArray Success:success Failure:failure];
}

+ (NSURLSessionTask *)RequestWithUrl:(NSString *)url RequestMethod:(RequestMethod)method Params:(NSDictionary *)params FileArray:(NSArray *)fileArray Success:(RequestSuccess)success Failure:(RequestFailure)failure{
    
    AFHTTPSessionManager *manager = nil;
    if (base_url != nil) {
        manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:base_url]];
    }else {
        manager = [AFHTTPSessionManager manager];
    }
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = time_out;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*"]];
    manager.operationQueue.maxConcurrentOperationCount = 6;
    
    NSMutableDictionary *requestParams = [NSMutableDictionary dictionary];
    if (common_params != nil) {
        [requestParams addEntriesFromDictionary:common_params];
    }
    if (params != nil) {
        [requestParams addEntriesFromDictionary:params];
    }
    
    NSURLSessionTask *session = nil;
    NSString *requestUrl = [NSString stringWithFormat:@"%@",manager.baseURL];
    requestUrl = [requestUrl stringByAppendingString:url];
    
    NSLog(@"%@ = %@",url,[self print:requestUrl params:requestParams]);
    
    if (method == GET) {
        
        session = [manager GET:url parameters:requestParams progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *returnDic = responseObject;
                if ([returnDic.allKeys containsObject:@"errorCode"]) {
                    NSInteger code = [returnDic[@"errorCode"] integerValue];
                    if (code == 1000) {
                       // [[NSNotificationCenter defaultCenter] postNotificationName:ILLEGALUSER object:nil userInfo:nil];
//                        [[YodLoginTool shareManager] logout];
                        
                        return;
                    }

                }
            }
            
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure([error code],error);
        }];
    }else if (method == POST) {
        session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            if ([responseObject isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *returnDic = responseObject;
//                if ([returnDic.allKeys containsObject:@"errorCode"]) {
//                    NSInteger code = [returnDic[@"errorCode"] integerValue];
//                    if (code == 0) {
//                    }else {
//                        failure(code,nil);
//                        return;
//
//                    }
//                }
//            }

            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure([error code],error);
        }];
    }else if (method == UPLOAD) {
        
        session = [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSError *error;
            if (fileArray == nil || fileArray.count == 0) {
                failure([error code],error);
            }else {
                [fileArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dict = obj;
                    NSData *filedata = dict[@"data"];
                    NSString *name = dict[@"name"];
                    NSString *filename = dict[@"filename"];
                    NSString *mimeType = dict[@"mimeType"];
                    [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimeType];
                }];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure([error code],error);
        }];
    }
    return session;
}

@end
