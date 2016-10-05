//
//  Task+CoreDataProperties.h
//  TaskCoreData
//
//  Created by Dima Tixon on 24/09/16.
//  Copyright © 2016 kba. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface Task (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *task;
@property (nullable, nonatomic, retain) NSNumber *starred;
@property (nullable, nonatomic, retain) List *list;

@end

NS_ASSUME_NONNULL_END
