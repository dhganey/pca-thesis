//
//  PCAMainViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 7/21/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCAMainViewController.h"

#import "Catalyze.h"

@interface PCAMainViewController ()

@end

@implementation PCAMainViewController

int userSymptoms[10];
int symptomNum = 10;

UILabel* labelRef;

/* Symptoms go in the following order:
 Pain
 Tiredness
 Drowsiness
 Nausea
 Appetite
 Shortness of breath
 Depression
 Anxiety
 Wellbeing
 Other?
 */

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
    
    [self initSymptomArray];
    
    if (true) //TODO: this should check if it's time to cycle symptoms, and show something else if not
    {
        [self cycleSymptoms];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutPressed:(id)sender
{
    [[CatalyzeUser currentUser] logoutWithBlock:^(int status, NSString *response, NSError *error)
    {
        if (error)
        {
            //TODO handle the error
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

//Arbitrarily populates the user symptoms array to give us the first 4 symptoms active
-(void)initSymptomArray
{
    for (int i = 0; i < symptomNum; i++)
    {
        if (i < 4) //get first 4 symptoms, arbitrary
        {
            userSymptoms[i] = 1;
        }
        else
        {
            userSymptoms[i] = 0;
        }
    }
}

//This is the primary method called when the user enters the main screen
//This method is only called if it's time for the user to enter symptoms
-(void)cycleSymptoms
{
    for (int i = 0; i < symptomNum; i++) //main loop through all symptoms
    {
        if (userSymptoms[i] == 0) //if the symptom is not active,
        {
            continue; //move on
        }
        
        //Otherwise, enter a symptom screen method
        switch(i)
        {
            case 0: //pain
                [self showPainScreen];
                break;
            
            case 1: //tiredness
                
                break;
            
            case 2: //drowsiness
                
                break;
            
            case 3: //nausea
                
                break;
            
            case 4: //appetite
                
                break;
            
            case 5: //shortness of breath
                
                break;
            
            case 6: //depression
                
                break;
            
            case 7: //anxiety
                
                break;
            
            case 8: //wellbeing
                
                break;
            
            case 9: //other
                
                break;
            
            default: //never called
                break;
        }
    }
}

//Creates and adjusts the UI elements for the user to enter their pain score
-(void)showPainScreen
{
    self.title = @"Pain"; //change the VC title
    
    //prepare the instructions label
    UILabel *instructions = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 280, 40)];
    [instructions setText:@"Please drag the slider to record your pain. 0 is the lowest pain and 10 the highest"];
    [self.view addSubview:instructions];
    
    //prepare the slider
    UISlider *painSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 100, 280, 40)];
    [painSlider setMinimumValue:0];
    [painSlider setMaximumValue:10];
    [self.view addSubview:painSlider];
    [painSlider setValue:5 animated:YES];
    painSlider.continuous = YES;
    
    //prepare the feedback label
    UILabel *sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x, 150, 280, 40)];
    [sliderLabel setText:[NSString stringWithFormat:@"%.0f", painSlider.value]];
    [self.view addSubview:sliderLabel];
    
    //set up a selector for when the slider changes
    SEL sliderSel = @selector(sliderChanged:); //selector takes slider as parameter
    [painSlider addTarget:self action:sliderSel forControlEvents:UIControlEventValueChanged]; //call when changed
    //we MUST set the class var labelRef so sliderChanged knows which label to modify
    labelRef = sliderLabel;
    
    //set up a submit button
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame = CGRectMake(self.view.center.x, self.view.center.y, 160, 40);
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self.view addSubview:submitButton];
    
    //set up a selector for when button pressed
    SEL buttonSel = @selector(submitPressed:); //takes button as param
    [submitButton addTarget:self action:buttonSel forControlEvents:UIControlEventTouchUpInside]; //call when pressed
}


-(void)sliderChanged:(UISlider*) sender
{
    [labelRef setText:[NSString stringWithFormat:@"%.0f", sender.value]];
}

-(void)submitPressed:(UIButton*) sender
{
    NSLog(@"submit pressed");
    //TODO take some action
}

@end
