//
//  Model.m
//  WebView
//
//  Created by 张芳涛 on 16/9/22.
//  Copyright © 2016年 张芳涛. All rights reserved.
//

#import "YODNewsModel.h"

@implementation YODNewsModel
//自己解析该方法起作用
-(void)setValue:(id)value forKey:(NSString *)key
{
    //针对description字段的特殊处理
    if ([key isEqualToString:@"description"]) {
        _desc = value;
    }
    else
    {
        [super setValue:value forKey:key];
    }
}
//mjextension 对于特殊字段的处理方式
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"desc":@"description"};
}
@end
