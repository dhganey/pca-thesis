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

NSArray* userSymptoms; //global reference to bitmask of user symptoms

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

//Called after the view loads
//Does basic checks to grab symptom bitmask and begin cycling through symptom screens
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    if ([CatalyzeUser currentUser]) //make sure someone is logged in
    {
        userSymptoms = [[NSArray alloc] init];
        userSymptoms = [[CatalyzeUser currentUser] extraForKey:@"symptomArray"]; //grab the symptom bitmask from the user data
    }
    else
    {
        //TODO error, nobody logged in
    }
    
    if (true) //TODO: this should check if it's time to cycle symptoms, and show something else if not
    {
        currentSymptom = 0; //start at beginning
        [self showNextSymptom:currentSymptom];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//Called when the user presses the logout button. Sends the user back to the login screen and disengages Catalyze
- (IBAction)logoutPressed:(id)sender
{
    [[CatalyzeUser currentUser] logoutWithBlock:^(int status, NSString *response, NSError *error)
    {
        if (error)
        {
            NSLog(@"Error while logging out");
            //TODO handle the error
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

//This method is called to show the UI elements for the next symptom
//It moves the currentSymptom global var
-(void)showNextSymptom:(int) start
{
    while ([[userSymptoms objectAtIndex:currentSymptom] intValue] == 0 && currentSymptom < symptomNum) //until we find an active symptom
    {
        currentSymptom++; //move up, check next symptom
    }
    
    if (currentSymptom < symptomNum) //if we haven't moved past the array
    {
        [self showSymptomScreen:currentSymptom];
    }
    else //if we have moved completely through the array
    {
        NSLog(@"all done, go to new VC");
        [self performSegueWithIdentifier:@"doneSymptomsSegue" sender:self];
    }
}

//Creates and operates the UI elements for the user to enter symptom measurements
//Is called for all symptoms, parameter determines which symptom to show
-(void)showSymptomScreen:(int) symptom
{
    [self removeSubviews]; //first, remove any subviews
    
    NSString* symptomName = [self determineSymptomName:symptom]; //determine which symptom we're on
    
    self.title = [symptomName capitalizedString]; //change the VC title
    
    //prepare the instructions label
    UILabel *instructions = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 280, 40)];
    instructions.lineBreakMode = NSLineBreakByCharWrapping;
    [instructions setNumberOfLines:2];
    instructions.font = [instructions.font fontWithSize:10];
    NSString* instructionString = @"Please drag the slider to record your ";
    instructionString = [instructionString stringByAppendingString:symptomName]; //clarify symptom
    [instructions setText:instructionString];
    [self.view addSubview:instructions];
    
    //prepare the previous value label
    UILabel* preVal = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 290, 40)];
    NSString* preValString = @"Your previous ";
    preValString = [preValString stringByAppendingString:[self determineSymptomName:currentSymptom]];
    preValString = [preValString stringByAppendingString:@" score was "];
    preValString = [preValString stringByAppendingString:@"3"]; //TODO: adjust this to use backend data
    preVal.text = preValString;
    [self.view addSubview:preVal];
    
    //prepare the slider
    UISlider *inputSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 150, 280, 40)];
    [inputSlider setMinimumValue:0];
    [inputSlider setMaximumValue:10];
    [self.view addSubview:inputSlider];
    [inputSlider setValue:5 animated:YES];
    inputSlider.continuous = YES;
    
    //prepare the feedback label
    UILabel *sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x, 200, 280, 40)];
    [sliderLabel setText:[NSString stringWithFormat:@"%.0f", inputSlider.value]];
    [self.view addSubview:sliderLabel];
    
    //set up a selector for when the slider changes
    SEL sliderSel = @selector(sliderChanged:); //selector takes slider as parameter
    [inputSlider addTarget:self action:sliderSel forControlEvents:UIControlEventValueChanged]; //call when changed
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

//Returns a string which contains the symptom name for a given integer
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
-(void)submitPressed:(UIButton*) sender
{
    NSLog(@"submit pressed");
    
    [self showConfirmAlert:[labelRef.text doubleValue]]; //confirm that the user meant to enter the num currently in the label
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

//Shows the user a popup alert when they try to submit a score (any score)
//User can continue with submission or go back to fix a mistake
-(void)showConfirmAlert:(double) value
{
    NSString* confirmMessage = [NSString stringWithFormat:@"You entered %.0f, is that correct?", value];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                    message:confirmMessage
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

//Called when the user selects a button in the confirmation popup
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex)
    {
        case 0: //cancel
            //do nothing
            break;
        case 1: //save
            [self saveEntry];
            
            //move on
            currentSymptom++; //all done with this one!
            [self showNextSymptom:currentSymptom];
            break;
        default:
            NSLog(@"error");
            break;
    }
}

//Called when the user continues through the submit popup alert
//Saves the user entry online
-(void) saveEntry
{
    CatalyzeObject* newEntry = [CatalyzeObject objectWithClassName:@"esasEntry"]; //uses test class on Catalyze dashboard
    NSNumber* painScore = [NSNumber numberWithDouble:[labelRef.text doubleValue]];
    NSNumber* symptomNum = [NSNumber numberWithDouble:currentSymptom];
    
    [newEntry setObject:painScore forKey:@"score"];
    [newEntry setObject:symptomNum forKey:@"symptom"];
    //[newEntry setObject:[CatalyzeUser currentUser] forKey:@"user"]; //TODO figure out how to unify this
    
    [newEntry createInBackground];
    
    NSLog(@"Saved score: %f for symptom %d", [labelRef.text doubleValue], currentSymptom);
}

@end
