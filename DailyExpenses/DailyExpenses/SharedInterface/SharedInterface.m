//
//  SharedInterface.m
//  DailyExpenses
//
//  Created by Pradeep on 16/06/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "SharedInterface.h"

@implementation SharedInterface
{
    sqlite3 *database;
    BOOL isOpenDatabase;
    BOOL isDatabaseCopiedinDocDir;
    
}
+(instancetype)sharedInstance {
    
    static SharedInterface *sharedInterface = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInterface = [[SharedInterface alloc] init];
    });
    return sharedInterface;
}

/*
 * This method is used to copy the database from App Bundle to documents directory.
 */

-(BOOL) copyDatabaseIfNeeded {
    
    if(!isDatabaseCopiedinDocDir){
        BOOL result = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSString *dbPath = [self getDBPath];
        BOOL success = [fileManager fileExistsAtPath:dbPath];
        
        if(!success) {
            
            result = YES;
            
            NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:@"DailyExpense" ofType:@"sqlite"];
            success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
            
            if (!success){
                result = NO;
                NSLog(@"Failed to create writable database file");
            }
        }
        
        isDatabaseCopiedinDocDir = result;
        return result;
        
    }else{
        NSLog(@"Database Already Copied");
        return NO;
    }
}

-(NSString *) getDBPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"DailyExpense.sqlite"]];
}

#pragma mark -
#pragma mark Open And Close database -

/*
 
 Method: openDatabase
 Description: This method open the database whenever we needed.
 Return Type: Return YES if successfully open otherwise return NO.
 
 */

-(BOOL)openDatabase{
    
    [self copyDatabaseIfNeeded];
    
    if(!isOpenDatabase){
        
        BOOL result = NO;
        NSString *sqLiteDb = [self getDBPath];
        
        if (sqlite3_open([sqLiteDb UTF8String], &database ) != SQLITE_OK)
        {
            NSLog(@"Failed to open database!");
            
            result =  NO;
        }else{
            
            NSLog(@"Database Open!");
            result = YES;
        }
        isOpenDatabase = result;
        
        return result;
    }else{
        
        NSLog(@"Database Already Opened");
        return YES;
    }
    
}

/*
 
 Method: closeDatabase
 Description: This method is used to close the database whenever we needed.
 
 */

-(void)closeDatabase{
    
    sqlite3_close(database);
}

-(BOOL)addExpense:(ExpenseModel *)model{
    
    [self openDatabase];
    
    BOOL result;
    char *errmsg=nil;
    
    //    CREATE TABLE "expense" ("date" TEXT, "title" TEXT, "amount" TEXT, "time" TEXT)
    NSString *strQuery = [NSString stringWithFormat:@"insert into expense(date,title,amount,time) values ('%@','%@','%@','%@')",model.expenseDate,model.expenseTitle,model.expenseAmount,model.expenseAddedTime];
    
    if(sqlite3_exec(database, [strQuery UTF8String], NULL, NULL, &errmsg)==SQLITE_OK)
    {
        result = YES;
        
    }else{
        result = NO;
    }
    
    return result;
}

-(BOOL)deleteExpense:(ExpenseModel *)model{
    
    [self openDatabase];
    
    BOOL result;
    
    NSString *strQuery = [NSString stringWithFormat:@"delete from expense where time = '%@'",model.expenseAddedTime];
    
    sqlite3_stmt *stmt=nil;
    
    if(sqlite3_prepare_v2(database, [strQuery UTF8String], -1, &stmt, NULL) == SQLITE_OK)
    {
        result = YES;
        
        if(SQLITE_DONE != sqlite3_step(stmt))
        {
            result = NO;
        }
    }
    return result;
}


-(NSArray *)fetchExpenseHistory{
    
    [self openDatabase];
    
    NSMutableArray *aryData = [[NSMutableArray alloc] init];
    
    NSString *query = @"select * from expense";
    
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            ExpenseModel *model = [[ExpenseModel alloc] init];
            [model setExpenseDate:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 0)]];
            [model setExpenseTitle:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)]];
            [model setExpenseAmount:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)]];
            [model setExpenseAddedTime:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)]];
            [aryData addObject:model];
            model = nil;
        }
    }
    
    return [aryData copy];
}

+(NSDateFormatter *) fetchDateformatter:(NSString *)strFormat {
    
    static NSDateFormatter *formatter = nil;
    if(!formatter)
        formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:strFormat];
    return formatter;
}

+(void) displayPrompt:(UIViewController *)controller message:(NSString *)message{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [controller presentViewController:alertController animated:YES completion:nil];
}

-(void) addBorderColorToLayer:(id) componentToAddBorderColor {
    [[componentToAddBorderColor layer] setCornerRadius:2.0f];
    [[componentToAddBorderColor layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[componentToAddBorderColor layer] setBorderWidth:0.5f];
    [componentToAddBorderColor setClipsToBounds:YES];
}

+(void) saveUserPassword:(NSString *)strPassword {
    [[NSUserDefaults standardUserDefaults] setValue:strPassword forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *) fetchUserPassword {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
}


+(BOOL)isStrEmpty:(NSString *) str {
    
    if([str isKindOfClass:[NSNull class]] || str==nil)
    {
        return YES;
    }
    
    
    if([str length] == 0) {
        
        return YES;
    }
    return NO;
}

@end
