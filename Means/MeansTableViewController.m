//
//  MeansTableViewController.m
//  Means
//
//  Created by Ilias Giannakopoulos on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MeansTableViewController.h"
#import "Means.h"
#import "KKPasscodeLock.h"

@implementation MeansTableViewController
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize selectedMeans;

- (void)setupFetchedResultsController
{
    // 1 - Decide what Entity you want
    NSString *entityName = @"Means"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter it if you want
    //request.predicate = [NSPredicate predicateWithFormat:@"Means.name = Blah"];
    
    // 4 - Sort it if you want
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title"
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
        
        UIImage *image;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
            image = [UIImage imageNamed:@"AddMeansImage-568h@2x.png"];
        } else {
            image = [UIImage imageNamed:@"AddMeansImage.png"];
        }
        
        //UIImage *image = [UIImage imageNamed:@"AddMeansImage.png"];
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
    static NSString *CellIdentifier = @"Means Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Means *means = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *fullmeans = [NSString stringWithFormat:@"%@", means.title];
    //NSString *fullmeans = [NSString stringWithFormat:@"%@ %@", means.title, means.variable1];
    cell.textLabel.text = fullmeans;
    cell.detailTextLabel.text = means.inGroup.name;
    //cell.textLabel.text = means.inGroup.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates]; // Avoid  NSInternalInconsistencyException
        
        // Delete the means object that was swiped
        Means *meansToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"Deleting (%@)", meansToDelete.title);
        [self.managedObjectContext deleteObject:meansToDelete];
        [self.managedObjectContext save:nil];
        
        // Delete the (now empty) row on the table
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self performFetch];
        [self.tableView endUpdates];
        
        // 11111111
        [self setupFetchedResultsController];
        
        if ([[self.fetchedResultsController fetchedObjects] count] == 0) {
            NSLog(@"No results were fetched so nothing will be given to the table view");
            
            UIImage *image;
            CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
            if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
                image = [UIImage imageNamed:@"AddMeansImage-568h@2x.png"];
            } else {
                image = [UIImage imageNamed:@"AddMeansImage.png"];
            }
            
            //UIImage *image = [UIImage imageNamed:@"AddMeansImage.png"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            
            [imageView setFrame:self.tableView.bounds];
            [self.tableView setBackgroundView:imageView];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.tableView setBackgroundColor:[UIColor clearColor]];
        } else {
            [self.tableView setBackgroundView:nil];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [self.tableView setBackgroundColor:[UIColor whiteColor]];
        }
        // 11111111
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Add Means Segue"])
	{
        NSLog(@"Setting MeansTVC as a delegate of AddMeansTVC");
        
        AddMeansTableViewController *addMeansTableViewController = segue.destinationViewController;
        addMeansTableViewController.delegate = self;
        addMeansTableViewController.managedObjectContext = self.managedObjectContext;
	}
    else if ([segue.identifier isEqualToString:@"Means Detail Segue"])
    {
        NSLog(@"Setting MeansTableViewController as a delegate of MeansDetailTableViewController");
        MeansDetailTableViewController *meansDetailTableViewController = segue.destinationViewController;
        meansDetailTableViewController.delegate = self;
        meansDetailTableViewController.managedObjectContext = self.managedObjectContext;
        
        // Store selected Role in selectedRole property
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.selectedMeans = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        NSLog(@"Passing selected means (%@) to MeansDetailTableViewController", self.selectedMeans.title);
        meansDetailTableViewController.means = self.selectedMeans;
    }
    else {
        NSLog(@"Unidentified Segue Attempted!");
    }
}

- (void)theSaveButtonOnTheAddMeansTableViewControllerWasTapped:(AddMeansTableViewController *)controller
{
    // do something here like refreshing the table or whatever
    // 11111111
    [self setupFetchedResultsController];
    
    if ([[self.fetchedResultsController fetchedObjects] count] == 0) {
        NSLog(@"No results were fetched so nothing will be given to the table view");
        
        UIImage *image;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
            image = [UIImage imageNamed:@"AddMeansImage-568h@2x.png"];
        } else {
            image = [UIImage imageNamed:@"AddMeansImage.png"];
        }
        
        //UIImage *image = [UIImage imageNamed:@"AddMeansImage.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        [imageView setFrame:self.tableView.bounds];
        [self.tableView setBackgroundView:imageView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView setBackgroundColor:[UIColor clearColor]];
    } else {
        [self.tableView setBackgroundView:nil];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
    }
    // 11111111
    
    // close the delegated view
    [controller.navigationController popViewControllerAnimated:YES];
}

- (void)theSaveButtonOnTheMeansDetailTableViewControllerWasTapped:(MeansDetailTableViewController *)controller
{
    // do something here like refreshing the table or whatever
    // 11111111
    [self setupFetchedResultsController];
    
    if ([[self.fetchedResultsController fetchedObjects] count] == 0) {
        NSLog(@"No results were fetched so nothing will be given to the table view");
        
        UIImage *image;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
            image = [UIImage imageNamed:@"AddMeansImage-568h@2x.png"];
        } else {
            image = [UIImage imageNamed:@"AddMeansImage.png"];
        }
        
        //UIImage *image = [UIImage imageNamed:@"AddMeansImage.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        [imageView setFrame:self.tableView.bounds];
        [self.tableView setBackgroundView:imageView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView setBackgroundColor:[UIColor clearColor]];
    } else {
        [self.tableView setBackgroundView:nil];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
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