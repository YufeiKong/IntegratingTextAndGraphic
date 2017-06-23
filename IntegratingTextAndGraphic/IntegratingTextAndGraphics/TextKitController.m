//
//  TextKitController.m
//  IntegratingTextAndGraphics
//
//  Created by Content on 2017/5/22.
//  Copyright © 2017年 flymanshow. All rights reserved.
//

#import "TextKitController.h"
#import "WebViewController.h"
#import "EnlargeImage.h"
@interface TextKitController ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *textView;
@property (nonatomic,strong) NSTextContainer * textContainer;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation TextKitController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.view.backgroundColor = [UIColor whiteColor];
     self.title = @"TextKit";
    
     [self initUI];
     [self initData];
}
-(void)initUI{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-0) style:UITableViewStylePlain];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = RGB(235, 235, 235);
    [self.view addSubview:_tableView];

}
-(void)initData{

    NSString *str = @"CoreText是用于文字精细排版的文本框架。它直接与CoreGraphics交互，将需要显示的文本内容，位置，字体，字体颜色，链接，图片直接传递给Quartz，与其他UI组件相比，能更高效的进行渲染。CoreText是不直接支持绘制图片的，我们可以先在需要显示图片的地方用一个特殊的空白占位符代替，同时设置该字体的CTRunDelegate信息为要显示的图片的宽度和高度，这样绘制文字的时候就会先把图片的位置留出来，再在drawRect方法里面用 CGContextDrawImage绘制图片。\n\n   百度一下 你就知道\n\n   CoreText是用于文字精细排版的文本框架。它直接与CoreGraphics交互，将需要显示的文本内容，位置，字体，字体颜色，链接，图片直接传递给Quartz，与其他UI组件相比，能更高效的进行渲染。\n\n   CoreText是不直接支持绘制图片的，我们可以先在需要显示图片的地方用一个特殊的空白占位符代替，同时设置该字体的CTRunDelegate信息为要显示的图片的宽度和高度，这样绘制文字的时候就会先把图片的位置留出来，再在drawRect方法里面用 CGContextDrawImage绘制图片。";
    //相当于模型层，用于管理文本的底层存储，以及如何定义文本显示的样式。高亮显示功能的主要代码都是在这个类中完成的。
    NSTextStorage *storage = [[NSTextStorage alloc] initWithString:str];
    
    //相当于控制器层，它负责把 NSTextStorage 的文本内容绘制到相应的视图上，并且它还负责文字的排版处理等。
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    [storage addLayoutManager:layoutManager];

    //定义了文本在 UITextView 上面的显示区域。
    NSTextContainer *textContainer = [[NSTextContainer alloc]initWithSize:_textView.bounds.size];
    [layoutManager addTextContainer:textContainer];
    
    // 给TextView添加带有内容和布局的容器
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) textContainer:textContainer];
    _textView.backgroundColor = RGB(235, 235, 235);
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.editable      = NO;
    _textView.delegate = self;
    _tableView.tableHeaderView = _textView;
    
    //设置常规属性
    [self setupNormalAttribute];
    //链接和表情
    [self setupEmojiAndLink];
    //正则表达式遍历文本 找出特定词
    [self selectWord:@"图片" inTextStorage:storage];

}
- (void)selectWord:(NSString *)word inTextStorage:(NSTextStorage *)storage{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:word options:0 error:nil];
    NSArray *matchs = [regex matchesInString:_textView.text options:0 range:NSMakeRange(0, [_textView.text length])];
    for (NSTextCheckingResult *match in matchs) {
        NSRange matchRange = [match range];
        [storage addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:matchRange];
    }
}
#pragma mark ---向文本中添加图片，链接
- (void)setupEmojiAndLink
{
    
    NSMutableAttributedString * mutStr = [self.textView.attributedText mutableCopy];
    //添加图片
    UIImage * image1 = [UIImage imageNamed:@"live_photo_6"];
    NSTextAttachment * attachment1 = [[NSTextAttachment alloc] init];
    attachment1.bounds = CGRectMake(0, 0, kScreenWidth - 0, 200);
    attachment1.image = image1;
    NSAttributedString * attachStr1 = [NSAttributedString attributedStringWithAttachment:attachment1];
    [mutStr insertAttributedString:attachStr1 atIndex:53];
    
    //添加图片
    UIImage * image2 = [UIImage imageNamed:@"live_photo_7"];
    NSTextAttachment * attachment2 = [[NSTextAttachment alloc] init];
    attachment2.bounds = CGRectMake(0, 0, kScreenWidth - 0, 200);
    attachment2.image = image2;
    NSAttributedString * attachStr2 = [NSAttributedString attributedStringWithAttachment:attachment2];
    [mutStr insertAttributedString:attachStr2 atIndex:125];
    
    //添加链接
    [mutStr addAttribute:NSLinkAttributeName
                         value:@"http://www.baidu.com"
                          range:[[mutStr string] rangeOfString:@"百度一下 你就知道"]];
    self.textView.attributedText = [mutStr copy];
}
- (UIImage *)image:(UIImage *)image scaleWithSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
#pragma mark ---设置常规属性
- (void)setupNormalAttribute
{
    NSMutableAttributedString * mutStr = [self.textView.attributedText mutableCopy];
    //颜色
    [mutStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(11, 12)];
    //字体
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:25] range:NSMakeRange(27, 12)];
    //下划线
    [mutStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle | NSUnderlinePatternDot) range:NSMakeRange(27, 12)];
    //空心字
    [mutStr addAttribute:NSStrokeWidthAttributeName value:@(2) range:NSMakeRange(42, 10)];
    //文字间距
    [mutStr addAttribute:NSKernAttributeName value:@(1) range:NSMakeRange(0, self.textView.attributedText.length)];
    
    self.textView.attributedText = [mutStr copy];
}
#pragma mark ---点击图片触发代理事件
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    NSLog(@"%@", textAttachment.image);
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.image = textAttachment.image;
    
    [EnlargeImage showImage:imgView];
    
    return NO;
}

#pragma mark ---点击链接，触发代理事件
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    WebViewController *web = [[WebViewController alloc]init];
    web.url = [URL absoluteString];
    [self.navigationController pushViewController:web animated:NO];
    return NO;
}

@end
