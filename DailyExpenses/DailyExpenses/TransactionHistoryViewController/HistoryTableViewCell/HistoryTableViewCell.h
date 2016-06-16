//
//  HistoryTableViewCell.h
//  DailyExpenses
//
//  Created by Pradeep on 15/06/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
@property(weak,nonatomic) IBOutlet UIView *mainView;
@property(strong,nonatomic) IBOutlet UILabel *lblExpenseDate;
@property(strong,nonatomic) IBOutlet UILabel *lblExpenseTitle;
@property(strong,nonatomic) IBOutlet UILabel *lblExpenseAmount;

@end
