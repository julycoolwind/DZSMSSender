//
//  DZViewController.h
//  DZSMSSender
//
//  Created by linx on 13-8-20.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZViewController : UIViewController<UITextViewDelegate>
@property (strong, nonatomic)  UITextView *SMSText;
@property (strong,nonatomic) UIButton *but_clear;
@end
