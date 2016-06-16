//
//  SettingsViewController.m
//  DailyExpenses
//
//  Created by Pradeep on 15/06/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *pickerStartDayOfMonth;
    NSMutableArray *aryStartDayOfMonth;
    UIDatePicker *datePickerForDailyReminder;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    aryStartDayOfMonth = [[NSMutableArray alloc] init];
    
    for (int i=1; i<=31; i++) {
        [aryStartDayOfMonth addObject:[NSString stringWithFormat:@"%d",i]];
    }
    pickerStartDayOfMonth = [[UIPickerView alloc]init];
    pickerStartDayOfMonth.dataSource = self;
    pickerStartDayOfMonth.delegate = self;
    pickerStartDayOfMonth.showsSelectionIndicator = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(btnDonePressed)];
    UIToolbar *tlbDoneBar = [[UIToolbar alloc]init];
    [tlbDoneBar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    NSArray *toolbarItems = [NSArray arrayWithObjects:flexibleItem,btnDone, nil];
    [tlbDoneBar setItems:toolbarItems];
    self.txtMonthStartDate.inputView = pickerStartDayOfMonth;
    self.txtMonthStartDate.inputAccessoryView = tlbDoneBar;
    
    datePickerForDailyReminder =[[UIDatePicker alloc]init];
    datePickerForDailyReminder.datePickerMode=UIDatePickerModeTime;
    datePickerForDailyReminder.minuteInterval = 30;
    datePickerForDailyReminder.date=[NSDate date];
    [datePickerForDailyReminder addTarget:self action:@selector(dailyReminder) forControlEvents:UIControlEventValueChanged];
    self.txtDailyReminderTime.inputView = datePickerForDailyReminder;
    self.txtDailyReminderTime.inputAccessoryView = tlbDoneBar;

    [[SharedInterface sharedInstance] addBorderColorToLayer:self.txtAvailableFund];
    [[SharedInterface sharedInstance] addBorderColorToLayer:self.txtDailyReminderTime];
    [[SharedInterface sharedInstance] addBorderColorToLayer:self.txtMonthStartDate];
    [[SharedInterface sharedInstance] addBorderColorToLayer:self.txtNewPassword];
    [[SharedInterface sharedInstance] addBorderColorToLayer:self.txtOldPassword];
    [[SharedInterface sharedInstance] addBorderColorToLayer:self.btnUpdate];
    self.title = @"Settings";

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {

    
    self.txtAvailableFund.text = @"0.00";
    
    if(![SharedInterface isStrEmpty:[[NSUserDefaults standardUserDefaults] valueForKey:@"monthstartdate"]])
        self.txtMonthStartDate.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"monthstartdate"];
    if(![SharedInterface isStrEmpty:[[NSUserDefaults standardUserDefaults] valueForKey:@"dailyreminderdate"]])
        self.txtDailyReminderTime.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"dailyreminderdate"];
    if(![SharedInterface isStrEmpty:[[NSUserDefaults standardUserDefaults] valueForKey:@"availablefund"]])
        self.txtAvailableFund.text = [NSString stringWithFormat:@"%.2f",[[[NSUserDefaults standardUserDefaults] valueForKey:@"availablefund"] floatValue]];

}

-(void) btnDonePressed {

    [self.view endEditing:YES];
}

-(void) dailyReminder {
    self.txtDailyReminderTime.text = [[ SharedInterface fetchDateformatter:@"hh a"] stringFromDate:datePickerForDailyReminder.date];
}

- (IBAction)btnUpdateSettingsPressed:(id)sender {
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self dailyNotification];
    [self monthlyNotification];
    
    if(!([SharedInterface isStrEmpty:self.txtOldPassword.text]) && [SharedInterface isStrEmpty:self.txtNewPassword.text]){
        [SharedInterface displayPrompt:self message:@"Please enter new Password"];
    }else if((![SharedInterface isStrEmpty:self.txtOldPassword.text]) && ![SharedInterface isStrEmpty:self.txtNewPassword.text]) {
    
        if([self.txtOldPassword.text isEqualToString:[SharedInterface fetchUserPassword]]){
            [SharedInterface saveUserPassword:self.txtNewPassword.text];
            [SharedInterface displayPrompt:self message:@"Password Updated Successfully"];

        }else{
            [SharedInterface displayPrompt:self message:@"Old Passowrd doesn't match"];
        }
    }else {
    
        [SharedInterface displayPrompt:self message:@"Settings Updated Successfully"];

    }
    
    if(![SharedInterface isStrEmpty:self.txtMonthStartDate.text])
        [[NSUserDefaults standardUserDefaults] setValue:self.txtMonthStartDate.text forKey:@"monthstartdate"];
    if(![SharedInterface isStrEmpty:self.txtDailyReminderTime.text])
        [[NSUserDefaults standardUserDefaults] setValue:self.txtDailyReminderTime.text forKey:@"dailyreminderdate"];
    if(![SharedInterface isStrEmpty:self.txtAvailableFund.text])
        [[NSUserDefaults standardUserDefaults] setValue:self.txtAvailableFund.text forKey:@"availablefund"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) dailyNotification{
    
    NSDate *dateDailyReminder = [[SharedInterface fetchDateformatter:@"hh a"] dateFromString:self.txtDailyReminderTime.text];

    NSDate *currentDate = [NSDate date];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents* components = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSDateComponents* componentsForDailyTime = [calendar components:NSCalendarUnitHour fromDate:dateDailyReminder];
    [components setTimeZone:[NSTimeZone systemTimeZone]];
    [components setHour:componentsForDailyTime.hour];
    [components setMinute:0];
    [components setSecond:0];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [calendar dateFromComponents:components];
    localNotification.alertBody = @"Daily";
    localNotification.alertAction = @"Daily";
    localNotification.timeZone = [NSTimeZone systemTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    localNotification.repeatInterval= NSCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void) monthlyNotification{
    
    NSDate *dateDailyReminder = [[SharedInterface fetchDateformatter:@"hh a"] dateFromString:self.txtDailyReminderTime.text];

    NSDate *currentDate = [NSDate date];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents* components = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:currentDate];
    NSDateComponents* componentsForDailyTime = [calendar components:NSCalendarUnitHour fromDate:dateDailyReminder];

    [components setTimeZone:[NSTimeZone systemTimeZone]];
    [components setHour:componentsForDailyTime.hour];
    [components setMinute:0];
    [components setSecond:0];
    [components setDay:[self.txtMonthStartDate.text integerValue]];

    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [calendar dateFromComponents:components];
    localNotification.alertBody = @"Monthly";
    localNotification.alertAction = @"Monthly";
    localNotification.timeZone = [NSTimeZone systemTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    localNotification.repeatInterval= NSCalendarUnitMonth;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark - Picker Delegate -

#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return [aryStartDayOfMonth count];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    [self.txtMonthStartDate setText:[aryStartDayOfMonth objectAtIndex:row]];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [aryStartDayOfMonth objectAtIndex:row];
}

@end
