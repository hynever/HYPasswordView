//
//  HYPasswordView.m
//  HYPasswordField
//
//  Created by 黄勇 on 14/12/29.
//  Copyright (c) 2014年 黄勇. All rights reserved.
//

#import "HYPasswordView.h"

#pragma mark - HYPasswordFieldModel的类
@implementation HYPasswordFieldModel
+(instancetype)hyPasswordFieldModelWithSize:(CGSize)fieldSize margin:(CGFloat)fieldMargin count:(NSInteger)fieldCount
{
    HYPasswordFieldModel *model = [[HYPasswordFieldModel alloc] init];
    model.fieldSize = fieldSize;
    model.fieldMargin = fieldMargin;
    model.fieldCount = fieldCount;
    return model;
}
@end

#pragma mark - HYPasswordField的类
@interface HYPasswordField : UITextField<UITextFieldDelegate>

+(instancetype)hyPasswordFieldWithFrame:(CGRect)frame;

+(instancetype)hyPasswordField;

@end

@implementation HYPasswordField
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.secureTextEntry = YES; //设置为密码形式
        self.textAlignment = NSTextAlignmentCenter;
        self.borderStyle = UITextBorderStyleRoundedRect;
    }
    return self;
}

+(instancetype)hyPasswordField
{
    HYPasswordField *passwordField = [[HYPasswordField alloc] init];
    return passwordField;
}

+(instancetype)hyPasswordFieldWithFrame:(CGRect)frame
{
    HYPasswordField *passwordField = [[HYPasswordField alloc] initWithFrame:frame];
    return passwordField;
}
@end



#pragma mark - HYPasswordVew的类
@interface HYPasswordView()<UITextFieldDelegate>

@property(nonatomic,strong) NSMutableArray *allField;

@property(nonatomic,strong) UITextField *textField;

@end

@implementation HYPasswordView

/*
 *  根据宽度以及field之间的间距设置这个view
 */
+(instancetype)hyPasswordViewWithWidthFieldModel:(HYPasswordFieldModel *)model
{
    HYPasswordView *passwordView = [[HYPasswordView alloc] init];
    passwordView.passwordFieldModel = model;
    return passwordView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        //初始化相关数据
        self.allField = [NSMutableArray array];
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.textField.font = [UIFont systemFontOfSize:0];
        self.textField.backgroundColor = [UIColor clearColor];
        self.textField.delegate = self;
        [self.textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self.textField becomeFirstResponder];
        [self addSubview:self.textField];
    }
    return self;
}

-(void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _keyboardType = keyboardType;
    self.textField.keyboardType = keyboardType;
}

-(void)setPasswordFieldModel:(HYPasswordFieldModel *)passwordFieldModel
{
    _passwordFieldModel = passwordFieldModel;
    NSInteger fieldCount = passwordFieldModel.fieldCount;
    CGFloat fieldMargin = passwordFieldModel.fieldMargin;
    CGSize fieldSize = passwordFieldModel.fieldSize;
    for (int i = 0; i < fieldCount; i++) {
        HYPasswordField *passwordField = [HYPasswordField hyPasswordField];
        passwordField.tag = i;
        [passwordField setFrame:CGRectMake(i*(fieldMargin+fieldSize.width), 0, fieldSize.width, fieldSize.height)];
        passwordField.enabled = NO;
        [self addSubview:passwordField];
        [self.allField addObject:passwordField];
    }
    self.frame = CGRectMake(0, 0, fieldCount*fieldSize.width+(fieldCount-1)*fieldMargin, fieldSize.height);
}

-(void)setFrame:(CGRect)frame
{
    NSInteger fieldCount = self.passwordFieldModel.fieldCount;
    CGFloat fieldMargin = self.passwordFieldModel.fieldMargin;
    CGSize fieldSize = self.passwordFieldModel.fieldSize;
    CGSize size = CGSizeMake(fieldCount*fieldSize.width+(fieldCount-1)*fieldMargin, fieldSize.height);
    frame.size = size;
    [super setFrame:frame];
}

-(void)setIsBecomeFirstResponder:(BOOL)isBecomeFirstResponder
{
    _isBecomeFirstResponder = isBecomeFirstResponder;
    if (isBecomeFirstResponder) {
        [self.textField becomeFirstResponder];
    }else{
        [self.textField resignFirstResponder];
    }
}

#pragma mark 清除所有的密码字符串
-(void)clearPassword
{
    _passwordStr = nil;
    [self.allField enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HYPasswordField *field = (HYPasswordField *)obj;
        field.text = @"";
    }];
}


#pragma mark 代理方法
-(void)hyPasswordFieldEndInput:(HYPasswordField *)passwordField
{
    NSInteger nextTag = passwordField.tag+1;
    if (nextTag < self.passwordFieldModel.fieldCount) {
        HYPasswordField *field = (HYPasswordField *)self.allField[nextTag];
        [field becomeFirstResponder];
    }else{
        [self resignFirstResponder];
    }
}

-(void)textFieldValueChanged:(UITextField *)textField
{
    NSString *inputText = textField.text;
    if (inputText.length == self.passwordFieldModel.fieldCount) {
        _passwordStr = inputText;
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(hyPasswordDidEndInput:andPasswordStr:)]) {
                [self.delegate hyPasswordDidEndInput:self andPasswordStr:self.passwordStr];
            }
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location < self.passwordFieldModel.fieldCount) {
        HYPasswordField *field = (HYPasswordField *)self.allField[range.location];
        field.text = string;
        return YES;
    }
    return NO;
}

@end
