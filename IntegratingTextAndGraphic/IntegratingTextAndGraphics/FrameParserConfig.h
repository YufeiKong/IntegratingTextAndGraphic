//
//  FrameParserConfig.h
//  IntegratingTextAndGraphics
//
//  Created by Content on 2017/5/16.
//  Copyright © 2017年 flymanshow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FrameParserConfig : NSObject

@property (nonatomic, assign) CGFloat width;//文本宽度
@property (nonatomic, assign) CGFloat fontSize;//字体大小
@property (nonatomic, assign) CGFloat lineSpace;//字体行间距
@property (nonatomic, strong) UIColor *textColor;//字体颜色
@property (nonatomic, strong) NSString *FontName;//字体
@end
