//
//  PCAAdditionalInfoViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 7/9/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCAAdditionalInfoViewController.h"

#import <Parse/Parse.h>

@interface PCAAdditionalInfoViewController ()

@end

@implementation PCAAdditionalInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitPressed:(id)sender
{
    if ([self.doctorNameField.text length] > 0) //entered something in doctor field
    {
        //create NSNumbers (1 or 0) to represent state of symptoms
        NSNumber *onNum = [[NSNumber alloc] initWithInt:1];
        NSNumber *offNum = [[NSNumber alloc] initWithInt:0];
        
        //use switch state to decide which NSNumber to use
        NSNumber *painOn = ([self.painSwitch isOn] ? onNum : offNum);
        NSNumber *nauseaOn = ([self.nauseaSwitch isOn] ? onNum : offNum);
        NSNumber *tirednessOn = ([self.tirednessSwitch isOn] ? onNum : offNum);
        NSNumber *appetiteOn = ([self.appetiteSwitch isOn] ? onNum : offNum);
        NSNumber *breathOn = ([self.breathSwitch isOn] ? onNum : offNum);
        
        //create an array of the numbers
        NSArray *symptomBitmaskArray = [[NSArray alloc] initWithObjects:painOn, nauseaOn, tirednessOn, appetiteOn, breathOn, nil];
        
        //update the user
        [PFUser currentUser][@"symptomBitmask"] = symptomBitmaskArray;
        [PFUser currentUser][@"doctorName"] = [self.doctorNameField.text capitalizedString];
        
        [[PFUser currentUser] saveInBackground];
        
        //return to the main view
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else
    {
        //todo error
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
