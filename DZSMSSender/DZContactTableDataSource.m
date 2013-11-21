//
//  DZContactTableDataSource.m
//  DZSMSSender
//
//  Created by linx on 13-11-21.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import "DZContactTableDataSource.h"
#import "DZPerson.h"

@implementation DZContactTableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(void)setPersonArray:(NSMutableArray *)personArray
{
    _personArray = personArray;
    _sortedPersonArray = [self sortPersonsByPinyinName:_personArray];
}



- (NSMutableArray *)sortPersonsByPinyinName:(NSMutableArray*) personArray
{
    NSMutableArray *sortedArray;
    //根据person的姓名拼音进行排序
    sortedArray = (NSMutableArray *)[personArray sortedArrayUsingComparator:^NSComparisonResult(DZPerson *person1, DZPerson *person2) {
        return [person1.namePinyin compare:person2.namePinyin];
    }];
    //遍历排序后的person数组让每个person对象记录自己的索引号，索引号用于点击时记录那个person对象被选中
    for(int i = 0 ;i<sortedArray.count ; i++){
        DZPerson *person = [sortedArray objectAtIndex:i];
        person.personIndex = [NSNumber numberWithInt:i];
    }
    return sortedArray;
}

@end
