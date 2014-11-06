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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Set up app delegate object for use of shared functions
    self.appDel = [[UIApplication sharedApplication] delegate];
    
    [self executeQuery];
}

//TODO -- this is a terrible algorithm and it must be revised
-(void) executeQuery
{
    CatalyzeQuery* query = [CatalyzeQuery queryWithClassName:@"esasEntry"];
    [query setPageNumber:1];
    [query setPageSize:100];
    
    NSMutableDictionary* checkedIDs = [[NSMutableDictionary alloc] init]; //hashtable holding IDs we've already checked
    
    //TODO--should also be filtering to just the doctor's patients? right now, he sees all esasEntries
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
                CatalyzeEntry* mostRecent = [self.appDel.defObj findMostRecent:immutableArr];
                [checkedIDs setObject:mostRecent forKey:mostRecent.authorId];
            }
        }];
        //at this point, we should have the most recent entry for each user
        self.recentEntries = [checkedIDs allValues];
        [self.tableView reloadData];
    }
    failure:^(NSDictionary *result, int status, NSError *error)
     {
         //TODO handle this failure case
     }];
}

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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
    cellLabel.text = entry.authorId; //TODO -- how to get usernames?
    
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
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: transfer the specific patient information to the patientdetailviewcontroller
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
