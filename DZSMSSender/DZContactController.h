//
//  DZContactController.h
//  DZSMSSender
//
//  Created by linx on 13-8-20.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface DZContactController : UITableViewController<MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil SMSTemplet:(NSString *) SMSTempletIn;
@property(strong) id <UITableViewDataSource> dataSource;
@property(strong) id <UITableViewDelegate> tableViewDelegate;
@end
