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
    
    if(![SharedInterface isStrEmpty:[SharedInterface fetchUserPassword]]){
        
        self.txtConfirmPassword.hidden = YES;
        [self.btnSetupPassword setTitle:@"Login" forState:UIControlStateNormal];
        
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 * setup password first time and then store into NSUSerDefaults.
 */

- (IBAction)btnSetupPasswordTapped:(id)sender {

    if([SharedInterface isStrEmpty:[SharedInterface fetchUserPassword]]){
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
    }else {
        if([self.txtPassword.text isEqualToString:[SharedInterface fetchUserPassword]]){
            [[[UIApplication sharedApplication] delegate] window].rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        }else{
            [SharedInterface displayPrompt:self message:@"Password missmatch, Please enter Password"];
        }
    }
}

@end
