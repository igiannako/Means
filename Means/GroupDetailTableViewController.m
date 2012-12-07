//
//  GroupDetailTableViewController.m
//  Means
//
//  Created by Ilias Giannakopoulos on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupDetailTableViewController.h"
#import "KKPasscodeLock.h"

@implementation GroupDetailTableViewController
@synthesize delegate;
@synthesize groupNameTextField;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize group = _group;

/*
 - (id)initWithStyle:(UITableViewStyle)style 
 {
 self = [super initWithStyle:style];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSLog(@"Setting the value of fields in this static table to that of the passed Group");
    self.groupNameTextField.text = self.group.name;
    [groupNameTextField addTarget:self action:@selector(meansTitleTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [super viewDidLoad];
    
    UITapGestureRecognizer *uitapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [uitapgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:uitapgr];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setGroupNameTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}

-(IBAction)dismissKeyboardDone:(id)sender {
    [self.view endEditing:TRUE];
    // do whatever you want with this text field
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    //[self.view endEditing:TRUE];
    [textField resignFirstResponder];
    return YES; // We'll let the textField handle the rest!
}

-(void)meansTitleTextFieldDidChange:(id)sender {
    NSString *stringTemp = groupNameTextField.text;
    stringTemp = [stringTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([stringTemp isEqualToString:@""]) {
        //if ([[sender text] length] == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (IBAction)save:(id)sender
{
    NSLog(@"Telling the GroupDetailTableViewController Delegate that Save was tapped on the GroupDetailTableViewController");
    
    [self.group setName:groupNameTextField.text];
    [self.managedObjectContext save:nil];  // write to database
    [self.delegate theSaveButtonOnTheGroupDetailTableViewControllerWasTapped:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

#pragma mark - Table view data source

/*
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
 #warning Potentially incomplete method implementation.
 // Return the number of sections.
 return 0;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
 #warning Incomplete method implementation.
 // Return the number of rows in the section.
 return 0;
 }

 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }

 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
