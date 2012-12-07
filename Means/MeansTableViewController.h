//
//  MeansTableVewController.h
//  Means
//
//  Created by Ilias Giannakopoulos on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddMeansTableViewController.h" // so this class can be a AddMeansTableViewControllerDelegate
#import "MeansDetailTableViewController.h" // so this class can be an MeansDetailTableViewControllerDelegate
#import "CoreDataTableViewController.h"
#import "Means.h"
#import "KKPasscodeLock.h"

@interface MeansTableViewController : CoreDataTableViewController <AddMeansTableViewControllerDelegate, MeansDetailTableViewControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Means *selectedMeans;

@end