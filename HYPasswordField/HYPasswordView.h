//
//  HYPasswordView.h
//  HYPasswordField
//
//  Created by 黄勇 on 14/12/29.
//  Copyright (c) 2014年 黄勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYPasswordFieldModel : NSObject

@property(nonatomic,assign) CGSize fieldSize;

@property(nonatomic,assign) CGFloat fieldMargin;

@property(nonatomic,assign) NSInteger fieldCount;

+(instancetype)hyPasswordFieldModelWithSize:(CGSize)fieldSize margin:(CGFloat)fieldMargin count:(NSInteger)fieldCount;

@property(nonatomic,assign) UITextBorderStyle borderStyle;

@end


@protocol HYPasswordViewDelegate;
@interface HYPasswordView : UIView

/**
 *  根据宽度以及field之间的间距设置这个view
 */
+(instancetype)hyPasswordViewWithWidthFieldModel:(HYPasswordFieldModel *)model;

@property(nonatomic,strong) HYPasswordFieldModel *passwordFieldModel;

@property(nonatomic,copy,readonly) NSString *passwordStr;

@property(nonatomic,weak) id<HYPasswordViewDelegate> delegate;

@property(nonatomic,assign) BOOL isBecomeFirstResponder;

@property(nonatomic,assign) UIKeyboardType keyboardType;    //键盘类型，默认是数字

-(void)clearPassword;


@end

@protocol HYPasswordViewDelegate <NSObject>

@optional
-(void)hyPasswordDidEndInput:(HYPasswordView *)passwordView andPasswordStr:(NSString *)passwordStr;

@end
