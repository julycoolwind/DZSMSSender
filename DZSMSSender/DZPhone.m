//
//  DZPhone.m
//  DZSMSSender
//
//  Created by linx on 13-8-26.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import "DZPhone.h"

@implementation DZPhone

-(NSString *)phoneString{
    return [NSString stringWithFormat:@"%@%@",self.PhoneLable,self.PhoneNumber];
}
@end
