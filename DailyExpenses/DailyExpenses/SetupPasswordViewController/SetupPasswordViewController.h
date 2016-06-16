//
//  SetupPasswordViewController.h
//  DailyExpenses
//
//  Created by Pradeep on 05/06/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import <UIKit/UIKit.h>

//@interface SetupPasswordViewController : UIViewController

@interface SetupPasswordViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSetupPassword;

- (IBAction)btnSetupPasswordTapped:(id)sender;

@end
