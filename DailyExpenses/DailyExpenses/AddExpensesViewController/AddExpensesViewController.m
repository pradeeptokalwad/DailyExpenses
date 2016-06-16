//
//  AddExpensesViewController.m
//  DailyExpenses
//
//  Created by Pradeep on 15/06/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "AddExpensesViewController.h"
#import "ExpenseModel.h"
#import "SharedInterface.h"
@interface AddExpensesViewController ()

@end

@implementation AddExpensesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[SharedInterface sharedInstance] addBorderColorToLayer:self.txtExpenseAmount];
    [[SharedInterface sharedInstance] addBorderColorToLayer:self.txtExpenseTitle];
    [[SharedInterface sharedInstance] addBorderColorToLayer:self.btnSubmit];
    self.title = @"Add Expense";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    self.lblAvailableFunds.text = [NSString stringWithFormat:@"Available Funds: INR 0"];

    if(![SharedInterface isStrEmpty:[[NSUserDefaults standardUserDefaults] valueForKey:@"availablefund"]])
    self.lblAvailableFunds.text = [NSString stringWithFormat:@"Available Funds: INR %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"availablefund"]];

}

/*
 * Add expense to the datbase.
 */

- (IBAction)btnSubmitPressed:(id)sender {

    if([SharedInterface isStrEmpty:self.txtExpenseAmount.text] && [SharedInterface isStrEmpty:self.txtExpenseTitle.text]){
        [SharedInterface displayPrompt:self message:@"Please enter expense title and amount"];
    }else if([SharedInterface isStrEmpty:self.txtExpenseTitle.text]){
        [SharedInterface displayPrompt:self message:@"Please enter expense title"];
    }else if([SharedInterface isStrEmpty:self.txtExpenseAmount.text] ){
        [SharedInterface displayPrompt:self message:@"Please enter expense amount"];
    }else{
        
        if([SharedInterface isStrEmpty:[[NSUserDefaults standardUserDefaults] valueForKey:@"availablefund"]]){
            [SharedInterface displayPrompt:self message:@"You don't have sufficient Fund !"];
        }else if([self.txtExpenseAmount.text integerValue]>[[[NSUserDefaults standardUserDefaults] valueForKey:@"availablefund"] integerValue]) {
            [SharedInterface displayPrompt:self message:@"Your Expense is more than Available Fund !"];
        }else{
            
            ExpenseModel *model = [[ExpenseModel alloc] init];
            [model setExpenseAddedTime:[[SharedInterface fetchDateformatter:@"dd-MM-YYYY hh:mm:ss"] stringFromDate:[NSDate date]]];
            [model setExpenseDate:[[SharedInterface fetchDateformatter:@"dd-MM-YYYY"] stringFromDate:self.datePicker.date]];
            [model setExpenseAmount:self.txtExpenseAmount.text];
            [model setExpenseTitle:self.txtExpenseTitle.text];
            
            if([[SharedInterface sharedInstance] addExpense:model]){
                [SharedInterface displayPrompt:self message:@"Expense Added"];
                
                [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%ld",[[[NSUserDefaults standardUserDefaults] valueForKey:@"availablefund"] integerValue] - [self.txtExpenseAmount.text integerValue]] forKey:@"availablefund"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                self.lblAvailableFunds.text = [NSString stringWithFormat:@"Available Funds: INR %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"availablefund"]];
            }
            model = nil;
        }
    }
    
}
@end
