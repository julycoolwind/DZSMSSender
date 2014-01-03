//
//  DZPhoneTest.m
//  DZSMSSender
//
//  Created by linx on 14-1-2.
//  Copyright (c) 2014年 linx. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "DZPhone.h"

@interface DZPhoneTest : XCTestCase{
    DZPhone *phone;
}

@end

@implementation DZPhoneTest

- (void)setUp
{
    [super setUp];
    phone = [[DZPhone alloc] init];
}

- (void)tearDown
{
    phone = nil;
    [super tearDown];
}

- (void)testPhoneShouldHasAPhoneNumberProperty
{
    objc_property_t phoneNumber = class_getProperty([DZPhone class], "PhoneNumber");
    XCTAssertTrue(phoneNumber != NULL, @"DZPHone should has a phone number property");
}

-(void)testPhoneShouldHasAPhoneLableProperty{
    objc_property_t phoneLable = class_getProperty([DZPhone class], "PhoneLable");
    XCTAssertTrue(phoneLable != NULL, @"DZPhone should has a phone lable property");
}

-(void)testPhoneStringWithPhoneLableAndNumber{
    phone.PhoneLable = @"lable";
    phone.PhoneNumber = @"1234567";
    XCTAssertTrue([ @"lable1234567" isEqualToString:[phone phoneString]], @"Get the phoneString wrong,with lable and number.");
}

-(void)testPhoneShouldHasAPersonIndexProperty{
    objc_property_t personIndex = class_getProperty([DZPhone class], "PersonIndex");
    XCTAssertTrue(personIndex != NULL, @"DZPhone should has a PersonIndex property");
}



@end
