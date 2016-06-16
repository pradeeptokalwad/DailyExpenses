//
//  TransactionHistoryViewController.m
//  DailyExpenses
//
//  Created by Pradeep on 15/06/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "TransactionHistoryViewController.h"
#import "HistoryTableViewCell.h"

@interface TransactionHistoryViewController ()
{
    HistoryTableViewCell *swipedCell;
    BOOL hasSwipedLeft;
    NSIndexPath *swipeIndexPath;
    float Width;
    
    UIButton *btnDelete;
    
    NSMutableArray *aryExpenseHistory;
}
@end

@implementation TransactionHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   Width  = 100;
    self.title = @"Transaction History";

    self.view.backgroundColor = [UIColor colorWithRed:225.0f/255.0f green:226.0f/255.0f blue:228.0f/255.0f alpha:1.0];
    self.tableView.layer.cornerRadius = 2.50f;
    self.tableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.tableView.layer.borderWidth = 1.0f;
    self.tableView.clipsToBounds = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HistoryTableViewCell"];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelete.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 5, 90, 70);
    btnDelete.backgroundColor = [UIColor redColor];
    [btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
    btnDelete.layer.borderColor = [[UIColor blackColor] CGColor];
    [btnDelete addTarget:self action:@selector(btnDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
    btnDelete.layer.borderWidth = 1.0f;
    btnDelete.clipsToBounds = YES;
    [self.tableView addSubview:btnDelete];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    aryExpenseHistory = [[NSMutableArray alloc] initWithArray:[[SharedInterface sharedInstance] fetchExpenseHistory]];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark * UITableView delegate Methods * -

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return aryExpenseHistory.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    [self configureCellWithExpenseData:[aryExpenseHistory objectAtIndex:indexPath.row] cell:cell];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightMethod:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [cell addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftMethod:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [cell addGestureRecognizer:swipeLeft];
    
    if(([cell isEqual:swipedCell] && hasSwipedLeft)){
        [self resetSwipedCell];
    }
    
    return cell;
}

/*
 * display data into cell.
 */

-(void) configureCellWithExpenseData:(ExpenseModel *)model cell:(HistoryTableViewCell *)cell {

//    NSDate *date1 = [[SharedInterface fetchDateformatter:@"dd-MM-yyyy"] dateFromString:model.expenseDate];
    
//    NSDateFormatter *formatter = nil;
//    if(!formatter)
//        formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"dd MMM YYYY"];
    
    cell.lblExpenseAmount.text = [NSString stringWithFormat:@"INR %.2f",[model.expenseAmount floatValue]];
    cell.lblExpenseDate.text = [[SharedInterface fetchDateformatter:@"dd MMM YYYY"] stringFromDate:[[SharedInterface fetchDateformatter:@"dd-MM-yyyy"] dateFromString:model.expenseDate]];
    cell.lblExpenseTitle.text = model.expenseTitle;
}

/*
 * swipe gesture to delete the expense from datbase.
 */

- (void)swipeLeftMethod:(UISwipeGestureRecognizer *)gesture {
    
    
    if(swipedCell.frame.origin.x!=0){
        [self resetSwipedCell];
        return;
    }
    
    
    CGRect frmBtnDelete = btnDelete.frame;
    
    swipedCell = (HistoryTableViewCell *)gesture.view;
    frmBtnDelete.origin.y = swipedCell.frame.origin.y+5;
    frmBtnDelete.size.height = swipedCell.mainView.frame.size.height;
    frmBtnDelete.size.width = Width;
    
    btnDelete.frame = frmBtnDelete;
    swipeIndexPath=[self.tableView indexPathForCell:swipedCell];
    
    if(!hasSwipedLeft)
    {
        frmBtnDelete.origin.x = [UIScreen mainScreen].bounds.size.width - (Width)- 12;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            gesture.view.center=CGPointMake(gesture.view.center.x- (Width), gesture.view.center.y);
            btnDelete.frame = frmBtnDelete;
            
        }completion:^(BOOL finished) {
            if(finished) {
                hasSwipedLeft = !hasSwipedLeft;
            }
        }];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            gesture.view.center=CGPointMake(gesture.view.center.x- Width, gesture.view.center.y);
            btnDelete.frame = frmBtnDelete;
            
        }completion:^(BOOL finished) {
            if(finished) {
                hasSwipedLeft = !hasSwipedLeft;
            }
        }];
    }
    
}

/*
 * swipe gesture to delete the expense from datbase.
 */

- (void)swipeRightMethod:(UISwipeGestureRecognizer *)gesture {
    
    
    
    if(swipedCell.frame.origin.x!=0 ){
        
        [self resetSwipedCell];
        return;
    }
    
    swipedCell = (HistoryTableViewCell *)gesture.view;

    swipeIndexPath=[self.tableView indexPathForCell:swipedCell];
    
    CGRect frmBtnDelete = btnDelete.frame;
    frmBtnDelete.size.height = swipedCell.mainView.frame.size.height;
    frmBtnDelete.size.width = Width;
    frmBtnDelete.origin.y = swipedCell.mainView.frame.origin.y;
    btnDelete.frame = frmBtnDelete;
    
    
    
    if(hasSwipedLeft && swipeIndexPath)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            [gesture view].center = CGPointMake([gesture view].center.x + Width, [gesture view].center.y);
            
        }completion:^(BOOL finished) {
            if(finished) {
                hasSwipedLeft = !hasSwipedLeft;
            }
        }];
        
    }
}

/*
 * Reset cell to original position.
 */

- (void)resetSwipedCell {
    
    swipeIndexPath=nil;
    CGRect btnDeleteFrame = btnDelete.frame;
    btnDeleteFrame.origin.y = swipedCell.frame.origin.y+5;
    
    btnDelete.frame = btnDeleteFrame;
    
    if(btnDeleteFrame.origin.x<self.view.center.x)
        btnDeleteFrame.origin.x = -Width;
    else
        btnDeleteFrame.origin.x = [UIScreen mainScreen].bounds.size.width;
    
    [UIView animateWithDuration:0.3 animations:^{
        swipedCell.center = CGPointMake(self.tableView.center.x, swipedCell.center.y);
        btnDelete.frame = btnDeleteFrame;
    }completion:^(BOOL finished) {
        if(finished) {
            hasSwipedLeft = NO;
        }
    }];
}

/*
 * Delete expense from datbase.
 */

-(void) btnDeletePressed:(id) sender {

    
    if([[SharedInterface sharedInstance] deleteExpense:[aryExpenseHistory objectAtIndex:swipeIndexPath.row]]) {
        [SharedInterface displayPrompt:self message:@"Expense Deleted"];
    }else {
        [SharedInterface displayPrompt:self message:@"Unable to delete Expense"];
    }
    
    [aryExpenseHistory removeAllObjects];
    aryExpenseHistory = nil;
    
    aryExpenseHistory = [[NSMutableArray alloc] initWithArray:[[SharedInterface sharedInstance] fetchExpenseHistory]];
    [self resetSwipedCell];

    [self.tableView reloadData];
}

@end