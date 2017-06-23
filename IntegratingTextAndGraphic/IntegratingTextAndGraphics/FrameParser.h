//
//  FrameParser.h
//  IntegratingTextAndGraphics
//
//  Created by Content on 2017/5/16.
//  Copyright © 2017年 flymanshow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FrameParserConfig.h"
#import "CoreTextData.h"

@interface FrameParser : NSObject

#pragma mark ---传入纯文字字符串
+ (CoreTextData *)parseContent:(NSString *)content config:(FrameParserConfig *)config;

#pragma mark ---模拟传入网络数据
+ (CoreTextData *)parseTemplateFile:(NSString *)path
                             config:(FrameParserConfig *)config ;
#pragma mark ---传入富文本格式的字符串
+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(FrameParserConfig*)config;

@end
