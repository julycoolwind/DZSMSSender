//
//  DZViewController.m
//  DZSMSSender
//
//  Created by linx on 13-8-20.
//  Copyright (c) 2013年 linx. All rights reserved.
//

#import "DZViewController.h"
#import "DZAppDelegate.h"
#import "DZContactController.h"
#import "DZContactTableDataSource.h"

@interface DZViewController ()

@end

@implementation DZViewController{
    NSString *SMSContent;
    int SMSViewTop ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target: self action:@selector(click:)];
    self.navigationItem.rightBarButtonItem = leftButton;
    SMSContent = @"";
    SMSViewTop = self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y;
   }
-(void)click:(id *)sender{
    DZContactController *contactView = [[DZContactController alloc] initWithNibName:@"DZContactController" bundle:nil SMSTemplet:self.SMSText.text];
    contactView.dataSource = [[DZContactTableDataSource alloc] init];
    DZAppDelegate *delegate = (DZAppDelegate *)[[UIApplication sharedApplication] delegate];
    SMSContent = self.SMSText.text;
    [delegate.navController pushViewController:contactView animated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    self.but_clear = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.but_clear addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.but_clear.frame = CGRectMake(0, self.view.frame.size.height-40, 100,40);
    
    self.SMSText = [[UITextView alloc] initWithFrame:CGRectMake(0, SMSViewTop, self.view.frame.size.width,self.view.frame.size.height)];
    self.SMSText.textColor = [UIColor blackColor];
    self.SMSText.font = [UIFont fontWithName:@"Arial" size:18];
    self.SMSText.backgroundColor = [UIColor whiteColor];
    self.SMSText.text = [SMSContent isEqualToString:@""]?@"@昵称@将被替换为通讯录中的昵称，如:老兄。如果通讯录中没有设置昵称，则使用姓名进行替换。\n\n例如：@昵称@你好，将发送为：老兄你好。":SMSContent;
    self.SMSText.returnKeyType = UIReturnKeyDefault;
    self.SMSText.keyboardType = UIKeyboardTypeDefault;
    self.SMSText.scrollEnabled = YES;
    self.SMSText.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview: self.SMSText];
    //[self.view addSubview: self.but_clear];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleBlack];
    
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"插入昵称" style:UIBarButtonItemStyleBordered target:self action:@selector(InsertNickName)];
    UIBarButtonItem * btnClear = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStyleBordered target:self action:@selector(clear)];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"隐藏键盘" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,btnClear,doneButton,nil];
    
    [topView setItems:buttonsArray];
    [self.SMSText setInputAccessoryView:topView];
}

-(void)clear{
    self.SMSText.text = @"";
}
-(void)InsertNickName{
    [self.SMSText insertText:@"@昵称@"];
}

-(void)dismissKeyBoard
{
    [self.SMSText resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSMSText:nil];
    [super viewDidUnload];
}


#pragma mark -处理键盘相关的事件
-(void)handleKeyboardWillShow:(NSNotification *)paramNotification{
    NSDictionary *userInfo = [paramNotification userInfo];
    NSValue *animationCurveObject =
    [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSValue *animationDurationObject =
    [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSValue *keyboardEndRectObject =
    [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    NSUInteger animationCurve = 0;
    double animationDuration = 0.0f;
    CGRect keyboardEndRect = CGRectMake(0, 0, 0, 0);
    [animationCurveObject getValue:&animationCurve];
    [animationDurationObject getValue:&animationDuration];
    [keyboardEndRectObject getValue:&keyboardEndRect];
    [UIView beginAnimations:@"changeTableViewContentInset"
                    context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect intersectionOfKeyboardRectAndWindowRect =
    CGRectIntersection(window.frame, keyboardEndRect);
    CGFloat bottomInset = intersectionOfKeyboardRectAndWindowRect.size.height;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width,200);
    self.but_clear.frame = CGRectMake(0, 160, 100,40);
//    DZAppDelegate *delegate = (DZAppDelegate *)[[UIApplication sharedApplication] delegate];
//    delegate.viewController.view.autoresizesSubviews = YES;
//    delegate.viewController.view.frame =CGRectMake(0, 0, self.view.bounds.size.width,200);
    self.SMSText.frame = CGRectMake(0,SMSViewTop, self.view.frame.size.width,self.view.frame.size.height-bottomInset-SMSViewTop);
//    self.SMSText.bounds = CGRectMake(0, 0, 150, 100);
//    self.SMSText.contentSize = CGSizeMake(150, 200);
    [UIView commitAnimations];
    //UIEdgeInsetsMake(0.0f,0.0f,bottomInset,0.0f);
    
}

- (void) handleKeyboardWillHide:(NSNotification *)paramNotification{
//    if (UIEdgeInsetsEqualToEdgeInsets(self.tableView.contentInset,
//                                      UIEdgeInsetsZero)){
//        /* Our table view's content inset is intact so no need to reset it */
//        return;
//    }
    NSDictionary *userInfo = [paramNotification userInfo];
    NSValue *animationCurveObject =
    [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSValue *animationDurationObject =
    [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSValue *keyboardEndRectObject =
    [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    NSUInteger animationCurve = 0;
    double animationDuration = 0.0f;
    CGRect keyboardEndRect = CGRectMake(0, 0, 0, 0);
    [animationCurveObject getValue:&animationCurve];
    [animationDurationObject getValue:&animationDuration];
    [keyboardEndRectObject getValue:&keyboardEndRect];
    [UIView beginAnimations:@"changeTableViewContentInset"
                    context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    self.but_clear.frame = CGRectMake(0, self.view.frame.size.height-40, 100,40);
    self.SMSText.frame = CGRectMake(0, SMSViewTop, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void) handleTaps:(UITapGestureRecognizer*)paramSender{
    [self.SMSText resignFirstResponder];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"in touchesBegan");
    [self.SMSText resignFirstResponder];
}

-(IBAction)backgroundTap:(id)sender/////实现输出完成时点击相应的文本字段部分软键盘退出
{
    //[sender resignFirstResponder];//结束当前第一响应状态：此方法的调用可以满足下边两条语句的功能，但这样没有下边两条的更安全
    [self.SMSText resignFirstResponder];//结束name的第一响应状态
    //[numberField resignFirstResponder];//结束number的第一响应状态
}
@end
