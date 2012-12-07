//
//  Group.h
//  Means
//
//  Created by Ilias Giannakopoulos on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "KKPasscodeLock.h"

@class Means;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *heldBy;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addHeldByObject:(Means *)value;
- (void)removeHeldByObject:(Means *)value;
- (void)addHeldBy:(NSSet *)values;
- (void)removeHeldBy:(NSSet *)values;

@end
