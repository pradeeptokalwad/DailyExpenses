//
//  SetupPasswordViewController.m
//  DailyExpenses
//
//  Created by Pradeep on 05/06/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "SetupPasswordViewController.h"
#import "ViewController.h"
@interface SetupPasswordViewController ()

@end

@implementation SetupPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SharedInterface sharedInstance] addBorderColorToLayer:self.txtPassword];
    [[SharedInterface sharedInstance] addBorderColorToLayer:self.txtConfirmPassword];
    [[SharedInterface sharedInstance] addBorderColorToLayer:self.btnSetupPassword];
    // Do any additional setup after loading the view.
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

- (IBAction)btnSetupPasswordTapped:(id)sender {

    if([SharedInterface isStrEmpty:self.txtPassword.text] && [SharedInterface isStrEmpty:self.txtConfirmPassword.text]) {
        [SharedInterface displayPrompt:self message:@"please enter password and confirm password"];
    }else if([SharedInterface isStrEmpty:self.txtPassword.text]) {
        [SharedInterface displayPrompt:self message:@"please enter password"];
    }else if([SharedInterface isStrEmpty:self.txtConfirmPassword.text]){
        [SharedInterface displayPrompt:self message:@"please enter confirm password"];
    }else if([self.txtConfirmPassword.text isEqual:self.txtPassword.text]) {
        [SharedInterface saveUserPassword:self.txtPassword.text];
        [[[UIApplication sharedApplication] delegate] window].rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];

    }else {
        [SharedInterface displayPrompt:self message:@"password missmatch, please re-enter"];
    }
}

@end
