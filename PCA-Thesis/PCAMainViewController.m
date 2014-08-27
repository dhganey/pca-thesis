//
//  PCAMainViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 7/21/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCAMainViewController.h"

#import "Catalyze.h"

#import "PCADefinitions.h"

@interface PCAMainViewController ()

@end

@implementation PCAMainViewController

NSArray* userSymptoms; //global reference to bitmask of user symptoms

UILabel* labelRef; //global reference to a label to pass to target selectors when UI elements change

UISegmentedControl* radioRef;

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
    
    self.currentSymptom = 0; //start at beginning
 
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
        [self showNextSymptom:self.currentSymptom];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//Called when the user presses the logout button. Sends the user back to the login screen and disengages Catalyze
- (IBAction)logoutPressed:(id)sender
{
    [[CatalyzeUser currentUser] logoutWithSuccess:^(id result)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    failure:^(NSDictionary *result, int status, NSError *error)
    {
        NSLog(@"Error while logging out");
        //TODO handle the error

    }];
}

//This method is called to show the UI elements for the next symptom
//It moves the currentSymptom global var
-(void)showNextSymptom:(int) start
{
    while ([[userSymptoms objectAtIndex:self.currentSymptom] intValue] == 0 && self.currentSymptom < MAX_SYMPTOMS) //until we find an active symptom
    {
        self.currentSymptom++; //move up, check next symptom
    }
    
    if (self.currentSymptom < MAX_SYMPTOMS) //if we haven't moved past the array
    {
        [self showSymptomScreen];
    }
    else //if we have moved completely through the array
    {
        NSLog(@"all done, go to new VC");
        [self performSegueWithIdentifier:@"doneSymptomsSegue" sender:self];
    }
}

//Entry method for UI element creation and operation for symptom screen
//Is called for all symptoms, parameter determines which symptom to show
-(void)showSymptomScreen
{
    [self removeSubviews]; //first, remove any subviews
    
    NSString* symptomName = [self determineSymptomName:self.currentSymptom]; //determine which symptom we're on
    
    self.title = [symptomName capitalizedString]; //change the VC title

    //Uses the enumerated type in PCADefinitions.h to determine whether to show a generic slider screen or specific "radio" buttons
    if (self.currentSymptom == PAIN || self.currentSymptom == NAUSEA || self.currentSymptom == DEPRESSION || self.currentSymptom == DROWSINESS || self.currentSymptom == WEAKNESS || self.currentSymptom == SHORTNESS_OF_BREATH) //analog scale
    {
        [self showSliderScreen];
    }
    else if (self.currentSymptom == ACTIVITY || self.currentSymptom == ANXIETY || self.currentSymptom == APPETITE)
    {
        [self showRadioButtonScreen];
    }
    else
    {
        NSLog(@"Error in showSymptomScreen");
    }
}

//Prepares the UI elements which instruct the user on what to do
//Changes the text depending on whether the input screen uses "radio" buttons or a slider
-(void) prepareInstructionLabel:(INPUT_TYPE) inputType
{
    NSString* instructionString = @"Please ";
    if (inputType == SLIDER)
    {
        instructionString = [instructionString stringByAppendingString:@"drag the slider to enter your "];
    }
    else if (inputType == RADIO)
    {
        instructionString = [instructionString stringByAppendingString:@"click the button which reflects your "];
    }
    else
    {
        NSLog(@"error in prepareInstructionLabel");
    }
    
    UILabel *instructions = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 280, 40)];
    instructions.lineBreakMode = NSLineBreakByCharWrapping;
    [instructions setNumberOfLines:2];
    instructions.font = [instructions.font fontWithSize:10];
    instructionString = [instructionString stringByAppendingString:[self determineSymptomName:self.currentSymptom]]; //clarify symptom
    [instructions setText:instructionString];
    [self.view addSubview:instructions];
}

//Prepares the UI elements to tell the user what their previously entered value was
-(void) preparePreviousInstructionLabel
{
    UILabel* preVal = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 290, 40)];
    NSString* preValString = @"Your previous ";
    preValString = [preValString stringByAppendingString:[self determineSymptomName:self.currentSymptom]];
    preValString = [preValString stringByAppendingString:@" score was "];
    preValString = [preValString stringByAppendingString:@"todo"]; //TODO: adjust this to use backend data
    preVal.text = preValString;
    [self.view addSubview:preVal];
}

//Prepares the submit button for the symptom screen
//Changes the selector based on whether the user is inputting data on a slider or on "radio" buttons
-(void) prepareSubmitButton:(INPUT_TYPE) type
{
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame = CGRectMake(self.view.center.x, self.view.center.y, 160, 40);
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self.view addSubview:submitButton];
    
    SEL buttonSel; //set up a selector for when button pressed
    if (type == SLIDER)
    {
        buttonSel = @selector(submitPressedSlider:); //takes button as param
    }
    else if (type == RADIO)
    {
        buttonSel = @selector(submitPressedRadio:);
    }
    else
    {
        NSLog(@"error in prepareSubmitButton");
    }
    
    [submitButton addTarget:self action:buttonSel forControlEvents:UIControlEventTouchUpInside]; //call when pressed
}

//Main method called from showNextSymptom for symptoms requiring radio buttons
-(void) showRadioButtonScreen
{
    [self prepareInstructionLabel:RADIO];
    
    [self preparePreviousInstructionLabel];
    
    NSArray* buttonTexts;
    UISegmentedControl* segControl;
    
    //prepare the buttons
    if (self.currentSymptom == ACTIVITY)
    {
        buttonTexts = [NSArray arrayWithObjects:@"Full", @"Reduced", @"Assistance required", nil];
    }
    else if (self.currentSymptom == ANXIETY)
    {
        buttonTexts = [NSArray arrayWithObjects:@"No anxiety", @"Typical anxiety", @"Greater than usual", nil];
    }
    else if (self.currentSymptom == APPETITE)
    {
        buttonTexts = [NSArray arrayWithObjects:@"Good/fair eating", @"Reduced intake", @"Fluids only", @"Nothing by mouth", nil];
    }
    else
    {
        NSLog(@"error in showRadioButtonScreen");
    }
    
    segControl = [[UISegmentedControl alloc] initWithItems:buttonTexts];
    segControl.frame = CGRectMake(10, 150, 200, 40);
    [self.view addSubview:segControl];
    radioRef = segControl;
    
    [self prepareSubmitButton:RADIO];
}

//Main method called from showNextSymptom for symptoms requiring a slider
-(void)showSliderScreen
{
    [self prepareInstructionLabel:SLIDER];
    
    [self preparePreviousInstructionLabel];
    
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

    [self prepareSubmitButton:SLIDER];
}

//Returns a string which contains the symptom name for a given integer
-(NSString*)determineSymptomName:(int)symptom
{
    switch(symptom)
    {
        case 0:
            return @"pain";
        case 1:
            return @"activity";
        case 2:
            return @"nausea";
        case 3:
            return @"depression";
        case 4:
            return @"anxiety";
        case 5:
            return @"drowsiness";
        case 6:
            return @"appetite";
        case 7:
            return @"weakness";
        case 8:
            return @"shortness of breath";
        case 9:
            return @"other";
        default:
            return @"error in determineSymptomName";
    }
}

//Target selector method to adjust a label when a slider changes.
//Uses labelRef, the global reference at the top. Make sure to set that to the appropriate UI element before adding this
//method as a target to the slider
-(void)sliderChanged:(UISlider*) sender
{
    [labelRef setText:[NSString stringWithFormat:@"%.0f", sender.value]];
}

//Target selector method to submit user data from slider screen.
-(void)submitPressedSlider:(UIButton*) sender
{
    NSLog(@"submit pressed");
    
    self.valueToSave = [labelRef.text doubleValue];
    
    [self showConfirmAlert:[NSString stringWithFormat:@"%.0f", [labelRef.text doubleValue]]]; //confirm that the user meant to enter the num currently in the label
}

//Target selector method to submit user data from radio button screen
-(void)submitPressedRadio:(UIButton*) sender
{
    NSLog(@"submit pressed");
    
    self.valueToSave = (int)[radioRef selectedSegmentIndex];
    
    [self showConfirmAlert:[radioRef titleForSegmentAtIndex:[radioRef selectedSegmentIndex]]];
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
-(void)showConfirmAlert:(NSString*) value
{
    NSString* confirmMessage = [NSString stringWithFormat:@"You entered %@, is that correct?", value];
    
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
            //TODO save data here
            NSLog(@"save data: %d", self.valueToSave);
            //move on
            self.currentSymptom++;
            [self showNextSymptom:self.currentSymptom];
            break;
        default:
            NSLog(@"error");
            break;
    }
}
@end
