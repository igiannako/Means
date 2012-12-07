//
//  AddMeansTableViewController.h
//  Means
//
//  Created by Ilias Giannakopoulos on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Means.h"
#import "KKPasscodeLock.h"

@class AddMeansTableViewController;
@protocol AddMeansTableViewControllerDelegate <NSObject>
- (void)theSaveButtonOnTheAddMeansTableViewControllerWasTapped:(AddMeansTableViewController *)controller;
@end

@interface AddMeansTableViewController : UITableViewController
@property (nonatomic, weak) id <AddMeansTableViewControllerDelegate> delegate;
//@property (strong, nonatomic) IBOutlet UITextField *meansNameTextField;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITextField *meansTitleTextField;
@property (strong, nonatomic) IBOutlet UITextView *meansContentTextView;


- (IBAction)save:(id)sender;

@end
