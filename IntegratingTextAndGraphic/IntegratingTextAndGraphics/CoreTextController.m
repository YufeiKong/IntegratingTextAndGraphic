//
//  CoreTextController.m
//  IntegratingTextAndGraphics
//
//  Created by Content on 2017/5/22.
//  Copyright © 2017年 flymanshow. All rights reserved.
//

#import "CoreTextController.h"
#import "DisplayView.h"
#import "FrameParserConfig.h"
#import "FrameParser.h"
#import "NetWorkTool.h"
#import "YODNewsModel.h"

@interface CoreTextController ()
@property(nonatomic,strong)NSString *netWorkPath;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)YODNewsModel *newsModel;
@property (nonatomic,strong)NSAttributedString *attributedStr;
@end

@implementation CoreTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];

}
-(void)initUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-0) style:UITableViewStylePlain];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = RGB(235, 235, 235);
    [self.view addSubview:_tableView];
    
    //图文混排视图view
    DisplayView *displayView = [[DisplayView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 0)];
    displayView.backgroundColor = RGB(235, 235, 235);
    
    //配置文本属性信息
    FrameParserConfig *config = [[FrameParserConfig alloc] init];
    config.width = displayView.bounds.size.width;
    config.textColor = [UIColor redColor];
    config.lineSpace = 10;
    config.fontSize = 17;
    config.FontName = @"Helvetica-Bold";
    
    //初始化data模型
    CoreTextData *data= [FrameParser parseTemplateFile:_netWorkPath config:config];
    displayView.data = data;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, displayView.bounds.size.height)];
    [view addSubview:displayView];
    _tableView.tableHeaderView = view;
    
}
- (void)initData {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"  CoreText是用于文字精细排版的文本框架。它直接与CoreGraphics交互，将需要显示的文本内容，位置，字体，字体颜色，链接，图片直接传递给Quartz，与其他UI组件相比，能更高效的进行渲染。\n CoreText是不直接支持绘制图片的，我们可以先在需要显示图片的地方用一个特殊的空白占位符代替，同时设置该字体的CTRunDelegate信息为要显示的图片的宽度和高度，这样绘制文字的时候就会先把图片的位置留出来，再在drawRect方法里面用 CGContextDrawImage绘制图片。" forKey:@"content"];
    [dict setValue:@"black" forKey:@"default"];
    [dict setValue:@"17" forKey:@"size"];
    [dict setValue:@"text" forKey:@"type"];
    NSString *str1 = [self stringWithObj:dict];
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]init];
    [dict2 setValue:@"百度一下 你就知道" forKey:@"content"];
    [dict2 setValue:@"link" forKey:@"type"];
    [dict2 setValue:@"https://www.baidu.com" forKey:@"url"];
    NSString *str2 = [self stringWithObj:dict2];
    
    
    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]init];
    [dict3 setValue:@"https://imgsa.baidu.com/forum/w%3D580%3B/sign=9107d2cb99ef76c6d0d2fb23ad2dfffa/32fa828ba61ea8d389c574ee9e0a304e241f5870.jpg" forKey:@"content"];
    [dict3 setValue:@"image" forKey:@"type"];
    [dict3 setValue:@(200) forKey:@"height"];
    [dict3 setValue:@(345) forKey:@"width"];
    NSString *str3 = [self stringWithObj:dict3];
    
    NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]init];
    [dict4 setValue:@"  得到当前用于绘制画布的上下文，用于后续将内容绘制在画布上。因为CoreText要配合Core Graphic配合使用的，如CoreGraphic一样，绘图的时候需要获得当前的上下文进行绘制.翻转当前的坐标系。\n CoreText坐标系是以左下角为坐标原点，而我们常使用的UIKit是以左上角为坐标原点，因此在CoreText中的布局完成后需要对其坐标系进行转换，否则直接绘制出现位置反转的镜像情况。" forKey:@"content"];
    [dict4 setValue:@"black" forKey:@"color"];
    [dict4 setValue:@"17" forKey:@"size"];
    [dict4 setValue:@"text" forKey:@"type"];
    NSString *str4 = [self stringWithObj:dict4];
    
    NSMutableDictionary *dict5 = [[NSMutableDictionary alloc]init];
    [dict5 setValue:@"https://imgsa.baidu.com/forum/w%3D580%3B/sign=72280f5de050352ab16125006378f9f2/b8389b504fc2d562cdeed007ee1190ef77c66c71.jpg" forKey:@"content"];
    [dict5 setValue:@"image" forKey:@"type"];
    [dict5 setValue:@(345) forKey:@"height"];
    [dict5 setValue:@(345) forKey:@"width"];
    NSString *str5 = [self stringWithObj:dict5];
    
    NSMutableDictionary *dict6 = [[NSMutableDictionary alloc]init];
    [dict6 setValue:@"live_photo_2.jpg" forKey:@"content"];
    [dict6 setValue:@"image" forKey:@"type"];
    [dict6 setValue:@(200) forKey:@"height"];
    [dict6 setValue:@(345) forKey:@"width"];
    NSString *str6 = [self stringWithObj:dict6];
    
    NSMutableDictionary *dict7 = [[NSMutableDictionary alloc]init];
    [dict7 setValue:@"点击进入微可视下载" forKey:@"content"];
    [dict7 setValue:@"link" forKey:@"type"];
    [dict7 setValue:@"http://121.40.133.100/wecast_shop/share/index.jsp?target=1&os=ios&shareType=3&userId=null&ov=9.3.5&from=singlemessage&isappinstalled=1&nsukey=ShOCPBlVFMraFTG6FDuhIQgpdcJVaCZ3qt6Kz416C%2Bu1ijLYiw%2BWJCibWxeo4jr%2BypAziFfe1S7TbYDTpf3061TnYpj5G7eZKdiihJ6L5FHzyR%2FWsli1e%2Bn5L5rcKM85UxrTTUJcDrEljftVPnVJfwEsCGQsrGtWiNNrn71htfSgLRYnJKQnrHdf7s1Wh%2BqG" forKey:@"url"];
    NSString *str7 = [self stringWithObj:dict7];
    //得到视图文本数据
    _netWorkPath = [NSString stringWithFormat:@"[%@,%@,%@,%@,%@,%@,%@]",str1,str2,str3,str7,str5,str4,str6];
    
}
- (NSString *)stringWithObj:(id)obj{
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:NULL];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end
