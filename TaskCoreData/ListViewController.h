//
//  MasterViewController.h
//  TaskCoreData
//
//  Created by Dima Tixon on 24/09/16.
//  Copyright © 2016 kba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface ListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
// @property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
                                    // будем брать из KBACoreDataUtils

- (IBAction) pressedOptionmenu:(id)sender;

@end

