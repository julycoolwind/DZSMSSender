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
    return nil;
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
