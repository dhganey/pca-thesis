//
//  PCAPatientTableViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 8/27/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCAPatientTableViewController.h"

#import "PCADefinitions.h"
#import "Catalyze.h"
#import "PCAPatientDetailViewController.h"

@interface PCAPatientTableViewController ()

@end

@implementation PCAPatientTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 When the view loads, execute the query
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/**
 Runs a CatalyzeQuery to get "translations" for the user's names and IDs
 */
-(void) queryUserTranslations
{
    CatalyzeQuery* query = [CatalyzeQuery queryWithClassName:@"userTranslation"];
    [query setPageNumber:1];
    [query setPageSize:100];
    
    NSMutableDictionary* finalResult = [[NSMutableDictionary alloc] init];
    
    [query retrieveAllEntriesInBackgroundWithSuccess:^(NSArray *result)
    {
        for (CatalyzeEntry* entry in result)
        {
            NSString* fullName = [entry.content valueForKey:@"firstName"];
            fullName = [fullName stringByAppendingString:@" "];
            fullName = [fullName stringByAppendingString:[entry.content valueForKey:@"lastName"]];
            [finalResult setValue:fullName forKey:[entry.content valueForKey:@"userId"]];
            
            self.userTranslation = finalResult;
        }
    } failure:^(NSDictionary *result, int status, NSError *error)
    {
        NSLog(@"query fail");
    }];
}

/**
 Executes the Catalyze query on esasEntry classes
 If the user is in the doctor's ACL, this will return values
 It then filters to the most recent for each unique ID and saves them to an instance var
 @return void
 */
-(void) executeQuery
{
    CatalyzeQuery* query = [CatalyzeQuery queryWithClassName:@"esasEntry"];
    [query setPageNumber:1];
    [query setPageSize:100];
    
    NSMutableDictionary* checkedIDs = [[NSMutableDictionary alloc] init]; //hashtable holding IDs we've already checked
    
    [query retrieveAllEntriesInBackgroundWithSuccess:^(NSArray *result)
    {
        [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            CatalyzeEntry* entry = obj;
            if ([checkedIDs objectForKey:entry.authorId] == nil)
            {
                NSMutableArray* sameIDs = [[NSMutableArray alloc] init];
                [sameIDs addObject:entry];
                for (NSUInteger i = idx + 1; i < [result count]; i++)
                {
                    CatalyzeEntry* newEntry = [result objectAtIndex:i];
                    if (newEntry.authorId == entry.authorId)
                    {
                        [sameIDs addObject:newEntry];
                    }
                }
                
                //once we have all the IDs, get the most recent
                NSArray* immutableArr = sameIDs;
                CatalyzeEntry* mostRecent = [PCADefinitions findMostRecent:immutableArr];
                [checkedIDs setObject:mostRecent forKey:mostRecent.authorId];
            }
        }];
        
        //at this point, we should have the most recent entry for each user
        //prep them for use in the table view
        self.recentEntries = [checkedIDs allValues];
        [self filterRecentValuesToProvider];
        [self sortRecentEntriesByUrgency];
        
        [self.tableView reloadData];
    }
    failure:^(NSDictionary *result, int status, NSError *error)
     {
         //TODO handle this failure case
     }];
}

/**
 Removes recent values from the class variable unless their provider
 id matches the current user's id
 */
-(void) filterRecentValuesToProvider
{
    NSMutableArray* newArray = [[NSMutableArray alloc] init];
    NSString* usersId = [[CatalyzeUser currentUser] usersId];
    
    for (CatalyzeEntry* entry in self.recentEntries)
    {
        NSString* validDoctor = [entry.content valueForKey:@"doctor"];
        if ([validDoctor isEqualToString:usersId])
        {
            [newArray addObject:entry];
        }
    }
    
    self.recentEntries = newArray;
}

/**
 Reorganizes the recent values in the class variable according to number of
 urgent symptoms
 */
-(void) sortRecentEntriesByUrgency
{
    NSArray* sortedArray = [self.recentEntries sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        CatalyzeEntry* entry1 = (CatalyzeEntry*) obj1;
        CatalyzeEntry* entry2 = (CatalyzeEntry*) obj2;
        
        NSDictionary* urgent1 = [entry1.content valueForKey:@"urgent"];
        NSDictionary* urgent2 = [entry2.content valueForKey:@"urgent"];
        
        int numUrgent1 = [self countUrgentSymptoms:urgent1];
        int numUrgent2 = [self countUrgentSymptoms:urgent2];
        
        if (numUrgent1 == numUrgent2)
        {
            return NSOrderedSame;
        }
        else if (numUrgent1 > numUrgent2)
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedDescending;
        }
    }];
    
    self.recentEntries = sortedArray;
}

/**
 Counts the number of urgent symptoms in a dictionary. Essentially counts the number of 1's
 @param dict NSMutableDictionary* dictionary to count
 @return int
 */
-(int) countUrgentSymptoms:(NSDictionary*) dict
{
    int count = 0;
    
    for (NSString* key in dict)
    {
        if ([[dict valueForKey:key] isEqualToNumber:[NSNumber numberWithInt:1]])
        {
            count++;
        }
    }
    
    return count;
}

/**
 Computes the number of urgent entries in the given entry
 @param entry Full CatalyzeEntry (not just the urgents dictionary!)
 @return urgentSum int representing how many symptoms are urgent
 */
-(int) urgentSum: (CatalyzeEntry*)entry
{
    NSArray* urgents = [(NSDictionary*)[entry.content valueForKey:@"urgent"] allValues];
    
    int count = 0;
    for (NSUInteger i = 0; i < [urgents count]; i++)
    {
        if ([[urgents objectAtIndex:i] intValue] > 0)
        {
            count++;
        }
    }
    
    return count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; //one section for now
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recentEntries count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"patientCell" forIndexPath:indexPath];
    CatalyzeEntry* entry = [self.recentEntries objectAtIndex:indexPath.row];
    
    UILabel* cellLabel = (UILabel*)[cell viewWithTag:111];
    cellLabel.text = [self.userTranslation valueForKey:entry.authorId];
    
    UILabel* urgentLabel = (UILabel*)[cell viewWithTag:222];
    NSString* labelText = [NSString stringWithFormat:@"#Urgent: %d", [self urgentSum:entry]];
    urgentLabel.text = labelText;
    if ([self urgentSum:entry] > 0)
    {
        urgentLabel.textColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    }
    
    return cell;
}

/**
 Event triggered when doctor clicks a patient's name
 @param tableView UITableView*
 @param indexPath NSIndexPath representing the specific cell clicked
 @return void
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedEntry = [self.recentEntries objectAtIndex:indexPath.row]; //preserve the entry for the segue
    [self performSegueWithIdentifier:@"patientDetailSegue" sender:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PCAPatientDetailViewController* nextVC = [segue destinationViewController];
    nextVC.selectedEntry = self.selectedEntry;
    nextVC.userTranslation = self.userTranslation;
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
         [PCADefinitions showAlert:LOGOUT_ERROR];
     }];
}



@end
