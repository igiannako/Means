//
//  SettingsTableViewController.h
//  Means
//
//  Created by Ilias Giannakopoulos on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "KKPasscodeLock.h"

@interface SettingsTableViewController : UITableViewController <MFMailComposeViewControllerDelegate> {
    
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
