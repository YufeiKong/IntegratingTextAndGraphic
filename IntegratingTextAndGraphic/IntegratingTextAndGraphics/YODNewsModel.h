//
//  Model.h
//  WebView
//
//  Created by 张芳涛 on 16/9/22.
//  Copyright © 2016年 张芳涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YODNewsModel : NSObject
@property(nonatomic,assign)NSInteger id;
@property(nonatomic,assign)NSInteger cid;
@property(nonatomic,copy)NSString *catId;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *source;
@property(nonatomic,copy)NSString *thumb;
@property(nonatomic,copy)NSString *keywords;
@property(nonatomic,copy)NSString *desc;//后台返回来的字段是description
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *inputTime;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *comments;
@property(nonatomic,copy)NSString * curl;
@end
