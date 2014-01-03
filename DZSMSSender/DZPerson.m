//
//  DZPerson.m
//  DZSMSSender
//
//  Created by linx on 13-8-26.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import "DZPerson.h"
#import "DZPhone.h"
#import "ChineseToPinyin.h"

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

-(void)setFullName:(NSString *)fullName{
    _fullName = [fullName copy];
    _namePinyin = [ChineseToPinyin pinyinFromChiniseString:fullName];
}

-(void)setPersonIndex:(NSNumber *)personIndex{
    _personIndex = [personIndex copy];
    assert(self.phones != NULL);
    for (DZPhone *phone in self.phones) {
        [phone setPersonIndex:[_personIndex copy]];
    }
}
@end
