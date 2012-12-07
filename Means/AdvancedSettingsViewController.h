//
//  AdvancedSettingsViewController.h
//  Means
//
//  Created by Ilias Giannakopoulos on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
#import <UIKit/UIKit.h>

@interface AdvancedSettingsViewController : UIViewController

@end
*/

#import <UIKit/UIKit.h>
#import "KKPasscodeSettingsViewController.h"
#import "KKPasscodeLock.h"

@interface AdvancedSettingsViewController : UITableViewController <KKPasscodeSettingsViewControllerDelegate>

@end