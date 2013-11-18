//
//  DZPerson.h
//  DZSMSSender
//
//  Created by linx on 13-8-26.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZPerson : NSObject
@property (strong,nonatomic) NSString *fullName;
@property (strong,nonatomic) NSString *nickName;
@property (strong,nonatomic) NSString *namePinyin;
@property (strong,nonatomic) NSMutableArray *phones;
@property (strong, nonatomic) NSNumber *personIndex;
@end
