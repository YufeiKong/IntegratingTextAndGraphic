//
//  CoreTextDataModel.m
//  IntegratingTextAndGraphics
//
//  Created by Content on 2017/5/16.
//  Copyright © 2017年 flymanshow. All rights reserved.
//

#import "CoreTextDataModel.h"
#import "CoreTextData.h"

@implementation CoreTextDataModel

// 检测点击位置是否在链接上
+ (CoreTextDataModel *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data {
    
    CFIndex index = [self touchContentOffsetInView:view atPoint:point data:data];
    if (index == -1) {
        return nil;
    }
    CoreTextDataModel * foundLink = [self linkAtIndex:index linkArray:data.linkArray];
    return foundLink;
}
// 将点击的位置转换成字符串的偏移量，如果没有找到，则返回-1
+ (CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData *)data {
    
    CTFrameRef textFrame = data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFrame);
    if (!lines) {
        return -1;
    }
    CFIndex count = CFArrayGetCount(lines);
    
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);
    
    // 翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    CFIndex index = -1;
    for (int i = 0; i < count; i++) {
    
    CGPoint linePoint = origins[i];
    CTLineRef line = CFArrayGetValueAtIndex(lines, i);
    // 获得每一行的CGRect信息
    CGRect flippedRect = [self getLineBounds:line point:linePoint];
    CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
    
    if (CGRectContainsPoint(rect, point)) {
    // 将点击的坐标转换成相对于当前行的坐标
    CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(rect),
                                        point.y-CGRectGetMinY(rect));
    // 获取到点击字符在整段文字中的index
    index = CTLineGetStringIndexForPosition(line, relativePoint);
    }
 }
    return index;
}

+ (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point {
    //配置line行的位置信息
    CGFloat ascent = 0;
    CGFloat descent = 0;
    CGFloat leading = 0;
    //在获取line行的宽度信息的同时得到其他信息
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y, width, height);
}

+ (CoreTextDataModel *)linkAtIndex:(CFIndex)i linkArray:(NSArray *)linkArray {
    
    CoreTextDataModel *linkdata = nil;
    for (CoreTextDataModel *data in linkArray) {
    if (NSLocationInRange(i, data.range)) {//某个位置是否在某个范围内
        linkdata = data;
        break;
     }
    }
    return linkdata;
}

@end
