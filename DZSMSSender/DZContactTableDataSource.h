//
//  DZContactTableDataSource.h
//  DZSMSSender
//
//  Created by linx on 13-11-21.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZContactTableDataSource : NSObject<UITableViewDataSource>
//联系人数组，电话本中的顺序，没有进行排序
@property(nonatomic) NSMutableArray *personArray;
//使用姓名拼音排序后的联系人数组
@property(nonatomic,readonly) NSMutableArray *sortedPersonArray;
//姓名按字母索引后的字典
@property(nonatomic)NSMutableDictionary *personDic;
@property(nonatomic)NSMutableArray *sortedKeys;
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSIndexPath *)IndexPathByIndex:(NSIndexPath *)index;
@end
