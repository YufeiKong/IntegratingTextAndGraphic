//
//  ViewController.m
//  IntegratingTextAndGraphics
//
//  Created by Content on 2017/5/15.
//  Copyright © 2017年 flymanshow. All rights reserved.
//

#import "NewsViewController.h"
#import "DisplayView.h"
#import "FrameParserConfig.h"
#import "FrameParser.h"
#import "NetWorkTool.h"
#import "YODNewsModel.h"
#import "CommentView.h"

@interface NewsViewController ()<UITextViewDelegate>

@property (nonatomic,strong)NSMutableString *netWorkPath;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)YODNewsModel *newsModel;
@property (nonatomic,strong)NSAttributedString *attributedStr;
@property (nonatomic,strong)NSMutableArray *dictArray;
@property (nonatomic,strong)CommentView *inputView;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
     _inputView = [[CommentView alloc]initWithFrame:CGRectMake(0, kScreenHeight - AutoSize(96), kScreenWidth, AutoSize(96))];
    [self.view addSubview:_inputView];
    [self getData];

}
-(void)getData{
    
    LoadingView *loadView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, AutoSize(162), AutoSize(162))];
    loadView.center = self.view.center;
    loadView.mj_y = loadView.mj_y - 20;
    loadView.tag = 1112;
    [self.view addSubview:loadView];
    [loadView show];
    
    [NetWorkTool GET:@"http://wcst-shop.yod.com/wcst-shop/newsDetail.do?newsId=154&os=ios&uid=779E0320-0D08-4261-BCD7-5BAA02E9D0F0&imei=779E0320-0D08-4261-BCD7-5BAA02E9D0F0&ov=10.3.1&h=667&model=iPhone&w=375" Params:nil Success:^(id requestData) {
        for (UIView *view in self.view.subviews) {
            if (view.tag == 1112) {
                LoadingView *v = (LoadingView *)view;
                [v hide];
            }
        }
        NSDictionary *dictData = [requestData objectForKey:@"news"];
        NSString *content = dictData[@"content"];
        NSLog(@"%@--content",content);
        
        self.newsModel = [YODNewsModel mj_objectWithKeyValues:dictData];
        NSString *document = self.newsModel.content;
        NSArray *array = [self removeHTML:document];
        NSString *fileStr;
        _netWorkPath = [NSMutableString string];
        [_netWorkPath appendString:@"["];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        for (int i=0; i<array.count; i++) {
            
        NSString *str = [array objectAtIndex:i];
        if ([str containsString:@"http"]) {//加载图片
       
        [dict setValue:str forKey:@"content"];
        [dict setValue:@"image" forKey:@"type"];
        [dict setValue:@(245) forKey:@"height"];
        [dict setValue:@(345) forKey:@"width"];
            
        }else{//加载文本内容
        
        [dict setValue:[@"\n    " stringByAppendingString:str] forKey:@"content"];
        [dict setValue:@"text" forKey:@"type"];
            
        }
        fileStr =  [self stringWithObj:dict];
        if (i == array.count-1) {
            
        [_netWorkPath appendFormat:@"%@]",fileStr];
            
        }else{
        
        [_netWorkPath appendFormat:@"%@,",fileStr];
            
        }
     }
      [self setNewsHeaderViewWithTitle:self.newsModel.title cource:self.newsModel.source time:self.newsModel.inputTime];
        
    } Failure:^(NSInteger code, NSError *error) {
        
        for (UIView *view in self.view.subviews) {
            if (view.tag == 1112) {
                LoadingView *v = (LoadingView *)view;
                [v hide];
            }
        }
        
    }];
}
#pragma mark ---设置新闻的标题和新闻内容
-(void)setNewsHeaderViewWithTitle:(NSString *)title cource:(NSString *)source  time:(NSString *)time {
    
    UIView *headerView = [[UIView alloc]init];
    #pragma amrk ---头部标题
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    CGSize titleLabelSzie = [title boundingRectWithSize:CGSizeMake(kScreenWidth - AutoSize(36) - AutoSize(28), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.frame = CGRectMake(AutoSize(36), AutoSize(48),titleLabelSzie.width, titleLabelSzie.height);
    titleLabel.numberOfLines = 0;
    [headerView addSubview:titleLabel];
    titleLabel.text = title;
    
    UIButton *sourceBtn = [[UIButton alloc]initWithFrame:CGRectMake(AutoSize(36), AutoSize(84 + 2 * titleLabel.mj_h), AutoSize(80), AutoSize(40))];
    sourceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [sourceBtn setTitle:@"来源" forState:UIControlStateNormal];
    [sourceBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [sourceBtn setBackgroundColor:[UIColor blueColor]];
    sourceBtn.userInteractionEnabled = NO;
    [headerView addSubview:sourceBtn];
    
    UILabel *sourceLabel = [[UILabel alloc]initWithFrame:CGRectMake(AutoSize(120) + AutoSize(40), AutoSize(84 + 2 * titleLabel.mj_h), AutoSize(2 *kScreenWidth), AutoSize(40))];
    sourceLabel.text = source;
    sourceLabel.font = [UIFont systemFontOfSize:14];
    sourceLabel.textAlignment = NSTextAlignmentLeft;
    [sourceLabel sizeToFit];
    [headerView addSubview:sourceLabel];
    #pragma amrk ---底部新闻
    //图文混排视图view
    DisplayView *displayView = [[DisplayView alloc] initWithFrame:CGRectMake(15, sourceBtn.mj_maxY+AutoSize(30), kScreenWidth - 30, 0)];
    displayView.backgroundColor = [UIColor whiteColor];
    
    //配置文本属性信息
    FrameParserConfig *config = [[FrameParserConfig alloc] init];
    config.width = displayView.bounds.size.width;
    config.textColor = [UIColor blackColor];
    config.lineSpace = 9;
    config.fontSize = 15;
    
    //初始化data模型
    CoreTextData *data= [FrameParser parseTemplateFile:_netWorkPath config:config];
    displayView.data = data;
    [headerView addSubview:displayView];
    
    headerView.frame = CGRectMake(0, 0, kScreenWidth, displayView.bounds.size.height+sourceBtn.mj_maxY+AutoSize(30+100));
    self.tableView.tableHeaderView = headerView;
    
}
#pragma mark ---去除html里的标签
- (NSArray *)removeHTML:(NSString *)html{
    
    NSArray *components = [html componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSMutableArray *componentsToKeep = [NSMutableArray array];
    
    for (int i = 0; i < components.count;  i= i+1) {
        NSString *str = [components objectAtIndex:i];
        
        //只保留文本内容和图片地址
        if ([self IsChinese:str]||[str containsString:@"img src"])
        {
        if ([str containsString:@"img src"]) {
   
        NSRange startRange = [str rangeOfString:@"\""];
        NSRange endRange = [str rangeOfString:@"\" title"];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *result = [str substringWithRange:range];
        NSLog(@"%@",result);
        [componentsToKeep addObject:result];
            
        }else{
            
        str = [@"   " stringByAppendingString:str];
        [componentsToKeep addObject:str];
        
        }
      }
    }
    return componentsToKeep;
}
#pragma mark ---判断输入的是否包含中文
-(BOOL)IsChinese:(NSString *)str
{
    for(int i=0; i< [str length];i++)
    {
    int a = [str characterAtIndex:i];
    if( a > 0x4e00 && a < 0x9fff)
    {
        return YES;
    }
  }
    return NO;
}
- (NSString *)stringWithObj:(id)obj{
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:NULL];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end
