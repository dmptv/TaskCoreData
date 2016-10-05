//
//  KBACoreDataUtils.m
//  TaskCoreData
//
//  Created by Dima Tixon on 26/09/16.
//  Copyright © 2016 kba. All rights reserved.
//

#import "KBACoreDataUtils.h"
#import "AppDelegate.h"

static NSManagedObjectContext* __managedObjectContext; // class variables

@implementation KBACoreDataUtils

+ (NSManagedObjectContext*) managedObjectContext {
    if (__managedObjectContext == nil) {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        __managedObjectContext = appDelegate.managedObjectContext;
    }
    return __managedObjectContext;
}

+ (void) saveContext {
    NSManagedObjectContext *context = [KBACoreDataUtils managedObjectContext];
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

@end
