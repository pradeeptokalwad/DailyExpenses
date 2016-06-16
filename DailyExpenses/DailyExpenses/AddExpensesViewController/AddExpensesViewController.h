//
//  AddExpensesViewController.h
//  DailyExpenses
//
//  Created by Pradeep on 15/06/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddExpensesViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *txtExpenseTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtExpenseAmount;
- (IBAction)btnSubmitPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblAvailableFunds;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end
