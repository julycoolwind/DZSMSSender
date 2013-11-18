//
//  DZPerson.m
//  DZSMSSender
//
//  Created by linx on 13-8-26.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import "DZPerson.h"

@implementation DZPerson

-(id)init{
    self = [super init];
    self.phones = [[NSMutableArray alloc]init];
    self.personIndex = [[NSNumber alloc] init];
    return self;
}
@end
