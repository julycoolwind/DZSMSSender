//
//  DZPersonTest.m
//  DZSMSSender
//
//  Created by linx on 13-11-19.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/NSArray.h>
#import "DZPerson.h"

@interface DZPersonTest : XCTestCase

@end

@implementation DZPersonTest
DZPerson *person;
- (void)setUp
{
    [super setUp];
    person = [[DZPerson alloc]init];
    person.fullName = @"fullName";
    person.nickName = @"nickName";
    //person.namePinyin = @"namePinyin";
    person.personIndex = @3;
    
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    person = nil;
}

- (void)testPersonShouldHasAFullName
{
    XCTAssertEqual(person.fullName, @"fullName",@"person do not has the name we set");
}

-(void)testSetChineseFullnameGetNamePinyin
{
    person.fullName = @"张三";
    XCTAssertEqualObjects(person.namePinyin, @"ZhangSan", @"set chinese name to person can not get namepinyin");
}

-(void)testPersonSholeHasANickName
{
    XCTAssertEqual(person.nickName, @"nickName",@"person do not has the name we set");
}

-(void)testPersonSholeHasANamePinyin
{
    XCTAssertEqualObjects(person.namePinyin, @"Fullname",@"person do not has the name we set");
}

-(void)testPersonSholeHasAPersonIndex
{
    XCTAssertEqual(person.personIndex, @3,@"person do not has the name we set");
}

-(void)testInitPersonShouleHasPhonesArray
{
    XCTAssertTrue([person.phones isKindOfClass:[NSMutableArray class]] , @"The Person init with out phone array");
}

-(void)testPersonSetedNameHasFistletter
{
    XCTAssertNotNil(person.fistrLetterOfFullName, @"person should has a fist letter of name");
}

-(void)testFirstLetterOfEmaptyName
{
    person.fullName =@"";
    XCTAssertEqualObjects(person.fistrLetterOfFullName, @"#", @"person has a emapty name should has a firstletter '#'");
}

-(void)testFirstLetterOfNullName
{
    person.fullName =nil;
    XCTAssertEqualObjects(person.fistrLetterOfFullName, @"#", @"person has a NULL name should has a firstletter '#'");
}

-(void)testFirstLetterOfChineseName
{
    //中文转拼音使用的是第三方的库，所以测试一个中文即可
    person.fullName = @"赵";
    XCTAssertEqualObjects(person.fistrLetterOfFullName, @"Z", @"person has a '赵' name should has a firstletter 'z'");
}



@end
