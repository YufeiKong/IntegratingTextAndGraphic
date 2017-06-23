//
//  CoreTextData.h
//  IntegratingTextAndGraphics
//
//  Created by Content on 2017/5/16.
//  Copyright © 2017年 flymanshow. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CoreTextData : NSObject

@property (nonatomic, assign) CTFrameRef ctFrame;//文本绘制的区域大小
@property (nonatomic, assign) CGFloat height;//文本绘制区域高度
@property (nonatomic, strong) NSMutableArray *imageArray;//文本中存储图片信息数组
@property (nonatomic, strong) NSMutableArray *linkArray;//文本中存储链接信息数组
@property (nonatomic, strong) NSAttributedString *content;//文本

@end
