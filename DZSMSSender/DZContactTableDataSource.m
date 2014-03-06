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
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSIndexPath *path = [self IndexPathByIndex:indexPath];
    //如果分了section要考虑，不能直接使用section
    if([self isCellIndexAtPerson:indexPath.row onPersonArray:[self.personDic objectForKey:[self.sortedKeys objectAtIndex:indexPath.section]]]){
        [self loadPersonAndOnePhone:cell personIndex:path.section fromPersonArray: [self.personDic objectForKey:[self.sortedKeys objectAtIndex:indexPath.section]]];
    }else{
        [self loadPhoenAt:path.row onPersonAt:path.section to:cell fromPersonArray:[self.personDic objectForKey:[self.sortedKeys objectAtIndex:indexPath.section]]];
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sortedKeys objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.sortedKeys;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

-(BOOL)isCellIndexAtPerson:(int)index onPersonArray:(NSArray *)personList{
    NSInteger i;
    NSInteger phonesCount = 0;
    NSInteger count = 0;
    Boolean result = false;
    for (i  = 0; i < personList.count; i ++) {
        DZPerson *person = (DZPerson *)[personList objectAtIndex:count];
        phonesCount = person.phones.count<2?1:person.phones.count-1;
        count += phonesCount;
        if(count-1 == index){
            result = true;
            break;
        }
        if(count-1 > index){
            break;
        }
        
    }
    return result;
}

-(void)loadPersonAndOnePhone:(UITableViewCell *)cell personIndex:(int)personIndex fromPersonArray:(NSArray *) personList{
    cell.textLabel.text =[(DZPerson *)[personList objectAtIndex:personIndex] fullName];
    if ([(DZPerson *)[personList objectAtIndex:personIndex] phones].count>0) {
        cell.detailTextLabel.text = [(DZPhone *)[[(DZPerson *)[personList objectAtIndex:personIndex] phones] objectAtIndex:0] phoneString];
    }
}

-(void)loadPhoenAt:(int)phoneIndex onPersonAt:(int)personIndex to:(UITableViewCell*)cell fromPersonArray:(NSArray *) personList{
    DZPerson *person =(DZPerson *)[personList objectAtIndex:personIndex];
    cell.detailTextLabel.text = [(DZPhone *)[person.phones objectAtIndex:phoneIndex] phoneString];
}
//根据table的index获取一个NSIndexPath对象，使用path的section表示person的下表，row表示person中电话的下标
-(NSIndexPath *)IndexPathByIndex:(NSIndexPath *) index{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    NSMutableArray *personesInSection= [self.personDic objectForKey:[self.sortedKeys objectAtIndex:index.section]];
    if(index == 0) return path;
    NSInteger count = 0;
    NSInteger i;
    NSInteger phonesCount = 0;
    for (i  = 0; i < personesInSection.count; i ++) {
        DZPerson *person = (DZPerson *)[personesInSection objectAtIndex:count];
        phonesCount = person.phones.count<2?1:person.phones.count-1;
        count += phonesCount;
        if(count == index.row){
            path = [NSIndexPath indexPathForRow:phonesCount inSection:i];
            break;
        }
        if(count > index.row){
            path = [NSIndexPath indexPathForRow:phonesCount-(count - index.row) inSection:i];
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
