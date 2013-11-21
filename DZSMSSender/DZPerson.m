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

-(NSString *) fistrLetterOfFullName{
    NSString *firstLetter;
    if (self.fullName.length == 0 || self.fullName == NULL) {
        firstLetter = @"#";
    }else{
        firstLetter =[[NSString stringWithFormat:@"%c",pinyinFirstLetter([self.fullName characterAtIndex:0])] uppercaseString];
    }
    return firstLetter;
}
@end
