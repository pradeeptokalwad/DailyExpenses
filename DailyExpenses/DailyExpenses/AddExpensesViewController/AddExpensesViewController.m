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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnSubmitPressed:(id)sender {
    
    if([SharedInterface isStrEmpty:self.txtExpenseAmount.text] && [SharedInterface isStrEmpty:self.txtExpenseTitle.text]){
        [SharedInterface displayPrompt:self message:@"Please enter expense title and amount"];
    }else if([SharedInterface isStrEmpty:self.txtExpenseTitle.text]){
        [SharedInterface displayPrompt:self message:@"Please enter expense title"];
    }else if([SharedInterface isStrEmpty:self.txtExpenseAmount.text] ){
        [SharedInterface displayPrompt:self message:@"Please enter expense amount"];
    }else{
        ExpenseModel *model = [[ExpenseModel alloc] init];
        [model setExpenseAddedTime:[[SharedInterface fetchDateformatter:@"dd-MM-YYYY hh:mm:ss"] stringFromDate:[NSDate date]]];
        [model setExpenseDate:[[SharedInterface fetchDateformatter:@"dd-MM-YYYY"] stringFromDate:self.datePicker.date]];
        [model setExpenseAmount:self.txtExpenseAmount.text];
        [model setExpenseTitle:self.txtExpenseTitle.text];
        
        if([[SharedInterface sharedInstance] addExpense:model]){
            [SharedInterface displayPrompt:self message:@"Expense Added"];
        }
        model = nil;
    }
    
}
@end
