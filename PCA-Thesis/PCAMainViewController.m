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
#import "PCAAppDelegate.h"

@interface PCAMainViewController ()

@end

@implementation PCAMainViewController

NSArray* userSymptoms; //global reference to bitmask of user symptoms

UILabel* labelRef; //global reference to a label to pass to target selectors when UI elements change
UISegmentedControl* radioRef;
UILabel* preVal;

int X_OFFSET = 10;
int INSTRUCTION_Y_OFFSET = 65;
int PREVIOUS_Y_OFFSET = 105;
int INPUT_Y_OFFSET = 150;
int FEEDBACK_Y_OFFSET = 190;
int HEIGHT = 40;
int FONT_SIZE = 15;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //custom init
    }
    return self;
}

//Called after the view loads
//Does basic checks to grab symptom bitmask and begin cycling through symptom screens
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set up app delegate object for use of shared functions
    self.appDel = [[UIApplication sharedApplication] delegate];
    
    //Set up the previous entry dictionary which is used to show users their last entered score
    [self queryPreviousDictionary];
    
    //Set up esasDictionary which will hold inputted symptom data and is saved to a CatalyzeEntry at the end
    self.esasDictionary = [[NSMutableDictionary alloc] init];
    
    //Start at beginning...
    self.currentSymptom = 0;
 
    if ([CatalyzeUser currentUser]) //make sure someone is logged in
    {
        userSymptoms = [[NSArray alloc] init];
        userSymptoms = [[CatalyzeUser currentUser] extraForKey:@"symptomArray"]; //grab the symptom bitmask from the user data
    }
    else
    {
        [self.appDel.defObj showAlert:NO_USER_LOGGED_IN];
    }
    
    if (true) //TODO: this should check if it's time to cycle symptoms, and show something else if not
    {
        [self showNextSymptom:self.currentSymptom];
    }
}

//Called when a memory warning is received
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
        [self.appDel.defObj showAlert:LOGOUT_ERROR];
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
        
        [self saveEntryToCatalyze];
    }
}

//Entry method for UI element creation and operation for symptom screen
//Is called for all symptoms, parameter determines which symptom to show
-(void)showSymptomScreen
{
    [self removeSubviews]; //first, remove any subviews
    
    [self preparePreviousInstructionLabel];
    [self.view addSubview:preVal];
    
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
    
    UILabel *instructions = [[UILabel alloc] initWithFrame:CGRectMake(X_OFFSET, INSTRUCTION_Y_OFFSET, CGRectGetWidth(self.view.bounds), HEIGHT)];
    instructions.lineBreakMode = NSLineBreakByCharWrapping;
    [instructions setNumberOfLines:2];
    instructions.font = [instructions.font fontWithSize:FONT_SIZE];
    instructionString = [instructionString stringByAppendingString:[self determineSymptomName:self.currentSymptom]]; //clarify symptom
    [instructions setText:instructionString];
    [self.view addSubview:instructions];
}

//Prepares the UI element which will tell the user what their previously entered value was
//Displays "?" when no value found
-(void) preparePreviousInstructionLabel
{
    preVal = [[UILabel alloc] initWithFrame:CGRectMake(X_OFFSET, PREVIOUS_Y_OFFSET, CGRectGetWidth(self.view.bounds), HEIGHT)];
    NSString* preValString = @"Your previous ";
    preValString = [preValString stringByAppendingString:[self determineSymptomName:self.currentSymptom]];
    preValString = [preValString stringByAppendingString:@" score was "];
    
    if (self.previousDictionary != nil)
    {
        NSString* tempString = [NSString stringWithFormat:@"%@", [self.previousDictionary objectForKey:[self determineSymptomName:self.currentSymptom]]];
        preValString = [preValString stringByAppendingString:tempString];
    }
    else
    {
        preValString = [preValString stringByAppendingString:@"?"];
    }
    [preVal setText:preValString];
    [preVal setNeedsDisplay];
    [self.view setNeedsDisplay];
}

//Updates the preVal UI Label with new information from the dictionary.
//ONLY called when the query finishes, so no need to check dictionary validity
-(void) updatePreviousInstructionsLabel
{
    NSString* basic = [NSString stringWithFormat:@"Your previous %@ score was ", [self determineSymptomName:self.currentSymptom]];
    NSString* value = [NSString stringWithFormat:@"%@", [self.previousDictionary objectForKey:[self determineSymptomName:self.currentSymptom]]];
    [preVal setText:[NSString stringWithFormat:@"%@%@", basic, value]]; //manual concatenation?
    [self.view setNeedsDisplay];
}

//Prepares the submit button for the symptom screen
//Changes the selector based on whether the user is inputting data on a slider or on "radio" buttons
-(void) prepareSubmitButton:(INPUT_TYPE) type
{
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame = CGRectMake(self.view.center.x, self.view.center.y, 100, HEIGHT);
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
    
    NSArray* buttonTexts;
    UISegmentedControl* segControl;
    
    //prepare the buttons
    if (self.currentSymptom == ACTIVITY)
    {
        buttonTexts = [NSArray arrayWithObjects:@"Full", @"Reduced", @"Need Assistance", nil];
    }
    else if (self.currentSymptom == ANXIETY)
    {
        buttonTexts = [NSArray arrayWithObjects:@"No anxiety", @"Typical anxiety", @"Greater than usual", nil];
    }
    else if (self.currentSymptom == APPETITE)
    {
        buttonTexts = [NSArray arrayWithObjects:@"Good eating", @"Reduced intake", @"Fluids only", @"Nothing by mouth", nil];
    }
    else
    {
        NSLog(@"error in showRadioButtonScreen");
    }
    
    segControl = [[UISegmentedControl alloc] initWithItems:buttonTexts];
    segControl.frame = CGRectMake(X_OFFSET, INPUT_Y_OFFSET, CGRectGetWidth(self.view.bounds)-2*X_OFFSET, HEIGHT);
    [self.view addSubview:segControl];
    radioRef = segControl;
    
    [self prepareSubmitButton:RADIO];
}

//Main method called from showNextSymptom for symptoms requiring a slider
-(void)showSliderScreen
{
    [self prepareInstructionLabel:SLIDER];
    
    //prepare the slider
    UISlider *inputSlider = [[UISlider alloc] initWithFrame:CGRectMake(X_OFFSET, INPUT_Y_OFFSET, CGRectGetWidth(self.view.bounds)-2*X_OFFSET, HEIGHT)];
    [inputSlider setMinimumValue:0];
    [inputSlider setMaximumValue:10];
    [self.view addSubview:inputSlider];
    [inputSlider setValue:5 animated:YES];
    inputSlider.continuous = YES;
    
    //prepare the feedback label
    UILabel *sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x, FEEDBACK_Y_OFFSET, CGRectGetWidth(self.view.bounds), HEIGHT)];
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
        case PAIN:
            return @"pain";
        case ACTIVITY:
            return @"activity";
        case NAUSEA:
            return @"nausea";
        case DEPRESSION:
            return @"depression";
        case ANXIETY:
            return @"anxiety";
        case DROWSINESS:
            return @"drowsiness";
        case APPETITE:
            return @"appetite";
        case WEAKNESS:
            return @"weakness";
        case SHORTNESS_OF_BREATH:
            return @"shortness of breath";
        case OTHER:
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
    
    if ([radioRef selectedSegmentIndex] == UISegmentedControlNoSegment) //if nothing selected
    {
        [self.appDel.defObj showAlert:NOTHING_SELECTED];
    }
    else
    {
        self.valueToSave = (int)[radioRef selectedSegmentIndex];
        
        [self showConfirmAlert:[radioRef titleForSegmentAtIndex:[radioRef selectedSegmentIndex]]];
    }
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
    BUTTON_VALUE buttonVal = (BUTTON_VALUE)buttonIndex; //for clarity in switch statement
    
    switch(buttonVal)
    {
        case CANCEL:
            //do nothing
            break;
            
        case CONTINUE:
            [self updateEntry];
            
            //move on
            self.currentSymptom++;
            [self showNextSymptom:self.currentSymptom];
            break;
            
        default:
            NSLog(@"error");
            break;
    }
}

//Called when user continues through confirmation popup
//Updates the esasDictionary but does NOT save it to the backend
-(void) updateEntry
{
    NSLog(@"save data: %d", self.valueToSave);
    NSNumber* temp = [NSNumber numberWithInt:self.valueToSave];
    [self.esasDictionary setValue:temp forKey:[self determineSymptomName:self.currentSymptom]];
}

//Called before all done segue
//Creates the esasEntry and saves it to the backend
-(void) saveEntryToCatalyze
{
    CatalyzeEntry* newEsasEntry = [CatalyzeEntry entryWithClassName:@"esasEntry" dictionary:self.esasDictionary];
    [newEsasEntry createInBackgroundWithSuccess:^(id result)
    {
        //once we've saved that entry, determine if there are any issues:
        //[[CatalyzeUser currentUser] setExtra:[self determineUrgentSymptoms] forKey:@"urgentSymptoms"];
        //[[CatalyzeUser currentUser] saveInBackground];
        //TODO
 
        //all done, move on
        [self performSegueWithIdentifier:@"doneSymptomsSegue" sender:self];
    }
    failure:^(NSDictionary *result, int status, NSError *error)
    {
        NSLog(@"Error in saveinBackground, save unsuccessful");
        NSLog(@"error status: %d", status);
        
        for (NSString* key in [result allKeys])
        {
            NSLog(@"%@", [result valueForKey:key]);
        }
    }];
}

//Called in viewDidLoad
//Prepares the previousDictionary member variable using the most recent entry on Catalyze
-(void) queryPreviousDictionary
{
    CatalyzeQuery* dictQuery = [CatalyzeQuery queryWithClassName:@"esasEntry"];
    [dictQuery setPageNumber:1];
    [dictQuery setPageSize:100];
    
    [dictQuery retrieveInBackgroundForUsersId:[[CatalyzeUser currentUser] usersId] success:^(NSArray *result)
    {
        //When the async query finishes, we get here
        CatalyzeEntry* mostRecent = [self findMostRecent:result];
        self.previousDictionary = [mostRecent content];
        [self updatePreviousInstructionsLabel];
    }
    failure:^(NSDictionary *result, int status, NSError *error)
    {
        NSLog(@"query failure in queryPreviousDictionary");
    }];
}

-(CatalyzeEntry*) findMostRecent:(NSArray*) result
{
    CatalyzeEntry* mostRecent = result[0];
    
    for (CatalyzeEntry* entry in result)
    {
        NSComparisonResult comp = [mostRecent.createdAt compare:entry.createdAt];
        if (comp == NSOrderedAscending)
        {
            mostRecent = entry;
        }
        //else, leave it--doesn’t matter
    }
    
    return mostRecent;
}
@end
