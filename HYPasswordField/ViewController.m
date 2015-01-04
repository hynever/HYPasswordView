//
//  ViewController.m
//  HYPasswordField
//
//  Created by 黄勇 on 14/12/29.
//  Copyright (c) 2014年 黄勇. All rights reserved.
//

#import "ViewController.h"
#import "HYPasswordView.h"

@interface ViewController ()<UITextFieldDelegate,HYPasswordViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HYPasswordFieldModel *model = [HYPasswordFieldModel hyPasswordFieldModelWithSize:CGSizeMake(50, 50) margin:5 count:4];
    HYPasswordView *passwordView = [HYPasswordView hyPasswordViewWithWidthFieldModel:model];
    passwordView.frame = CGRectMake(100, 100, 100, 100);
    passwordView.delegate = self;
    [self.view addSubview:passwordView];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"range:%@",NSStringFromRange(range));
    NSLog(@"string:%@",string);
    return YES;
}

-(void)hyPasswordDidEndInput:(HYPasswordView *)passwordView andPasswordStr:(NSString *)passwordStr
{
    NSLog(@"%@",passwordStr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
