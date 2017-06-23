//
//  FrameParserConfig.m
//  IntegratingTextAndGraphics
//
//  Created by Content on 2017/5/16.
//  Copyright © 2017年 flymanshow. All rights reserved.
//

#import "FrameParserConfig.h"

@implementation FrameParserConfig
- (instancetype)init
{
    self = [super init];
    if (self) {
        _width = 345.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = [UIColor blackColor];
        _FontName = @"ArialMT";
    }
    return self;
}
@end
