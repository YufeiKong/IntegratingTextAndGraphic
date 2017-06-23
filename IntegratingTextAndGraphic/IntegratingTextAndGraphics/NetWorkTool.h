//
//  NetWorkTool.h
//  WECAST
//
//  Created by 张芳涛 on 2016/11/20.
//  Copyright © 2016年 张芳涛. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^RequestSuccess) (id requestData);
typedef void (^RequestFailure) (NSInteger code,NSError *error);

@interface NetWorkTool : NSObject
/**
 *  设置网络请求接口的基地址（程序启动的时候设置一次就行）
 *
 *  @param url 基地址（http://211.151.130.187）
 */
+ (void)setBaseUrl:(NSString *)url;

/**
 *  设置请求超时时长（默认60s）
 *
 *  @param timeout 超时时间
 */
+ (void)setTimeout:(NSTimeInterval)timeout;

/**
 *  设置公共参数
 *
 *  @param params 公参
 */
+ (void)setCommonParams:(NSDictionary *)params;

/**
 *  GET请求
 *
 *  @param url     请求地址
 *  @param params  参数
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)GET:(NSString *)url
                   Params:(NSDictionary *)params
                  Success:(RequestSuccess)success
                  Failure:(RequestFailure)failure;

/**
 *  POST请求
 *
 *  @param url     请求地址
 *  @param params  参数
 *  @param success 成功回调
 *  @param failure 失败回调
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)POST:(NSString *)url
                    Params:(NSDictionary *)params
                   Success:(RequestSuccess)success
                   Failure:(RequestFailure)failure;

/**
 *  上传单个文件
 *
 *  @param url      请求地址
 *  @param params   参数
 *  @param filedata 文件数据
 *  @param name     服务器用来解析的字段
 *  @param filename 文件名
 *  @param mimeType mimetype
 *  @param success  成功回调
 *  @param failure  失败回调
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)UPLOADSINGLEFILE:(NSString *)url
                                Params:(NSDictionary *)params
                              FileData:(NSData *)filedata
                                  Name:(NSString *)name
                              FileName:(NSString *)filename
                              MimeType:(NSString *)mimeType
                               Success:(RequestSuccess)success
                               Failure:(RequestFailure)failure;

/**
 *  上传多个文件
 *
 *  @param url       请求地址
 *  @param params    参数
 *  @param fileArray 文件数组
 *  @param success   成功回调
 *  @param failure   失败回调
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)UPLOADMULTIFILE:(NSString *)url
                               Params:(NSDictionary *)params
                             FileArray:(NSArray *)fileArray
                              Success:(RequestSuccess)success
                              Failure:(RequestFailure)failure;


@end
