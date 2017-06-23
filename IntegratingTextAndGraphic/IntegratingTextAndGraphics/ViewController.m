//
//  ViewController.m
//  IntegratingTextAndGraphics
//
//  Created by Content on 2017/5/15.
//  Copyright © 2017年 flymanshow. All rights reserved.
//

#import "ViewController.h"
#import "CoreTextController.h"
#import "TextKitController.h"
#import "NewsViewController.h"

@interface ViewController ()

@property (nonatomic,strong)NSArray *titleArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _titleArray = @[@"CoreText",@"news demo",@"TextKit"];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellID = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell){
    
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle = NO;
        
    }
     cell.textLabel.text = _titleArray[indexPath.row];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0) {
        
        CoreTextController *vc = [[CoreTextController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row==1){
     
        NewsViewController *vc = [[NewsViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    
    }else if (indexPath.row==2){
    
        TextKitController *vc = [[TextKitController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
        
    }

}
@end
