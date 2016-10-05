//
//  TasksViewController.m
//  TaskCoreData
//
//  Created by Dima Tixon on 24/09/16.
//  Copyright © 2016 kba. All rights reserved.
//

#import "TasksViewController.h"
#import "List.h"
#import "Task.h"
#import "AppDelegate.h"
#import "KBATaskCell.h"
#import "KBACoreDataUtils.h"
#import "KBATaskDetailController.h"

#define kShowTaskDetailSegue @"ShowTaskDetailSegue"
#define kTaskCell @"TaskCell"

@interface TasksViewController ()

@property (strong, nonatomic) NSArray* tasks;

@end

@implementation TasksViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationItem.title = self.list.title;
    self.tasks = nil;      // обнуляем чтобы заполнить ,когда будем возвращаться сюда с TaskDetailControllerа, cellForRowAtIndexPath тасками из массива
    [self.tableView reloadData];
}

                        // это lazy programming concept that we use a lot
- (NSArray*) tasks {         // если кто нибудь запросит tasks, если его нет то мы его сделаем и отсортируем
    if (_tasks == nil) {
        _tasks = [self.list.tasks.allObjects sortedArrayUsingComparator:^NSComparisonResult(Task* task1, Task* task2) {
            
            if ([task1.starred boolValue] && ![task2.starred boolValue]) {
                return NSOrderedAscending;
            } else if (![task1.starred boolValue] && [task2.starred boolValue]) {
                return NSOrderedDescending;
            } else {
                [task1.task compare:task2.task options:NSCaseInsensitiveSearch];
                return NSOrderedAscending;
            }
            
        }];
    }
    return _tasks;
}

#pragma mark - Actions
- (IBAction) pressedAddTask:(id) sender {
    [self performSegueWithIdentifier:kShowTaskDetailSegue sender:nil];  // хотя Segue поставлен с контролла, но вывзываем с любого Action
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
    /*
    Task* taskForRow = self.tasks[indexPath.row];
    cell.textLabel.text = taskForRow.task;
    if ([taskForRow.starred boolValue]) {
        cell.detailTextLabel.text = @"Starred";
    } else {
        cell.detailTextLabel.text = nil;
    }*/
    KBATaskCell *taskCell = [tableView dequeueReusableCellWithIdentifier:kTaskCell forIndexPath:indexPath];
    Task* taskForRow = self.tasks[indexPath.row];
    [taskCell configureCellForTask:taskForRow withStarCallback:^{        // вызовем блок при нажатии звезды
             // переключили starred
        taskForRow.starred = [NSNumber numberWithBool:![taskForRow.starred boolValue]];
        [KBACoreDataUtils saveContext];
            // resort the list , чтобы starred были наверху списка поставим self.tasks = nil,
        self.tasks = nil; // теперь надо опять взять массив из сет и заполнить таблицу, тк таблица заполняется элементами из массива , она ничего не знает о сет (relationship)
        [tableView reloadData];
    }];
    return taskCell;
}

#pragma mark - UITableViewDelegate

- (BOOL) tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *) indexPath {
    return YES;
}

- (void) tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle
 forRowAtIndexPath:(NSIndexPath *) indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
                 // сперва удаляем таск из Кор Даты
        Task* taskForRow = self.tasks[indexPath.row];
        [[KBACoreDataUtils managedObjectContext] deleteObject:taskForRow];
        [KBACoreDataUtils saveContext];
        self.tasks = nil; // it forces to refresh. it causes to fill array with elements from set
                 // теперь удаляем Таск из Таблицы
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void) tableView:(UITableView *) tableView  didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
    Task* taskForRow = self.tasks[indexPath.row];
    [self performSegueWithIdentifier:kShowTaskDetailSegue sender:taskForRow];
          // в -prepareForSegue мы указали что tdc.task = sender, воспользуемся sender , чиобы передать  taskForRow
}

#pragma mark - Navigation
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kShowTaskDetailSegue]) {
        KBATaskDetailController* tdc = segue.destinationViewController;      // получили доступ к другому контролеру
        tdc.list = self.list;
        tdc.task = sender;      // если нажмем row, то task будет sender, мы его передадим в методе -performSegueWithIdentifier
        
    }
    
}













@end
