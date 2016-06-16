//
//  SharedInterface.h
//  DailyExpenses
//
//  Created by Pradeep on 16/06/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ExpenseModel.h"
#import <UIKit/UIKit.h>

@interface SharedInterface : NSObject

+(instancetype)sharedInstance;

-(BOOL)addExpense:(ExpenseModel *)model;
-(NSArray *)fetchExpenseHistory;

+(NSDateFormatter *) fetchDateformatter:(NSString *)strFormat;
+(void) displayPrompt:(UIViewController *)controller message:(NSString *)message;
-(BOOL)deleteExpense:(ExpenseModel *)model;
-(void) addBorderColorToLayer:(id) componentToAddBorderColor;

+(void) saveUserPassword:(NSString *)strPassword;
+(NSString *) fetchUserPassword;
+(BOOL)isStrEmpty:(NSString *) str;
@end
