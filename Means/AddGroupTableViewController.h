//
//  AddGroupTableViewController.h
//  Means
//
//  Created by Ilias Giannakopoulos on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
#import "KKPasscodeLock.h"

@class AddGroupTableViewController;
@protocol AddGroupTableViewControllerDelegate
- (void)theSaveButtonOnTheAddGroupTableViewControllerWasTapped:(AddGroupTableViewController *)controller;
@end

@interface AddGroupTableViewController : UITableViewController
@property (nonatomic, weak) id <AddGroupTableViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *groupNameTextField;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)save:(id)sender;

@end
