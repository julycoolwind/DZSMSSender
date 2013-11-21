//
//  DZContactTableDataSource.h
//  DZSMSSender
//
//  Created by linx on 13-11-21.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZContactTableDataSource : NSObject<UITableViewDataSource>
@property(nonatomic) NSMutableArray *personArray;
@property(nonatomic,readonly) NSMutableArray *sortedPersonArray;
@end
