//
//  DZContactTableDataSourceTest.m
//  DZSMSSender
//
//  Created by linx on 13-11-21.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DZContactTableDataSource.h"
#import "DZPerson.h"

@interface DZContactTableDataSourceTest : XCTestCase

@end

@implementation DZContactTableDataSourceTest
NSMutableArray *persons;
DZPerson *person;
DZContactTableDataSource* source;
- (void)setUp
{
    [super setUp];
    persons = [[NSMutableArray alloc]init];
    person = [[DZPerson alloc]init];
    person.fullName = @"张三";
    [persons addObject:person];
    person = [[DZPerson alloc]init];
    person.fullName = @"李四";
    [persons addObject:person];
    source = [[DZContactTableDataSource alloc]init];
    [source setPersonArray:persons];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testSetPersonArrayToDataSource
{
    NSMutableArray *persons = [[NSMutableArray alloc]init];
    [source setPersonArray:persons];
    XCTAssertEqual(persons, source.personArray, @"Can not set person array to ContactTableSource");
}

-(void)testSetPersonArrayShouldBeSort
{
    XCTAssertEqual([(DZPerson *)[source.sortedPersonArray objectAtIndex:0] fullName], @"李四", @"the person array not sorted by fullname");
    
}

-(void)testSortedPersonHasIndex
{
    
    DZPerson *personTemp;
    for(int i = 0 ;i<source.sortedPersonArray.count;i++){
        personTemp = (DZPerson *)[source.sortedPersonArray objectAtIndex:i];
        XCTAssertEqualObjects([personTemp personIndex], [NSNumber numberWithInt:i], @"the person sorted not have right personindex");
    }
    
    
}

@end
