//
//  GroupDetailTableViewController.h
//  Means
//
//  Created by Ilias Giannakopoulos on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
#import "KKPasscodeLock.h"

@class GroupDetailTableViewController;
@protocol GroupDetailTableViewControllerDelegate
- (void)theSaveButtonOnTheGroupDetailTableViewControllerWasTapped:(GroupDetailTableViewController *)controller;
@end

@interface GroupDetailTableViewController : UITableViewController
@property (nonatomic, weak) id <GroupDetailTableViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *groupNameTextField;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Group *group;

- (IBAction)save:(id)sender;

@end
