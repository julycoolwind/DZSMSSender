//
//  DZPhone.h
//  DZSMSSender
//
//  Created by linx on 13-8-26.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZPhone : NSObject
@property (strong,nonatomic) NSString *PhoneNumber;
@property (strong,nonatomic) NSString *PhoneLable;
-(NSString *)phoneString;
@end
