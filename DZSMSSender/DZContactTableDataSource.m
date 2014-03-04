//
//  DZContactTableDataSource.m
//  DZSMSSender
//
//  Created by linx on 13-11-21.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import "DZContactTableDataSource.h"
#import "DZPerson.h"
#import "DZContactCell.h"
#import "DZPhone.h"

@implementation DZContactTableDataSource

-(id)init
{
    self = [super init];
    _personDic = [[NSMutableDictionary alloc]init];
    _sortedKeys = [[NSMutableArray alloc]init];
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sortedKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount = 0;
    for (DZPerson *person in [_personDic objectForKey:[_sortedKeys objectAtIndex:section]]) {
        rowCount += person.phones.count==0?1:person.phones.count;
    }
    return rowCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DZContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //修改为从模型数组读取。
        cell = [[DZContactCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    if(self.personArray.count >0){
        NSIndexPath *path = [self IndexPathByIndex:indexPath.row];
        //增加一个判断这个cell是显示人名还是电话的方法。
        cell.textLabel.text = [(DZPerson *)[self.personArray objectAtIndex:0] fullName];
        cell.detailTextLabel.text = [(DZPhone *)[[(DZPerson *)[self.personArray objectAtIndex:0] phones] objectAtIndex:0] phoneString];
    }
    return cell;
}

-(NSIndexPath *)IndexPathByIndex:(NSInteger)index{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    if(index == 0) return path;
    NSInteger count = 0;
    NSInteger i;
    NSInteger phonesCount = 0;
    for (i  = 0; i < self.personArray.count; i ++) {
        DZPerson *person = (DZPerson *)[self.personArray objectAtIndex:count];
        phonesCount = person.phones.count<2?1:person.phones.count-1;
        count += phonesCount;
        if(count == index){
            path = [NSIndexPath indexPathForRow:phonesCount inSection:i];
            break;
        }
        if(count > index){
            path = [NSIndexPath indexPathForRow:phonesCount-(count - index) inSection:i];
            break;
        }
        
    }
    return path;
}

-(void)setPersonArray:(NSMutableArray *)personArray
{
    _personArray = personArray;
    
    _sortedPersonArray = [self sortPersonsByPinyinName:_personArray];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}



- (NSMutableArray *)sortPersonsByPinyinName:(NSMutableArray*) personArray
{
    NSMutableArray *sortedArray;
    //根据person的姓名拼音进行排序
    sortedArray = (NSMutableArray *)[personArray sortedArrayUsingComparator:^NSComparisonResult(DZPerson *person1, DZPerson *person2) {
        return [person1.namePinyin compare:person2.namePinyin];
    }];
    [_personDic removeAllObjects];
    [_sortedKeys removeAllObjects];
    //遍历排序后的person数组让每个person对象记录自己的索引号，索引号用于点击时记录那个person对象被选中
    for(int i = 0 ;i<sortedArray.count ; i++){
        DZPerson *person = [sortedArray objectAtIndex:i];
        person.personIndex = [NSNumber numberWithInt:i];
        
        if([_personDic objectForKey:person.fistrLetterOfFullName]==NULL){
            NSMutableArray *items = [[NSMutableArray alloc] init];
            [items addObject:person];
            [_personDic setObject:items forKey:person.fistrLetterOfFullName];
            [_sortedKeys addObject:person.fistrLetterOfFullName];
        }else{
            [[_personDic objectForKey:person.fistrLetterOfFullName] addObject:person];
        }

    }
    return sortedArray;
}

@end
