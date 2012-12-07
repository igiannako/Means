//
//  MeansDetailTableViewController.h
//  Means
//
//  Created by Ilias Giannakopoulos on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Means.h"
#import "Group.h"
#import "MeansGroupTableViewController.h"
#import "KKPasscodeLock.h"

@class MeansDetailTableViewController;
@protocol MeansDetailTableViewControllerDelegate
- (void)theSaveButtonOnTheMeansDetailTableViewControllerWasTapped:(MeansDetailTableViewController *)controller;
@end

@interface MeansDetailTableViewController : UITableViewController <MeansGroupTableViewControllerDelegate>
@property (nonatomic, weak) id <MeansDetailTableViewControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Means *means;
@property (strong, nonatomic) Group *selectedGroup;
@property (strong, nonatomic) IBOutlet UITextField *meansTitleTextField;
@property (strong, nonatomic) IBOutlet UITableViewCell *meansGroupTableViewCell;
@property (strong, nonatomic) IBOutlet UITextView *meansContentTextView;

- (IBAction)save:(id)sender;

@end
