//
//  GroupsTableViewController.m
//  Means
//
//  Created by Ilias Giannakopoulos on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupsTableViewController.h"
#import "Group.h"
#import "KKPasscodeLock.h"

@implementation GroupsTableViewController
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize selectedGroup;

- (void)setupFetchedResultsController
{
    // 1 - Decide what Entity you want
    NSString *entityName = @"Group"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter it if you want
    //request.predicate = [NSPredicate predicateWithFormat:@"Group.name = Blah"];
    
    // 4 - Sort it if you want
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                     ascending:YES
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    // 5 - Fetch it
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self performFetch];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
    if ([[self.fetchedResultsController fetchedObjects] count] == 0) {
        NSLog(@"No results were fetched so nothing will be given to the table view");
        
        //self.tableView.hidden = YES; // Do some stuff to hide the table
        // Do some stuff to show a label that says no results
        
        UIImage *image = [UIImage imageNamed:@"AddGroupImage.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        [imageView setFrame:self.tableView.bounds];
        [self.tableView setBackgroundView:imageView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView setBackgroundColor:[UIColor clearColor]];
        
        // Add image view on top of table view
        //[self.tableView addSubview:imageView];
        
        // Set the background view of the table view
        //self.tableView.backgroundView = imageView;

    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Groups Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Group *group = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = group.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates]; // Avoid  NSInternalInconsistencyException
        
        // Delete the group object that was swiped
        Group *groupToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Deleting (%@)", groupToDelete.name);
        [self.managedObjectContext deleteObject:groupToDelete];
        [self.managedObjectContext save:nil];
        
        // Delete the (now empty) row on the table
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self performFetch];
        
        [self.tableView endUpdates];
        
        // 11111111
        [self setupFetchedResultsController];
        
        if ([[self.fetchedResultsController fetchedObjects] count] == 0) {
            NSLog(@"No results were fetched so nothing will be given to the table view");
            UIImage *image = [UIImage imageNamed:@"AddGroupImage.png"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            
            [imageView setFrame:self.tableView.bounds];
            [self.tableView setBackgroundView:imageView];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.tableView setBackgroundColor:[UIColor clearColor]];
        //iOS6} else {
        //    [self.tableView setBackgroundView:nil];
        //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        }
        // 11111111
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Add Group Segue"])
	{
        NSLog(@"Setting GroupsTVC as a delegate of AddGroupsTVC");
        
        AddGroupTableViewController *addGroupTableViewController = segue.destinationViewController;
        addGroupTableViewController.delegate = self;
        addGroupTableViewController.managedObjectContext = self.managedObjectContext;
	}
    else if ([segue.identifier isEqualToString:@"Group Detail Segue"])
    {
        NSLog(@"Setting GroupsTableViewController as a delegate of GroupDetailTableViewController");
        GroupDetailTableViewController *groupDetailTableViewController = segue.destinationViewController;
        groupDetailTableViewController.delegate = self;
        groupDetailTableViewController.managedObjectContext = self.managedObjectContext;
        
        // Store selected Role in selectedRole property
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.selectedGroup = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        NSLog(@"Passing selected group (%@) to GroupDetailTableViewController", self.selectedGroup.name);
        groupDetailTableViewController.group = self.selectedGroup;
    }
    else {
        NSLog(@"Unidentified Segue Attempted!");
    }
}

- (void)theSaveButtonOnTheAddGroupTableViewControllerWasTapped:(AddGroupTableViewController *)controller
{
    // do something here like refreshing the table or whatever
    
    // 11111111
    [self setupFetchedResultsController];
    
    if ([[self.fetchedResultsController fetchedObjects] count] == 0) {
        NSLog(@"No results were fetched so nothing will be given to the table view");
        UIImage *image = [UIImage imageNamed:@"AddGroupImage.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        [imageView setFrame:self.tableView.bounds];
        [self.tableView setBackgroundView:imageView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView setBackgroundColor:[UIColor clearColor]];
    } else {//iOS6
        //[self.tableView setBackgroundView:nil];
        UIImage *image = [UIImage imageNamed:@"UITableViewBackground.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self.tableView setBackgroundView:imageView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
    // 11111111
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
}

- (void)theSaveButtonOnTheGroupDetailTableViewControllerWasTapped:(GroupDetailTableViewController *)controller
{
    // do something here like refreshing the table or whatever
    
    // 11111111
    [self setupFetchedResultsController];
    
    if ([[self.fetchedResultsController fetchedObjects] count] == 0) {
        NSLog(@"No results were fetched so nothing will be given to the table view");
        UIImage *image = [UIImage imageNamed:@"AddGroupImage.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        [imageView setFrame:self.tableView.bounds];
        [self.tableView setBackgroundView:imageView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView setBackgroundColor:[UIColor clearColor]];
    } else { //iOS6
    //    [self.tableView setBackgroundView:nil];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
    // 11111111
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //return YES;
}

@end
