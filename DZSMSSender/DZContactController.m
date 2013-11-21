//
//  DZContactController.m
//  DZSMSSender
//
//  Created by linx on 13-8-20.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import "DZContactController.h"
#import "DZPerson.h"
#import "DZPhone.h"
#import "ChineseToPinyin.h"
#import "pinyin.h"
#import "DZContactCell.h"
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>
@interface DZContactController ()

@end

@implementation DZContactController{
    int MessageCount;
    NSMutableArray *persons;
    NSMutableArray *personRecordArray;
    NSMutableArray *selectedRow;
    NSString *SMSTemplet;
    NSMutableDictionary *sortedPerson;
    NSMutableArray *sortedKeys;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil SMSTemplet:(NSString *) SMSTempletIn{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    SMSTemplet = SMSTempletIn;
    sortedPerson = [[NSMutableDictionary alloc] init];
    sortedKeys = [[NSMutableArray alloc] initWithCapacity:10];
    return self;
}
- (void)sortPersonsByPinyinName:(NSMutableArray*) personArray
{
    //根据person的姓名拼音进行排序
    personArray = (NSMutableArray *)[persons sortedArrayUsingComparator:^NSComparisonResult(DZPerson *person1, DZPerson *person2) {
        return [person1.namePinyin compare:person2.namePinyin];
    }];
    //让排序后的每个person记录自己的索引号
    for(int i = 0 ;i<personArray.count ; i++){
        DZPerson *person = [persons objectAtIndex:i];
        person.personIndex = [NSNumber numberWithInt:i];

        //便利person数组，取得每个联系人的姓名首字母，并放置如索引数组
        if([sortedPerson objectForKey:person.fistrLetterOfFullName]==NULL){
            NSMutableArray *items = [[NSMutableArray alloc] init];
            [items addObject:person];
            [sortedPerson setObject:items forKey:person.fistrLetterOfFullName];
            [sortedKeys addObject:person.fistrLetterOfFullName];
        }else{
            [[sortedPerson objectForKey:person.fistrLetterOfFullName] addObject:person];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //获取对通讯录的引用
    ABAddressBookRef addressBook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    }
    else
    {
        addressBook = ABAddressBookCreate();
    }
    //创建保存联系人的数组
    persons = [[NSMutableArray alloc]initWithCapacity:50];
    personRecordArray = (__bridge NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    //将联系人记录，转换为person对象数组
    for(int i = 0 ;i<personRecordArray.count;i++){
        ABRecordRef thisPerson = CFBridgingRetain([personRecordArray objectAtIndex:i]);
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonFirstNameProperty));
        if(firstName ==NULL){
            firstName = @"";
        }
        NSString *lastName = CFBridgingRelease(ABRecordCopyValue(thisPerson, kABPersonLastNameProperty));
        if(lastName ==NULL){
            lastName = @"";
        }
        CFRelease(thisPerson);
        DZPerson *person = [[DZPerson alloc] init];
        person.fullName = [NSString stringWithFormat:@"%@%@",lastName,firstName];
        person.namePinyin = [ChineseToPinyin pinyinFromChiniseString:person.fullName];
        person.nickName = CFBridgingRelease(ABRecordCopyValue(thisPerson,kABPersonNicknameProperty));
        if(person.nickName == NULL){
            person.nickName = person.fullName;
        }
        ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(thisPerson, kABPersonPhoneProperty);
        int nCount = ABMultiValueGetCount(phones);
        
        for(int j = 0 ;j < nCount;j++){
            DZPhone *phone = [[DZPhone alloc]init];
            CFStringRef lable = ABMultiValueCopyLabelAtIndex(phones, j);
            CFStringRef localLeble = ABAddressBookCopyLocalizedLabel(lable);
            CFBridgingRelease(lable);
            NSString *final = (NSString *)CFBridgingRelease(localLeble);
            phone.PhoneLable = final;
            NSString *phoneNO    = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, j));  // 这个就是电话号码
            phone.PhoneNumber = phoneNO;
            [person.phones addObject:phone];
        }
        CFRelease(phones);
        
        [persons addObject:person];
    }//person对象转换完毕
    [self sortPersonsByPinyinName:persons];
    
    //对索引数组进行排序
    sortedKeys = (NSMutableArray *)[sortedKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *string1, NSString *string2) {
        return [ string1 compare:string2];
    }];
    
    [self.tableView setEditing:YES animated:YES];
    selectedRow = [[NSMutableArray alloc] initWithCapacity:50];
    
    UIBarButtonItem *but_send = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendSMS:)];
    self.navigationItem.rightBarButtonItem = but_send;
    CFRelease(addressBook);
}


-(void)sendSMS:(id *)sender{
    MessageCount = selectedRow.count;
    [self sendAllSms];
}

-(void)sendAllSms{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
    
	if([MFMessageComposeViewController canSendText])
	{
        
        if(MessageCount>0){
            MessageCount--;
            NSIndexPath *indexPath = (NSIndexPath *)[selectedRow objectAtIndex:MessageCount];
            
            DZContactCell *cell = (DZContactCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
            DZPerson *person = [persons objectAtIndex:[cell.personIndex intValue] ];
            DZPhone *phone = [person.phones objectAtIndex:[cell.phoneIndex intValue]];
            controller.body = [SMSTemplet stringByReplacingOccurrencesOfString:@"@昵称@" withString:person.nickName];
            controller.recipients = [NSArray arrayWithObjects:phone.PhoneNumber, nil];
            controller.messageComposeDelegate = self;
            [self presentViewController:controller animated:YES completion:nil];
            
        }
	}
}

-(NSString *)nameInAddressArray:(int)index{
    return [[persons objectAtIndex:index] fullName];
}

-(NSString *)nickNameAtAddressArray:(int)index{
    return [[persons objectAtIndex:index] nickName];
}
-(NSString *)phoneLabelAndStringAtIndexPath:(NSIndexPath *)indexPath{
    NSString *phoneString=@"";
    NSArray *phones = [[persons objectAtIndex:indexPath.section] phones];
    if(phones.count>0){
       phoneString = [[phones objectAtIndex:indexPath.row] phoneString];
    }
    return phoneString;
}

-(NSString *)phoneNumberAtIndexPath:(NSIndexPath *)indexPath{
    NSString *phoneString=@"";
    NSArray *phones = [[persons objectAtIndex:indexPath.section] phones];
    if(phones.count>0){
        phoneString = [[phones objectAtIndex:indexPath.row] PhoneNumber];
    }
    return phoneString;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;   
		case MessageComposeResultFailed:
            NSLog(@"Failed");
			break;
		case MessageComposeResultSent:       
            NSLog(@"Sent");  
			break;
		default:
			break;
	}
    void(^test)();
    test= ^(){
        [self sendAllSms];
    };
    [self dismissViewControllerAnimated:YES completion:test];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
    [controller setDelegate:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return sortedKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int rowCount = 0;
    for (DZPerson *person in [sortedPerson objectForKey:[sortedKeys objectAtIndex:section]]) {
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
    NSArray *tempPersons = [sortedPerson objectForKey:[sortedKeys objectAtIndex:indexPath.section]];
    int preSum = 0;
    for(int i = 0 ;i<tempPersons.count;i++){
        DZPerson *tempPerson = [tempPersons objectAtIndex: i];
        int tempCount = tempPerson.phones.count;

        if(indexPath.row == preSum) {
            cell.textLabel.text = tempPerson.fullName;
            cell.personIndex = tempPerson.personIndex;
            if(tempCount >= 1){
                cell.detailTextLabel.text = [[tempPerson.phones objectAtIndex:0] phoneString];
                cell.personIndex = tempPerson.personIndex;
                cell.phoneIndex = [NSNumber numberWithInt:0];
            }
            break;
        }else{
            if(indexPath.row > preSum+tempCount){
                preSum += tempCount==0?1:tempCount;
                continue;
            }
            if(indexPath.row < preSum + tempCount){
                int tempindex = indexPath.row - preSum;
                tempindex = tempindex == 1 ?1:tempindex-1;
                cell.detailTextLabel.text = [[tempPerson.phones objectAtIndex:tempindex] phoneString];
                cell.personIndex = tempPerson.personIndex;
                cell.phoneIndex = [NSNumber numberWithInt:tempindex];
                break;
            }
        }
        preSum += tempCount==0?1:tempCount;
    }
    //下面的代码没用，好奇怪。
//    CGRect rect = cell.textLabel.frame;
//    rect.origin.x +=20;
//    cell.textLabel.frame = rect;
    NSLog(@"name:%@,personIdex:%d",cell.textLabel.text,[cell.personIndex intValue]);
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}




#pragma mark - Table view delegate
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    DZContactCell *cell = (DZContactCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    DZPerson *person = (DZPerson *)[persons objectAtIndex:[cell.personIndex intValue]];
    NSLog(@"section:%d row:%d name:%@ count:%d",indexPath.section,indexPath.row,person.fullName,person.phones.count);
    //通过判断phones.count的方式不能排除没有电话的联系人,很奇怪明明没有电话，count却是1
    //感觉像通讯录没有读全，很奇怪,fullname通过nslog显示出来也不对，从这里入手看看
    return person.phones.count > 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    [selectedRow addObject:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [selectedRow removeObject:indexPath];
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sortedKeys objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return sortedKeys;
    
}

@end
