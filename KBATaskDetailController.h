//
//  KBATaskDetailController.h
//  TaskCoreData
//
//  Created by Dima Tixon on 25/09/16.
//  Copyright © 2016 kba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class List;
@class Task;

@interface KBATaskDetailController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) List* list; // нам нужен List чтобы мы знали who parent is
@property (strong, nonatomic) Task* task;
@property (weak, nonatomic) IBOutlet UIButton *starButton;
@property (weak, nonatomic) IBOutlet UITextField *taskTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteBarButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction) pressedCancel:(id) sender;
- (IBAction) pressedStar:(id) sender;
- (IBAction) pressedDelete:(id) sender;
- (IBAction) pressedSave:(id) sender;

@end
