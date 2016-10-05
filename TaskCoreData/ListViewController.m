//
//  MasterViewController.m
//  TaskCoreData
//
//  Created by Dima Tixon on 24/09/16.
//  Copyright © 2016 kba. All rights reserved.
//

#import "ListViewController.h"
#import "List.h"
#import "TasksViewController.h"
#import "KBACoreDataUtils.h"

#define kShowTasksSegue @"ShowTasksSegue"
#define kListCell @"ListCell"

@interface ListViewController ()

@property(nonatomic) BOOL showRenameButtons;

@end

@implementation ListViewController

- (void) viewDidAppear:(BOOL) animated {
//    List* list1 = [NSEntityDescription insertNewObjectForEntityForName:@"List"
//                                                inManagedObjectContext:[KBACoreDataUtils managedObjectContext]];
//    list1.title = @"CSSE484 iOS Dev";
//    List* list2 = [NSEntityDescription insertNewObjectForEntityForName:@"List"
//                                                inManagedObjectContext:[KBACoreDataUtils managedObjectContext]];
//    list2.title = @"CSSE484 Android Dev";
//    List* list3 = [NSEntityDescription insertNewObjectForEntityForName:@"List"
//                                                inManagedObjectContext:[KBACoreDataUtils managedObjectContext]];
//    list3.title = @"CSSE484 Web App Frameworks Dev";
//    [KBACoreDataUtils saveContext];
}

#pragma mark - Actions
- (IBAction) pressedOptionmenu:(id)sender {
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:nil
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
                // - create a list
    UIAlertAction* createList = [UIAlertAction actionWithTitle:@"Create a List"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self _showDialogForList:nil];
                                                       }];
    [ac addAction:createList];
                // - delete a list (toggle the editing mode)
    UIAlertAction* editingMode = [UIAlertAction
                                  actionWithTitle:self.editing ? @"Done editing" : @"Delete a List"
                                        // в зависимости от состояния editing у tableVC будем показывать Title
                                  style:self.editing ? UIAlertActionStyleDefault : UIAlertActionStyleDestructive
                                        // в зависимости от состояния editing будем показывать Title красным или обычным стилем
                                  handler:^(UIAlertAction * _Nonnull action) {
                                      [self setEditing:!self.editing animated:YES];
                                             //  по тапу будем переключать значение editing
                                  }];
    [ac addAction:editingMode];
                // - toggle the show rename buttons
    UIAlertAction* renameAaction = [UIAlertAction actionWithTitle:self.showRenameButtons ? @"Hide rename bittons" : @"Show rename buttons"
                                                         // здесь нам пришлось самим сделать Bool проперти чтобы изменять его
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              self.showRenameButtons = !self.showRenameButtons;
                                                                  //  по тапу будем переключать значение нашей проперти BOOL showRenameButtons
                                                              [self.tableView reloadData];
                                                              // если мы переключаемся на то что должно показаться на таблвью , то мы должны перегрузить таблвью
                                                              // и тогда вызовется метод cellForRow и по значению showRenameButtons будет показывать соответствующий accessoryType
                                                          }];
    [ac addAction:renameAaction];
               // - cancel
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [ac addAction:cancelAction];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void) _showDialogForList:(List*)listToEdit {
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:listToEdit == nil ? @"Create a new list" : @"Rename the list"
                                                                message:listToEdit.title
                                                             // если list существует , у него есть title, если нет то ничего не покажется
                                                         preferredStyle:UIAlertControllerStyleAlert];
                  // add text field
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Name for this list";
    }];
                 // add a cancel button
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [ac addAction:cancelAction];
                 // add OK button
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                   UITextField* textField = ac.textFields.firstObject;
                                   if (listToEdit == nil) {
                                       List* newList = [NSEntityDescription insertNewObjectForEntityForName:@"List"
                                                                                     inManagedObjectContext:[KBACoreDataUtils managedObjectContext]];
                                       newList.title = textField.text;
                                   } else {
                                       listToEdit.title = textField.text;
                                       self.showRenameButtons = NO;
                                            // поменяем значение на NO, чтобы убрать показ RenameButtonы для cell.accessoryType
                                       [self.tableView reloadData];
                                   }
                                   [KBACoreDataUtils saveContext];
                               }];
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - Segues
- (void) prepareForSegue:(UIStoryboardSegue *)segue  sender:(id)sender {
        if ([[segue identifier] isEqualToString:kShowTasksSegue]) {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];            // pick up row that bieng called
            List *listForRow = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            [(TasksViewController*)[segue destinationViewController] setList:listForRow];
        }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kListCell forIndexPath:indexPath];
    [self _configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView  commitEditingStyle:(UITableViewCellEditingStyle) editingStyle
                                             forRowAtIndexPath:(NSIndexPath *) indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    [self setEditing:NO animated:YES]; // чтобы после удаления одного листа переключался в обычный вид. без красных надписей - delete
}

- (void)_configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    List* listForRow = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = listForRow.title ;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", (int)listForRow.tasks.count];
    cell.accessoryType = (self.showRenameButtons ? UITableViewCellAccessoryDetailDisclosureButton :
                                                   UITableViewCellAccessoryDisclosureIndicator);
}

#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self _showDialogForList:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    // нажимаем аксесориБаттон и вызываем алертконтроль для ринэайм
}

#pragma mark - NSFetchedResultsControllerDelegate
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"List"
                                              inManagedObjectContext:[KBACoreDataUtils managedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:[KBACoreDataUtils managedObjectContext]
                                                             sectionNameKeyPath:nil cacheName:@"List"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
                                                                     atIndex:(NSUInteger)sectionIndex
                                                               forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
                                                                atIndexPath:(NSIndexPath *)indexPath
                                                              forChangeType:(NSFetchedResultsChangeType)type
                                                               newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
             [self _configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}
























@end
