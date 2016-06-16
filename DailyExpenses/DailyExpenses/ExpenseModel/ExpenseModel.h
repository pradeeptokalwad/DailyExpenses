//
//  ExpenseModel.h
//  DailyExpenses
//
//  Created by Pradeep on 16/06/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpenseModel : NSObject

@property(strong,nonatomic) NSString *expenseDate;
@property(strong,nonatomic) NSString *expenseTitle;
@property(strong,nonatomic) NSString *expenseAmount;
@property(strong,nonatomic) NSString *expenseAddedTime;

@end
