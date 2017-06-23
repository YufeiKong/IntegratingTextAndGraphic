//
//  CommentView.m
//  wecast
//
//  Created by Content on 17/2/28.
//  Copyright © 2017年 张芳涛. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
       
        self.backgroundColor = [UIColor whiteColor];
        
        self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(AutoSize(24), AutoSize(12), AutoSize(72), AutoSize(72))];
        self.icon.layer.cornerRadius = self.icon.mj_w / 2;
        self.icon.layer.masksToBounds = YES;
        self.icon.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.icon.layer.borderWidth = AutoSize(0.5);
        [self addSubview:self.icon];
        
        self.textField = [[UITextField alloc]initWithFrame:CGRectMake(self.icon.mj_maxX+AutoSize(36), AutoSize(10), AutoSize(348), AutoSize(76))];
        self.textField.keyboardType = UIKeyboardTypeNamePhonePad;
        self.textField.returnKeyType = UIReturnKeySend;
        self.textField.delegate = self;
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        self.textField.placeholder = @"说点什么";
        self.textField.layer.borderWidth = AutoSize(1);
        self.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.textField.layer.cornerRadius = AutoSize(6);
        self.textField.enabled = NO;
        [self addSubview:self.textField];
        
        
        self.commentIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.textField.mj_maxX+AutoSize(16),AutoSize(24) , AutoSize(48), AutoSize(48))];
        [self.commentIcon setImage:[UIImage imageNamed:@"details_comment_page"]];
        [self addSubview:self.commentIcon];
        
        self.commentNum = [[UIButton alloc]initWithFrame:CGRectMake(self.commentIcon.mj_maxX-AutoSize(10), AutoSize(24), AutoSize(120), AutoSize(48))];
        self.commentNum.titleLabel.textAlignment = NSTextAlignmentLeft;
       // self.commentNum.centerY = self.commentIcon.centerY;
        self.commentNum.center = self.commentIcon.center;
  
        self.commentNum.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.commentNum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:self.commentNum];
        
        
        self.shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-AutoSize(36+48),AutoSize(23) , AutoSize(48), AutoSize(48))];
        [self.shareBtn setImage:[UIImage imageNamed:@"details_share_page"] forState:UIControlStateNormal];
        [self.shareBtn setImage:[UIImage imageNamed:@"detai·ls_share_page"] forState:UIControlStateHighlighted];
        [self addSubview:self.shareBtn];
        
    }
    return self;
}

@end
