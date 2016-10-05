//
//  TasksViewController.h
//  TaskCoreData
//
//  Created by Dima Tixon on 24/09/16.
//  Copyright © 2016 kba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class List;

@interface TasksViewController : UITableViewController

@property (strong, nonatomic) List* list;
- (IBAction) pressedAddTask:(id) sender;

@end
