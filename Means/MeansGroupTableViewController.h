//
//  MeansGroupTableViewController.h
//  Means
//
//  Created by Ilias Giannakopoulos on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
#import "CoreDataTableViewController.h" // so we can fetch
#import "KKPasscodeLock.h"

@class MeansGroupTableViewController;
@protocol MeansGroupTableViewControllerDelegate
- (void)groupWasSelectedOnMeansGroupTableViewController:(MeansGroupTableViewController *)controller;
@end

@interface MeansGroupTableViewController : CoreDataTableViewController
@property (nonatomic, weak) id  delegate;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Group *selectedGroup;

@property (nonatomic,strong) NSString *dependantGroup;

@end
