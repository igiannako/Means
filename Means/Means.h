//
//  Means.h
//  Means
//
//  Created by Ilias Giannakopoulos on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "KKPasscodeLock.h"

@class Group;

@interface Means : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * variable1;
@property (nonatomic, retain) Group *inGroup;

@end
