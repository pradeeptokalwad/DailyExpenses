//
//  TransactionHistoryViewController.h
//  DailyExpenses
//
//  Created by Pradeep on 15/06/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
