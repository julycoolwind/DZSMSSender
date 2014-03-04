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
#import "DZPhone.h"

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

-(void)testContactDataSourceHasPersonDictionary
{
    XCTAssertNotNil(source.personDic, @"The ContactDataSource have not PersonDic");
}

-(void)testPersonDicHas2Menber
{
    XCTAssertEqualObjects([NSNumber numberWithInt:source.personDic.count],[NSNumber numberWithInt:2], @"personDic in contactDataSource has wrong item number");
}

-(void)testPersonDicHasMenber_reload
{
    person = [[DZPerson alloc]init];
    NSMutableArray *phones = [[NSMutableArray alloc]initWithObjects:[[DZPhone alloc]init],[[DZPhone alloc]init], nil];
    person.phones = phones;
    [persons removeAllObjects];
    [persons addObject:person];
    [source setPersonArray:persons];
    XCTAssertTrue(source.personDic.count==1, @"do not have right number of count in persondic when reload");
}

-(void)testContactDataSourceHasPersonSortedKeys
{
    XCTAssertNotNil(source.sortedKeys, @"The ContactDataSource have not sortedKeys for PersonDic");
}

-(void)testContactDataSourceSortedKeysHas2Items
{
    
    XCTAssertEqualObjects([NSNumber numberWithInt:source.sortedKeys.count],@2, @"The ContactDataSource  sortedKeys should have 2 itmes");
}

-(void)testContactDataSourceSortedKeysHasRightItems
{
    XCTAssertTrue([source.sortedKeys indexOfObject:@"Z"]>=0 , @"The ContactDataSource sortedDeys do not have item 'Z'");
    XCTAssertTrue([source.sortedKeys indexOfObject:@"L"]>=0 , @"The ContactDataSource sortedDeys do not have item 'L'");
}

-(void)testContactDataSourceHasRightNumberOfSectionsInTableView
{
    XCTAssertTrue([source numberOfSectionsInTableView:nil]==source.sortedKeys.count,@"ContactDataSource do not have right numberOfSectionsInTableView");
}

-(void)testContactDataSourceHasRightNumberOfRowsInSectionBySetup
{
    XCTAssertTrue([source tableView:nil numberOfRowsInSection:0]==1, @"do not have right number of rows in section 0");
    XCTAssertTrue([source tableView:nil numberOfRowsInSection:1]==1, @"do not have right number of rows in section 1");
}

-(void)testContactDataSourceNumberOfRowsInSection_OnePersonHas2Phone
{
    person = [[DZPerson alloc]init];
    NSMutableArray *phones = [[NSMutableArray alloc]initWithObjects:[[DZPhone alloc]init],[[DZPhone alloc]init], nil];
    person.phones = phones;
    [persons removeAllObjects];
    [persons addObject:person];
    [source setPersonArray:persons];
    XCTAssertTrue([source tableView:nil numberOfRowsInSection:0]==2, @"do not have right number of rows in section 0 one person tow phones");
}

-(void)testContactDataSourceNumberOfRowsInSection_3PersonInSameSectionHas2PhoneEachTheLastNoPhone
{
    [persons removeAllObjects];
    NSMutableArray *phones;
    person = [[DZPerson alloc]init];
    phones = [[NSMutableArray alloc]initWithObjects:[[DZPhone alloc]init],[[DZPhone alloc]init], nil];
    person.phones = phones;
    [persons addObject:person];
    person = [[DZPerson alloc]init];
    phones = [[NSMutableArray alloc]initWithObjects:[[DZPhone alloc]init],[[DZPhone alloc]init], nil];
    person.phones = phones;
    [persons addObject:person];
    person = [[DZPerson alloc]init];
    phones = [[NSMutableArray alloc]init];
    person.phones = phones;
    [persons addObject:person];
    [source setPersonArray:persons];
    XCTAssertTrue([source tableView:nil numberOfRowsInSection:0]==5, @"do not have right number of rows in section 0 one person tow phones");
}

-(void)testEditingStyleForRowAtIndexPath{
    XCTAssertTrue([source tableView:nil editingStyleForRowAtIndexPath:nil] == (UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert), @"Table view data source not set the style for row at index path right.");
}

-(void)testCellForRowAtIndexPathOnePersonOnePhone{
    DZPhone *phone = [[DZPhone alloc] init];
    phone.PhoneLable = @"label";
    phone.PhoneNumber = @"1234567";
    DZPerson *person = [[DZPerson alloc]init];
    person.phones = [[NSMutableArray alloc] initWithObjects:phone, nil];
    person.fullName = @"张三";
    person.nickName = @"老三";
    person.personIndex = @3;
    source.personArray = [[NSMutableArray alloc]initWithObjects:person, nil];
    UITableViewCell *cell = [source tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertTrue([cell.textLabel.text isEqualToString:@"张三"],@"The text label not right when person has a name.");
    XCTAssertTrue([cell.detailTextLabel.text isEqualToString:@"label1234567"],@"The detailTextLabel not right with person has a phone");
}

-(void)testCellForRowAtIndexPathOnePersonTwoPhone{
    DZPhone *phone1 = [[DZPhone alloc] init];
    phone1.PhoneLable = @"label";
    phone1.PhoneNumber = @"1234567";
    DZPhone *phone2 = [[DZPhone alloc] init];
    phone2.PhoneLable = @"label1";
    phone2.PhoneNumber = @"12345678";
    DZPerson *person = [[DZPerson alloc]init];
    person.phones = [[NSMutableArray alloc] initWithObjects:phone1,phone2, nil];
    person.fullName = @"张三";
    person.nickName = @"老三";
    person.personIndex = @3;
    source.personArray = [[NSMutableArray alloc]initWithObjects:person, nil];
    UITableViewCell *cell = [source tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    XCTAssertTrue([cell.textLabel.text isEqualToString:@"张三"],@"The text label not right when person has a name.");
    XCTAssertTrue([cell.detailTextLabel.text isEqualToString:@"label1234567"],@"The detailTextLabel not right with person has a phone");
    cell = [source tableView:nil cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    XCTAssertEqualObjects(cell.detailTextLabel.text, @"label112345678", @"The text label not right when person has a name.");

}

-(void)testGetIndexPathOfPersonPhoneArrayByIndex{
    DZPhone *phone1 = [[DZPhone alloc] init];
    phone1.PhoneLable = @"label";
    phone1.PhoneNumber = @"1234567";
    DZPhone *phone2 = [[DZPhone alloc] init];
    phone2.PhoneLable = @"label1";
    phone2.PhoneNumber = @"12345678";
    DZPerson *person = [[DZPerson alloc]init];
    person.phones = [[NSMutableArray alloc] initWithObjects:phone1,phone2, nil];
    person.fullName = @"张三";
    person.nickName = @"老三";
    person.personIndex = @3;
    source.personArray = [[NSMutableArray alloc]initWithObjects:person, nil];
    NSIndexPath *path = [source IndexPathByIndex:0];
    XCTAssertTrue([path section] == 0, @"section offered by IndexPathByIndex not right");
    XCTAssertTrue([path row] == 0, @"Row Offered by IndexPathByIndex not right" );
    path = [source IndexPathByIndex:1];
    XCTAssertTrue([path section] == 0, @"section offered by IndexPathByIndex not right");
    XCTAssertTrue([path row] == 1, @"Row Offered by IndexPathByIndex not right" );
}
@end
