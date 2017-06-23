//
//  FrameParser.m
//  IntegratingTextAndGraphics
//
//  Created by Content on 2017/5/16.
//  Copyright © 2017年 flymanshow. All rights reserved.
//


#import "FrameParser.h"
#import <CoreText/CoreText.h>
#import "CoreTextDataModel.h"

@implementation FrameParser

#pragma mark ---模拟网络请求
+ (CoreTextData *)parseTemplateFile:(NSString *)path
                             config:(FrameParserConfig *)config {
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *linkArray = [NSMutableArray array];
    NSAttributedString *content = [self loadTemplateFile:path config:config imageArray:imageArray linkArray:linkArray];
    
    CoreTextData *data = [self parseAttributedContent:content config:config];
    data.imageArray = imageArray;
    data.linkArray = linkArray;
    return data;
}
#pragma mark ---加载含有图片链接文字的路径
+ (NSAttributedString *)loadTemplateFile:(NSString *)path
                                  config:(FrameParserConfig *)config
                              imageArray:(NSMutableArray *)imageArray
                               linkArray:(NSMutableArray *)linkArray {
    
    NSMutableAttributedString *attStringM = [[NSMutableAttributedString alloc] init];
    //NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSData *data = [path dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    for (NSDictionary *dict in array) {
        NSString *type = dict[@"type"];
        
    if ([type isEqualToString:@"text"]) {//文本类型
        
    NSAttributedString *attString = [self parseAttributedContentFromNSDictionary:dict config:config];
    [attStringM appendAttributedString:attString];
        
    }else if ([type isEqualToString:@"image"]) {//图片类型
      
    CoreTextDataModel *imageData = [[CoreTextDataModel alloc] init];
    imageData.name = dict[@"content"];
    [imageArray addObject:imageData];
    //创建空白占位符，并设置它的CTRunDelegate信息
    NSAttributedString *attString = [self parseImageDataFromNSDictionary:dict config:config];
    [attStringM appendAttributedString:attString];
        
    }else if ([type isEqualToString:@"link"]) {//网络链接类型
    //得到属性文字的起始点
    NSUInteger startPos = attStringM.length;
    NSAttributedString *attString = [self parseAttributedLinkFromNSDictionary:dict config:config];
    [attStringM appendAttributedString:attString];
    //获取链接文字属性的范围
    NSRange linkRange = NSMakeRange(startPos, attString.length);
    
    //将链接文字属性信息保存到数组中
    CoreTextDataModel *linkdata = [[CoreTextDataModel alloc] init];
    linkdata.range = linkRange;
    linkdata.title = dict[@"content"];
    linkdata.urlString = dict[@"url"];
    [linkArray addObject:linkdata];
        
       }
    }
    return attStringM;
}

#pragma mark ---配置属性文字
+ (NSAttributedString *)parseAttributedContentFromNSDictionary:(NSDictionary *)dict
                                                        config:(FrameParserConfig *)config {
    NSMutableDictionary *attributes = [self attributesWithConfig:config];
    //设置颜色
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    if(color != nil) {
    attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    //设置字体大小
    CGFloat fontSize = [dict[@"size"] floatValue];
    
    if (fontSize > 0) {
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    CFRelease(fontRef);
    }
    //配置文字
    NSString *content = dict[@"content"];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    return attString;
}

+ (UIColor *)colorFromTemplate:(NSString *)name {
    if ([name isEqualToString:@"red"]) {
        return [UIColor redColor];
    }else if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    }else if ([name isEqualToString:@"black"]) {
        return [UIColor blackColor];
    }else {
        return nil;
    }
}

#pragma mark ---配置网页链接对象
+ (NSAttributedString *)parseAttributedLinkFromNSDictionary:(NSDictionary *)dict
                                                     config:(FrameParserConfig *)config {
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithAttributedString:[self parseAttributedContentFromNSDictionary:dict config:config]];
    //链接地址颜色
    [attString addAttribute:(id)kCTForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, attString.length)];
    //下划线颜色
    [attString addAttribute:(id)kCTUnderlineColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, attString.length)];
    //下划线样式
    [attString addAttribute:(id)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:NSMakeRange(0, attString.length)];
    return attString;
}
#pragma mark ---配置图片 返回空白的占位符文字
+ (NSAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict
                                                config:(FrameParserConfig *)config {
    
    //配置CTRun代理回调函数
    CTRunDelegateCallbacks callbacks;
    //为callbacks开辟内存空间
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    //设置代理版本
    callbacks.version = kCTRunDelegateVersion1;
    //配置代理回调函数
    callbacks.dealloc = deallocCallBack;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    //根据配置的代理信息创建代理
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void*)dict);
    //使用0xFFFC作为空白占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary * attributes = [self attributesWithConfig:config];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    //为属性文字设置代理
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}
#pragma mark ---CTRun加载图片代理
#pragma mark ---CTRun的回调  销毁内存的回调
void deallocCallBack(void *ref)
{
    NSLog(@"RunDelegate Dealloc");
}

#pragma mark ---获取CTLine的上行高度
CGFloat ascentCallback(void *ref)
{
  
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}

#pragma mark ---获取CTLine的下行高度
CGFloat descentCallback(void *ref)
{
    return 0;
}

#pragma mark ---获取CTLine的最大显示宽度
CGFloat widthCallback(void *ref)
{
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}

#pragma mark ------------------------------------------纯文字
+ (CoreTextData *)parseContent:(NSString *)content config:(FrameParserConfig *)config {
    //创建文字并配置属性
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    return [self parseAttributedContent:attString config:config];
}
#pragma mark ---根据属性文字对象和配置信息对象生成CoreTextData对象
+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content
                                  config:(FrameParserConfig *)config {
    //创建CTFrameSetterRef实例
    CTFramesetterRef ctFrameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);

    //获取要绘制的区域信息
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(ctFrameSetterRef, CFRangeMake(0, 0), NULL, restrictSize, NULL);
    CGFloat textHeight = coreTextSize.height;
    //配置ctframeRef信息
    CTFrameRef ctFrame = [self createFrameWithFramesetting:ctFrameSetterRef config:config height:textHeight];
    //配置coreTextData数据
    CoreTextData *data = [[CoreTextData alloc] init];
    data.ctFrame = ctFrame;
    data.height = textHeight;
    data.content = content;
    //释放内存
    CFRelease(ctFrame);
    CFRelease(ctFrameSetterRef);
    return data;
}
#pragma mark -- 根据传入配置信息配置文字属性字典
 + (NSMutableDictionary *)attributesWithConfig:(FrameParserConfig *)config {
    //配置字体信息
    CGFloat fontSize = config.fontSize;
     //Helvetica-Bold   ArialMT
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)[NSString stringWithFormat:@"%@",config.FontName], fontSize, NULL);
    //换行
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = 1;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    const CFIndex kNumberOfSettings = 4;
    //配置间距
    CGFloat lineSpace = config.lineSpace;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
    {
    kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpace
    },
    {
    kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpace
    },
    {
    kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpace
    },
    lineBreakMode
    };
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    //配置字体颜色
    UIColor *textColor = config.textColor;
    //将配置信息加入字典
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)ctFont;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    //释放变量
    CFRelease(theParagraphRef);
    CFRelease(ctFont);
    return dict;
}
#pragma mark --根据CTFramesetterRef、配置信息对象和高度生成对应的CTFrameRef
 + (CTFrameRef)createFrameWithFramesetting:(CTFramesetterRef)frameSetter
                                   config:(FrameParserConfig *)config
                                   height:(CGFloat)height {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    CTFrameRef ctframeRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return ctframeRef;
     
}
@end
