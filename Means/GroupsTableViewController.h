//
//  GroupsTableViewController.h
//  Means
//
//  Created by Ilias Giannakopoulos on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddGroupTableViewController.h" // so this class can be a AddGroupTableViewControllerDelegate
#import "GroupDetailTableViewController.h" // so this class can be an GroupDetailTableViewControllerDelegate
#import "CoreDataTableViewController.h"
#import "Group.h"
#import "KKPasscodeLock.h"

@interface GroupsTableViewController : CoreDataTableViewController <AddGroupTableViewControllerDelegate, GroupDetailTableViewControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Group *selectedGroup;

@end
