//
//  AppDelegate.m
//  Means
//
//  Created by Ilias Giannakopoulos on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "GroupsTableViewController.h"
#import "MeansTableViewController.h"
#import "SettingsTableViewController.h"
#import "KKPasscodeLock.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize fetchedResultsController = __fetchedResultsController;

- (void)insertGroupWithGroupName:(NSString *)groupName
{
    Group *group = [NSEntityDescription insertNewObjectForEntityForName:@"Group"
                                               inManagedObjectContext:self.managedObjectContext];
    
    group.name = groupName;
    
    [self.managedObjectContext save:nil];
}

- (void)importCoreDataDefaultRoles {
    
    NSLog(@"Importing Core Data Default Values for Roles...");
    [self insertGroupWithGroupName:@"Private"];
    NSLog(@"Importing Core Data Default Values for Roles Completed!");
}

- (void)setupFetchedResultsController
{
    // 1 - Decide what Entity you want
    NSString *entityName = @"Group"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter it if you want
    //request.predicate = [NSPredicate predicateWithFormat:@"Person.name = Blah"];
    
    // 4 - Sort it if you want
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                     ascending:YES
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    // 5 - Fetch it
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self.fetchedResultsController performFetch:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // at the top of the appdelegate
    [self setupFetchedResultsController];
    
    if (![[self.fetchedResultsController fetchedObjects] count] > 0 ) {
        NSLog(@"!!!!! ~~> There's nothing in the database so defaults will be inserted");
        [self importCoreDataDefaultRoles];
    }
    else {
        NSLog(@"There's stuff in the database so skipping the import of default data");
    }
    
    //KKP
    [[KKPasscodeLock sharedLock] setDefaultSettings];

    
    // The Tab Bar
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
    //[[UITabBar appearance] setTintColor:[UIColor blackColor]];
    
    // The Two Navigation Controllers attached to the Tab Bar (At Tab Bar Indexes 0 and 1)
    UINavigationController *meansTableViewControllernav = [[tabBarController viewControllers] objectAtIndex:0];
    UINavigationController *groupsTableViewControllernav = [[tabBarController viewControllers] objectAtIndex:1];
    UINavigationController *settingsTableViewControllernav = [[tabBarController viewControllers] objectAtIndex:2];
    
    // The Means Table View Controller (First Nav Controller Index 0)
    MeansDetailTableViewController *meansTableViewController = [[meansTableViewControllernav viewControllers] objectAtIndex:0];
    meansTableViewController.managedObjectContext = self.managedObjectContext;    
    
    // The Groups Table View Controller (Second Nav Controller Index 0)
    GroupsTableViewController *groupsTableViewController = [[groupsTableViewControllernav viewControllers] objectAtIndex:0];
    groupsTableViewController.managedObjectContext = self.managedObjectContext;
    
    // The Settings Table View Controller (Second Nav Controller Index 0)
    SettingsTableViewController *settingsTableViewController = [[settingsTableViewControllernav viewControllers] objectAtIndex:0];
    settingsTableViewController.managedObjectContext = self.managedObjectContext;
    
    
    //NOTE: Be very careful to change these indexes if you change the tab order
    
    //[[[self.tabBarController.tabBar subviews] objectAtIndex:01 setHidden:YES];
    
    // The following stuff was commented out since we're using a Tab Bar Controller
    //UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    //RolesTVC *controller = (RolesTVC *)navigationController.topViewController;
    //controller.managedObjectContext = self.managedObjectContext;
    
    //[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
    
    //UIImage *navBackgroundImage = [UIImage imageNamed:@"NBBackground"];
    //[[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //
    
    //backbutton: 22x30 , 44x60@2x
    /*
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -20.f) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage   imageNamed:@"back_button.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"normal_button.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //
    */
    return YES; // Override point for customization after application launch.
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    //KKP
    if ([[KKPasscodeLock sharedLock] isPasscodeRequired]) {
        KKPasscodeViewController *vc = [[KKPasscodeViewController alloc] initWithNibName:nil bundle:nil];
        vc.mode = KKPasscodeModeEnter;
        vc.delegate = self;
        
        dispatch_async(dispatch_get_main_queue(),^ {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                nav.modalPresentationStyle = UIModalPresentationFormSheet;
                nav.navigationBar.barStyle = UIBarStyleBlack;
                nav.navigationBar.opaque = NO;
            } else {
                //nav.navigationBar.tintColor = self.window.rootViewController.navigationItem.navigationBar.tintColor;
                //nav.navigationBar.translucent = _navigationController.navigationBar.translucent;
                //nav.navigationBar.opaque = _navigationController.navigationBar.opaque;
                //nav.navigationBar.barStyle = _navigationController.navigationBar.barStyle;    
            }
            
            [self.window.rootViewController presentModalViewController:nav animated:YES];
        });
        
    }
    
}

- (void)shouldEraseApplicationData:(KKPasscodeViewController*)viewController 
{
    
    NSArray *stores = [__persistentStoreCoordinator persistentStores];
    
    for(NSPersistentStore *store in stores) {
        [__persistentStoreCoordinator removePersistentStore:store error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You have entered an incorrect passcode too many times. All account data in this app has been deleted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)didPasscodeEnteredIncorrectly:(KKPasscodeViewController*)viewController 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You have entered an incorrect passcode too many times." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Means.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
