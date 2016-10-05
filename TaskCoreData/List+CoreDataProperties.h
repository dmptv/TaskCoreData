//
//  List+CoreDataProperties.h
//  TaskCoreData
//
//  Created by Dima Tixon on 24/09/16.
//  Copyright © 2016 kba. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "List.h"

NS_ASSUME_NONNULL_BEGIN

@interface List (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *tasks;

@end

@interface List (CoreDataGeneratedAccessors)

- (void)addTasksObject:(NSManagedObject *)value;
- (void)removeTasksObject:(NSManagedObject *)value;
- (void)addTasks:(NSSet<NSManagedObject *> *)values;
- (void)removeTasks:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
