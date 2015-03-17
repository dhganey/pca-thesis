//
//  PCAChangePasswordViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 3/16/15.
//  Copyright (c) 2015 dhganey. All rights reserved.
//

#import "PCAChangePasswordViewController.h"

@interface PCAChangePasswordViewController ()

@end

@implementation PCAChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)changePressed:(id)sender
{
    [CatalyzeUser logInWithUsernameInBackground:self.usernameField.text password:self.currentPasswordField.text success:^(CatalyzeUser *result)
    {
        if ([self validateInput])
        {
            //[[CatalyzeUser currentUser] ]; actually change the password here
            [[CatalyzeUser currentUser] saveInBackgroundWithSuccess:^(id result)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
                //TODO consider another transition here
            } failure:^(NSDictionary *result, int status, NSError *error)
            {
                NSLog(@"failed to update password");
                //TODO show error here
            }];
        }
    } failure:^(NSDictionary *result, int status, NSError *error)
    {
        //TODO show alert
    }];
}

- (IBAction)cancelPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL) validateInput
{
    BOOL ok = true;
    
    ok = ok && self.usernameField.text.length > 0;
    ok = ok && self.currentPasswordField.text.length > 0;
    ok = ok && self.passwordField1.text.length > 0;
    ok = ok && self.passwordField2.text.length >0;
    
    ok = ok && ([self.passwordField1.text isEqualToString:self.passwordField2.text]);
    
    return ok;
}
@end
