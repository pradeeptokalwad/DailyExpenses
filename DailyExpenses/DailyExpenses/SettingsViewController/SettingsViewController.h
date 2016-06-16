//
//  SettingsViewController.h
//  DailyExpenses
//
//  Created by Pradeep on 15/06/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtMonthStartDate;
@property (weak, nonatomic) IBOutlet UITextField *txtDailyReminderTime;
@property (weak, nonatomic) IBOutlet UITextField *txtAvailableFund;
@property (weak, nonatomic) IBOutlet UITextField *txtOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
- (IBAction)btnUpdateSettingsPressed:(id)sender;

@end
