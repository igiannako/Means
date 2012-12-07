//
//  MeansDetailTableViewController.m
//  Means
//
//  Created by Ilias Giannakopoulos on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MeansDetailTableViewController.h"
#import "KKPasscodeLock.h"

@implementation MeansDetailTableViewController;
@synthesize delegate;
//@synthesize meansNameTextField;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize means = _means;
@synthesize selectedGroup;
@synthesize meansTitleTextField = _meansTitleTextField;
//@synthesize meansVariable1TextField = _meansVariable1TextField;
@synthesize meansGroupTableViewCell = _meansGroupTableViewCell;
@synthesize meansContentTextView = _meansContentTextView;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSLog(@"Setting the value of fields in this static table to that of the passed Means");
    self.meansTitleTextField.text = self.means.title;
    self.meansContentTextView.text = self.means.variable1;
    _meansGroupTableViewCell.textLabel.text = self.means.inGroup.name;
    self.meansGroupTableViewCell.textLabel.text = self.means.inGroup.name;
    //self.meansGroupTableViewCell.textLabel = means.inGroup.name;
    //cell.detailTextLabel.text = means.inGroup.name;
    [_meansTitleTextField addTarget:self action:@selector(meansTitleTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [super viewDidLoad];
    
    UITapGestureRecognizer *uitapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [uitapgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:uitapgr];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}

-(IBAction)dismissKeyboardDone:(id)sender {
    [self.view endEditing:TRUE];
    // do whatever you want with this text field
}

-(void)meansTitleTextFieldDidChange:(id)sender {
    NSString *stringTemp = _meansTitleTextField.text;
    stringTemp = [stringTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([stringTemp isEqualToString:@""]) {
        //if ([[sender text] length] == 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}


- (void)viewDidUnload
{
    //[self setMeansNameTextField:nil];
    [self setMeansTitleTextField:nil];
    //[self setMeansVariable1TextField:nil];
    [self setMeansContentTextView:nil];
    [self setMeansGroupTableViewCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)save:(id)sender
{
    
    NSLog(@"Telling the MeansDetailTableViewController Delegate that Save was tapped on the MeansDetailTableViewController");
    
    //[self.means setName:meansNameTextField.text];
    
    self.means.title = self.meansTitleTextField.text; // set title
    self.means.variable1 = self.meansContentTextView.text; // set variable1 description
    //self.means.variable1 = self.meansVariable1TextField.text; // set variable1 description
    //NSLog(@"--selectedGroup is %@", selectedGroup.name);
    if ([selectedGroup.name length]  == 0) {
        // If NO changes in Group then do nothing
    } else {
        [self.means setInGroup:self.selectedGroup]; // Else set Relationship!!!
    }
    //[self.means setInGroup:self.selectedGroup]; // Set Relationship!!!
    [self.managedObjectContext save:nil];  // write to database
    [self.delegate theSaveButtonOnTheMeansDetailTableViewControllerWasTapped:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  // !
{
    if ([segue.identifier isEqualToString:@"Means Group Segue"])
	{
        NSLog(@"Setting MeansDetailTableViewController as a delegate of MeansGroupTableViewController");
        MeansGroupTableViewController *meansGroupTableViewController = segue.destinationViewController;
        meansGroupTableViewController.delegate = self;
        meansGroupTableViewController.managedObjectContext = self.managedObjectContext;
        meansGroupTableViewController.dependantGroup = self.means.inGroup.name;
	}
    else {
        NSLog(@"Unidentified Segue Attempted!");
    }
}

- (void)groupWasSelectedOnMeansGroupTableViewController:(MeansGroupTableViewController *)controller
{
    self.meansGroupTableViewCell.textLabel.text = controller.selectedGroup.name;
    self.selectedGroup = controller.selectedGroup;
    NSLog(@"MeansGroupTableViewController reports that the %@ group was selected on the MeansGroupTableViewController", controller.selectedGroup.name);
    [controller.navigationController popViewControllerAnimated:YES];
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


@end
