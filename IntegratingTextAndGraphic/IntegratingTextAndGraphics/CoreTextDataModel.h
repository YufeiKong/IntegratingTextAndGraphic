//
//  CoreTextDataModel.h
//  IntegratingTextAndGraphics
//
//  Created by Content on 2017/5/16.
//  Copyright © 2017年 flymanshow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"

@interface CoreTextDataModel : NSObject

@property (nonatomic, strong) NSString *name;//图片名称
@property (nonatomic, assign) CGRect imagePosition;//图片位置
@property (nonatomic, strong) NSString *urlString;//网页地址链接

@property (nonatomic, assign) NSRange range;//链接地址在文本中的范围
@property (nonatomic, strong) NSString * title;//链接地址名称

#pragma mark ---若点击位置有链接返回链接对象否则返回nil
+ (CoreTextDataModel *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data;

@end
