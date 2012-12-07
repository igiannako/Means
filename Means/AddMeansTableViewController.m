//
//  AddMeansTableViewController.m
//  Means
//
//  Created by Ilias Giannakopoulos on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddMeansTableViewController.h"
#import "KKPasscodeLock.h"

@implementation AddMeansTableViewController
@synthesize delegate;
//@synthesize meansNameTextField;
@synthesize managedObjectContext = __managedObjectContext;

@synthesize meansTitleTextField;
@synthesize meansContentTextView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [meansTitleTextField addTarget:self action:@selector(meansTitleTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
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
    [self setMeansTitleTextField:nil];
    [self setMeansContentTextView:nil];
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

-(void)meansTitleTextFieldDidChange:(id)sender {
    NSString *stringTemp = meansTitleTextField.text;
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
    NSLog(@"Telling the AddMeansTableViewController Delegate that Save was tapped on the AddMeansTableViewController");
    
    Means *means = [NSEntityDescription insertNewObjectForEntityForName:@"Means"
                                                 inManagedObjectContext:self.managedObjectContext];
    //means.title = meansNameTextField.text;
    //means.title = meansTitleTextField.text;
    means.title = meansTitleTextField.text;
    means.variable1 = meansContentTextView.text;
    [self.managedObjectContext save:nil];  // write to database
    [self.delegate theSaveButtonOnTheAddMeansTableViewControllerWasTapped:self];
}

@end
