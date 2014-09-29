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
#import "PCAAllDoneViewController.h"

#define STD_DEV_CUTOFF = 2

@interface PCAMainViewController ()

@end

@implementation PCAMainViewController

NSArray* userSymptoms; //global reference to bitmask of user symptoms
UISlider* sliderRef; //global reference to a slider to get value
UISegmentedControl* radioRef;

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

/**
 Called after the view loads. Does basic checks to grab symptom bitmask and begin cycling through symptom screens
 @return void
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.doneType = NOT_SET;
    
    //Set up app delegate object for use of shared functions
    self.appDel = [[UIApplication sharedApplication] delegate];
    
    //Set up the previous entry dictionary
    [self queryPreviousDictionary];
    
    //Set up the NSArray of previous symptoms for statistical calculations
    [self queryForStatistics];

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
}

-(void)startCycle:(BOOL) shouldCheckCycle
{
    //ALL_DONE_TYPE doneType = [self shouldCycleSymptoms]; //TODO restore this too
    ALL_DONE_TYPE doneType = NOT_DONE;
    
    if (!shouldCheckCycle) //probably new user, don't check, just go
    {
        [self showNextSymptom];
    }
    else if (doneType == NOT_DONE)
    {
        [self showNextSymptom];
    }
    else //not time to enter symptoms, move on
    {
        self.doneType = doneType;
        [self performSegueWithIdentifier:@"allDoneSegue" sender:self];
    }
}

/**
 Called in viewDidLoad. Returns true if it's time for the application to show user symptoms to enter.
 @return BOOL
 */
-(ALL_DONE_TYPE) shouldCycleSymptoms
{
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitflags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit; //prep categories to compare
    NSDateComponents* todayComps = [gregorian components:unitflags fromDate:[NSDate date]];
    NSDateComponents* mostRecentComps = [gregorian components:unitflags fromDate:self.mostRecent.createdAt];
    
    if ([todayComps day] == [mostRecentComps day] &&
        [todayComps month] == [mostRecentComps month] &&
        [todayComps year] == [mostRecentComps year])
    {
        //the most recent entry was created on exactly the same day
        return DONE_ENTERING; //we've clearly already recorded
    }
    else //the most recent entry was created on a different day
    {
        NSDateComponents* todayWeekday = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
        NSDateComponents* recentWeekday = [gregorian components:NSWeekdayCalendarUnit fromDate:self.mostRecent.createdAt];
        //TODO: this does not currently work but should be resolved when SDK updated to 3.0.2
        
        DAYS_OF_WEEK recentDay = (DAYS_OF_WEEK)[recentWeekday weekday];
        DAYS_OF_WEEK todayDay = (DAYS_OF_WEEK)[todayWeekday weekday];
        
        switch(recentDay)
        {
            case TUESDAY:
                if (todayDay == THURSDAY)
                {
                    return NOT_DONE;
                }
                else
                {
                    return NO_NEED;
                }
                break;
            case THURSDAY:
                if (todayDay == SATURDAY)
                {
                    return NOT_DONE;
                }
                else
                {
                    return NO_NEED;
                }
                break;
            case SATURDAY:
                if (todayDay == TUESDAY)
                {
                    return NOT_DONE;
                }
                else
                {
                    return NO_NEED;
                }
                break;
            default:
                //if we get here, we have a problem--previous entry was made not on tuesday, thursday, saturday
                //this will happen frequently during testing
                //TODO handle this here
                return NOT_DONE;
                
        }
    }
}

/**
 Called before executing a segue. Determines what to show when the patient is done
 @param segue to be executed
 @param sender id of sender
 @return void
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController* destinationNC = segue.destinationViewController;
    PCAAllDoneViewController* nextVC = [[destinationNC viewControllers] objectAtIndex:0];
    
    if (self.doneType == NOT_SET)
    {
        nextVC.doneType = DONE_ENTERING; //TODO check this
    }
    else
    {
        nextVC.doneType = self.doneType;
    }
        
}

/**
 Called when a memory warning received
 @return void
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 Called when the user presses the logout button. Sends the user back to the login screen and disengages Catalyze
 @param sender id of the pressed button
 @return IBAction
 */
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

/**
 Called to show UI element for next symptom. Moves currentSymptom class variable
 @param start Symptom to start at (if not showing all symptoms)
 @return void
 */
-(void)showNextSymptom
{
    if (self.currentSymptom < OTHER) //if we haven't moved past the array
    {
        [self showSymptomScreen];
    }
    else //if we have moved completely through the array
    {
        NSLog(@"all done, go to new VC");
        
        [self saveEntryToCatalyze];
    }
}

/**
 Entry method for UI element creation and operation for symptom screen.
 @return void
 */
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

/**
 Prepares the UI elements which instruct the user on what to do. Changes the text depending on whether the input screen uses "radio" buttons or a slider
 @param inputType INPUT_TYPE enum to determine whether to show a slider screen or a radio button screen
 @return void
 */
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

/**
 Prepares the submit button for the symptom screen. Changes the selector based on whether the user is inputting data on a slider or on "radio" buttons
 @param type INPUT_TYPE enum to determine whether to set selector as slider pressed or radio pressed
 @return void
 */
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

/**
 Main method called from showNextSymptom for symptoms requiring radio buttons
 @return void
 */
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

/**
 Main method called from showNextSymptom for symptoms requiring a slider
 @return void
 */
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
    
    //we must set this so we can retrieve value later
    sliderRef = inputSlider;

    [self prepareSubmitButton:SLIDER];
}

/**
 Determines the symptom name for a given symptom
 @param symptom Integer representing desired symptom
 @return NSString
 */
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

/**
 Target selector method to submit data when submit pressed
 @param sender UIButton* reference
 @return void
 @warning Make sure to set labelRef to the appropriate UI element before adding this as a target
 */
-(void)submitPressedSlider:(UIButton*) sender
{
    NSLog(@"submit pressed");
    
    self.valueToSave = sliderRef.value;
    
    [self showConfirmAlert]; //confirm that the user is ready to save this value
}

/**
 Target selector method to submit user data from the radio screen. Uses radioref, global reference
 @param sender UIButton* reference
 @return void
 @warning Make sure to set labelRef to the appropriate UI element before adding this as a target
 */-(void)submitPressedRadio:(UIButton*) sender
{
    NSLog(@"submit pressed");
    
    if ([radioRef selectedSegmentIndex] == UISegmentedControlNoSegment) //if nothing selected
    {
        [self.appDel.defObj showAlert:NOTHING_SELECTED];
    }
    else
    {
        self.valueToSave = (int)[radioRef selectedSegmentIndex];
        
        [self showConfirmAlert];
    }
}

/**
 Called before each symptom screen is shown. Clears all UI subviews in the view
 @return void
 */
-(void)removeSubviews
{
    NSArray* subViews = [self.view subviews];
    for (UIView* v in subViews)
    {
        [v removeFromSuperview];
    }
}

/**
 Shows the user a popup alert when they try to submit a score (any score). User can continue with submission or go back to fix a mistake
 @return void
 */
-(void)showConfirmAlert
{
    NSString* confirmMessage = @"Are you sure this is the value you wish to submit?";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                    message:confirmMessage
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

/**
 Called when the user selects a button in the confirmation popup
 @param alertView UIAlertView* reference to the alert
 @param buttonIndex NSInteger representing which button user pressed on alert
 @return void
 */
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
            [self showNextSymptom];
            break;
            
        default:
            NSLog(@"error");
            break;
    }
}

/**
 Called when user continues through confirmation popup. Updates the esasDictionary.
 @return void
 @warning Note: this does NOT save the dictionary to the backend
 */
-(void) updateEntry
{
    NSLog(@"save data: %.1f", self.valueToSave);

    if (self.currentSymptom == SHORTNESS_OF_BREATH) //special case--different name in schema
    {
        [self.esasDictionary setValue:[NSNumber numberWithDouble:self.valueToSave] forKey:@"shortness_of_breath"];
    }
    else
    {
        [self.esasDictionary setValue:[NSNumber numberWithDouble:self.valueToSave] forKey:[self determineSymptomName:self.currentSymptom]];
    }
    NSLog(@"%@", self.esasDictionary);
}

/**
 Called before all done segue. Creates the esasEntry and saves it to the backend
 @return void
 */
-(void) saveEntryToCatalyze
{
    //first, update the esasDictionary to add an array of urgent symptoms
    [self checkUrgentSymptoms];
    
    CatalyzeEntry* newEsasEntry = [CatalyzeEntry entryWithClassName:@"esasEntry" dictionary:self.esasDictionary];
    [newEsasEntry createInBackgroundWithSuccess:^(id result)
    {
        //all done, move on
        [self performSegueWithIdentifier:@"allDoneSegue" sender:self];
    }
    failure:^(NSDictionary *result, int status, NSError *error)
    {
        NSLog(@"Error in saveinBackground, save unsuccessful");
        NSLog(@"error status: %d", status);
        
        for (NSString* key in [result allKeys])
        {
            NSLog(@"%@", [result valueForKey:key]);
        }
        NSLog(@"dictionary:%@", self.esasDictionary);
    }];
}

/**
 Checks urgent symptoms.
 Automatically makes a symptom urgent if it is over 9 or the highest option on the radio dials
 Records a dictionary of urgent symptoms inside the dictionary of symptoms, since esasEntry has an "urgent" object
 Each entry in the dictionary is either 0 (not urgent), 1 (slightly), or 2 (very)
 These are determined in two ways:
 Any slider symptom above 9 is automatically a 1, if it's 10 it's automatically a 2
 Any radio symptom at highest level is a 1, but TODO check and see if this should be 2 instead
 Any slider symtom > 1 SD above mean is a 1
 Any slider symptom > 2 SD above mean is a 2
 @return void
 */
-(void)checkUrgentSymptoms
{
    NSMutableDictionary* urgentDict = [[NSMutableDictionary alloc] init];
    
    //Set up frequently used NSNumbers
    NSNumber* numTen = [NSNumber numberWithInt:10];
    NSNumber* numNine = [NSNumber numberWithInt:9];
    NSNumber* numThree = [NSNumber numberWithInt:3];
    NSNumber* numTwo = [NSNumber numberWithInt:2];
    NSNumber* numOne = [NSNumber numberWithInt:1];
    NSNumber* numZero = [NSNumber numberWithInt:0];
    
    for (NSString* key in self.esasDictionary)
    {
        NSNumber* temp = [self.esasDictionary objectForKey:key];
        if ([key isEqualToString:@"activity"] || [key isEqualToString:@"anxiety"]) //these both have 2 as the highesrt val
        {
            if (temp == numTwo)
            {
                [urgentDict setValue:numOne forKey:key];
            }
            else
            {
                [urgentDict setValue:numZero forKey:key];
            }
        }
        else if ([key isEqualToString:@"appetite"])
        {
            if (temp == numThree)
            {
                [urgentDict setValue:numOne forKey:key];
            }
            else
            {
                [urgentDict setValue:numZero forKey:key];
            }
        }
        else //all other symptoms go to 10
        {
            if (temp == numTen)
            {
                [urgentDict setValue:numTwo forKey:key];
            }
            else if (temp >= numNine)
            {
                [urgentDict setValue:numOne forKey:key];
            }
            else
            {
                [urgentDict setValue:numZero forKey:key];
            }
        }
    }
    
    //by this point, we have added to set urgency for each symptom which crosses the absolute boundary.
    //now we need to do statistical analysis to determine if any of the symptoms are 1-2 SD's above mean
    //note that this analysis does not need to be done for radio screens, or for symptoms already urgent
    
    //ASSUMPTION: the asynchronous CatalyzeQuery will complete by this point
    
    for (NSString* key in self.esasDictionary)
    {
        if ([key isEqualToString:@"activity"] || [key isEqualToString:@"anxiety"] || [key isEqualToString:@"appetite"])
        {
            continue; //no need to calculate averages for these
        }
        
        if ([urgentDict valueForKey:key] == numTwo) //if already very urgent
        {
            continue; //don't bother
        }
        
        //if not a radio screen and not already super urgent, calculate the mean
        
        //can't calculate mean if no previous entries
        if (self.last60Entries == nil || ([self.last60Entries count] < 1))
        {
            break;
        }
        
        int count = 0;
        double total = 0.0;
        double mean;
        for (CatalyzeEntry* entry in self.last60Entries)
        {
            count++;
            total += [[entry.content valueForKey:key] doubleValue];
        }
        mean = (total / count);
        
        //Now we have the mean for the key, let's calculate the standard deviation
        double sumOfSquaredDiffs = 0.0;
        for (CatalyzeEntry* entry in self.last60Entries)
        {
            double difference = [[entry.content valueForKey:key] doubleValue] - mean;
            sumOfSquaredDiffs += difference * difference;
        }
        
        double standardDev = sqrt(sumOfSquaredDiffs / count);
        
        //Now we have the standard deviation. Compare and decide urgency
        double oneCutoff = 1 * standardDev;
        double twoCutoff = 2 * standardDev;
        
        double absoluteOne = oneCutoff + mean;
        double absoluteTwo = twoCutoff + mean;
        
        absoluteOne = (absoluteOne > 10 ? 10 : absoluteOne); //if greater than 10, reset to 10
        absoluteTwo = (absoluteTwo > 10 ? 10 : absoluteTwo);
        
        //Now check if it's super urgent--greater than absolute two
        if ([[self.esasDictionary valueForKey:key] doubleValue] > absoluteTwo)
        {
            [urgentDict setValue:numTwo forKey:key];
        }
        else if ([[self.esasDictionary valueForKey:key] doubleValue] > absoluteOne)
        {
            [urgentDict setValue:numOne forKey:key];
        }
    }
    
    //finally, add the urgent dictionary to the main dictionary to be saved
    [self.esasDictionary setValue:urgentDict forKey:@"urgent"];
}

/**
 Counts the number of urgent symptoms in a dictionary. Essentially counts the number of 1's
 @param dict NSMutableDictionary* dictionary to count
 @return int
 */
-(int) countUrgentSymptoms:(NSMutableDictionary*) dict
{
    int count = 0;
    
    for (NSString* key in dict)
    {
        if ([dict valueForKey:key] == [NSNumber numberWithInt:1])
        {
            count++;
        }
    }
    
    return count;
}

/**
 Prepares the previousDictionary member variable using the most recent entry on Catalyze
 @return void
 */
-(void) queryPreviousDictionary
{
    CatalyzeQuery* dictQuery = [CatalyzeQuery queryWithClassName:@"esasEntry"];
    [dictQuery setPageNumber:1];
    [dictQuery setPageSize:100];
    
    [dictQuery retrieveInBackgroundForUsersId:[[CatalyzeUser currentUser] usersId] success:^(NSArray *result)
    {
        //When the async query finishes, we get here
        if ([result count] > 0)
        {
            self.mostRecent = [self findMostRecent:result];
            [self startCycle:true];
        }
        else //no recent entries--start cycle automatically as this is a new user
        {
            [self startCycle:false];
        }
    }
    failure:^(NSDictionary *result, int status, NSError *error)
    {
        NSLog(@"query failure in queryPreviousDictionary");
    }];
}

/**
 Queries the last 60 user entries and stores the resulting array as a class variable for use later
 */
-(void)queryForStatistics
{
    CatalyzeQuery* query = [CatalyzeQuery queryWithClassName:@"esasEntry"];
    [query setPageNumber:1];
    [query setPageSize:60];
    
    [query retrieveInBackgroundForUsersId:[[CatalyzeUser currentUser] usersId] success:^(NSArray *result)
    {
        self.last60Entries = result;
    }
    failure:^(NSDictionary *result, int status, NSError *error)
    {
        NSLog(@"query failure in queryforstatistics");
        NSLog(@"%@", error);
    }];
}

/**
 Finds the most recent entry in the query results
 @param result NSArray returned by Catalyze query function
 @return CatalyzeEntry* most recent entry
 */
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
    
    //TODO this is just for debugging
    [self.appDel.defObj showAlertWithText:[NSString stringWithFormat:@"Last pain score was %@", [mostRecent.content valueForKey:@"pain"]]];
    return mostRecent;

    }
@end
