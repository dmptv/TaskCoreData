//
//  KBACoreDataUtils.h
//  TaskCoreData
//
//  Created by Dima Tixon on 26/09/16.
//  Copyright © 2016 kba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface KBACoreDataUtils : NSObject

+ (NSManagedObjectContext*) managedObjectContext;
+ (void) saveContext;

@end
