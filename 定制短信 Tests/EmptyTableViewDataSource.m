//
//  EmptyTableViewDataSource.m
//  DZSMSSender
//
//  Created by linx on 13-12-31.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import "EmptyTableViewDataSource.h"

@implementation EmptyTableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end
