//
//  DZContactControllerTest.m
//  DZSMSSender
//
//  Created by linx on 13-12-31.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "DZContactController.h"
#import "EmptyTableViewDataSource.h"
#import "EmptyTableViewDelegate.h"

@interface DZContactControllerTest : XCTestCase

@end

@implementation DZContactControllerTest{
    DZContactController *viewController;
    UITableView *tableView;
}

- (void)setUp
{
    [super setUp];
    viewController = [[DZContactController alloc] init];
    tableView = [[UITableView alloc] init];
    viewController.tableView = tableView;
}

- (void)tearDown
{
    viewController = nil;
    tableView = nil;
    [super tearDown];
}

- (void)testViewControllerHasATableViewProperty
{
    objc_property_t tableViewProperty = class_getProperty([viewController class], "tableView");
    XCTAssertTrue(tableViewProperty != NULL, @"DZContactController needs a table view");
}

-(void)testViewControllerHasADataSourceProperty{
    objc_property_t dataSourceProperty = class_getProperty([viewController class], "dataSource");
    XCTAssertTrue(dataSourceProperty != NULL, @"DZContactController needs a data source");
}

-(void)testViewControllerHasADelegateProperty{
    objc_property_t delegateProperty = class_getProperty([DZContactController class], "tableViewDelegate");
    XCTAssertTrue(delegateProperty != NULL, @"DZContactController needs a table view delegate");
}

-(void)testViewControllerConnectsDataSourceInViewDidLoad{
    id<UITableViewDataSource> dataSource = [[EmptyTableViewDataSource alloc] init];
    viewController.dataSource = dataSource;
    [viewController viewDidLoad];
    XCTAssertEqual([tableView dataSource], dataSource, @"View controller should have set the table view's data source");
}

-(void)testViewControllerConnectsDelegateInViewDidLoad{
    id<UITableViewDelegate> delegate = [[EmptyTableViewDelegate alloc] init];
    viewController.tableViewDelegate = delegate;
    [viewController viewDidLoad];
    XCTAssertEqual([tableView delegate], delegate, @"View controller should have set the table view's delegate");
}
@end
