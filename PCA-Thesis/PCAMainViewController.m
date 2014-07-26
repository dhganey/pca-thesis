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

int userSymptoms[10]; //global reference to bitmask of user symptoms
int symptomNum = 10; //global reference to num symptoms. should never change, but avoids magic 10

UILabel* labelRef; //global reference to a label to pass to target selectors when UI elements change

int currentSymptom; //global int which reflects currently showing symptom

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
 
    [self initSymptomArray]; //TODO this should init from backend

    if (true) //TODO: this should check if it's time to cycle symptoms, and show something else if not
    {
        currentSymptom = 0; //start at beginning
        [self showNextSymptom:currentSymptom];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Called when the user presses the logout button. Sends the user back to the login screen and disengages Catalyze
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

//This method is called to show the UI elements for the next symptom
//It moves the currentSymptom global var
-(void)showNextSymptom:(int) start
{
    while (userSymptoms[currentSymptom] == 0 && currentSymptom < symptomNum) //until we find an active symptom
    {
        currentSymptom++; //move up, check next symptom
    }
    
    if (currentSymptom < symptomNum) //if we haven't moved past the array
    {
        [self showSymptomScreen:currentSymptom];
    }
    else //if we have
    {
        NSLog(@"all done, go to new VC");
        [self performSegueWithIdentifier:@"doneSymptomsSegue" sender:self];
    }
}

//Creates and operates the UI elements for the user to enter their pain score
-(void)showSymptomScreen:(int) symptom
{
    [self removeSubviews]; //first, remove any subviews
    
    NSString* symptomName = [self determineSymptomName:symptom]; //determine which symptom we're on
    
    self.title = [symptomName capitalizedString]; //change the VC title
    
    //prepare the instructions label
    UILabel *instructions = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 280, 40)];
    instructions.lineBreakMode = NSLineBreakByCharWrapping;
    [instructions setNumberOfLines:2];
    NSString* instructionString = @"Please drag the slider to record your ";
    instructionString = [instructionString stringByAppendingString:symptomName]; //clarify symptom
    [instructions setText:instructionString];
    [self.view addSubview:instructions];
    
    //prepare the previous value label
    UILabel* preVal = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 290, 40)];
    NSString* preValString = @"Your previous pain score was: ";
    preValString = [preValString stringByAppendingString:@"3"]; //TODO: adjust this to use backend data
    preVal.text = preValString;
    [self.view addSubview:preVal];
    
    //prepare the slider
    UISlider *painSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 150, 280, 40)];
    [painSlider setMinimumValue:0];
    [painSlider setMaximumValue:10];
    [self.view addSubview:painSlider];
    [painSlider setValue:5 animated:YES];
    painSlider.continuous = YES;
    
    //prepare the feedback label
    UILabel *sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x, 200, 280, 40)];
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

-(NSString*)determineSymptomName:(int)symptom
{
    switch(symptom)
    {
        case 0:
            return @"pain";
        case 1:
            return @"tiredness";
        case 2:
            return @"drowsiness";
        case 3:
            return @"nausea";
        case 4:
            return @"appetite";
        case 5:
            return @"shortness of breath";
        case 6:
            return @"depression";
        case 7:
            return @"anxiety";
        case 8:
            return @"wellbeing";
        case 9:
            return @"other";
        default:
            return @"ERROR in determinesymptomname";
    }
}

//Target selector method to adjust a label when a slider changes.
//Uses labelRef, the global reference at the top. Make sure to set that to the appropriate UI element before adding this
//method as a target to the slider
-(void)sliderChanged:(UISlider*) sender
{
    [labelRef setText:[NSString stringWithFormat:@"%.0f", sender.value]];
}

//Target selector method to submit user data.
//TODO: decide on the design here. Could have a unique submit method for each symptom screen, or could set a global var and do a switch statement?
-(void)submitPressed:(UIButton*) sender
{
    NSLog(@"submit pressed");
    
    //TODO: NSAlert to confirm the users entered score is right
    //TODO: store the data somewhere
    
    
    //move on
    currentSymptom++; //all done with this one!
    [self showNextSymptom:currentSymptom];
}

//Called before each symptom screen is shown. Clears all UI subviews in the view
-(void)removeSubviews
{
    NSArray* subViews = [self.view subviews];
    for (UIView* v in subViews)
    {
        [v removeFromSuperview];
    }
}

@end
