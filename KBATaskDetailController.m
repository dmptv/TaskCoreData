//
//  KBATaskDetailController.m
//  TaskCoreData
//
//  Created by Dima Tixon on 25/09/16.
//  Copyright © 2016 kba. All rights reserved.
//

#import "KBATaskDetailController.h"
#import "List.h"
#import "Task.h"
#import "KBACoreDataUtils.h"

@interface KBATaskDetailController ()
@property (assign, nonatomic) BOOL starred;
@end

@implementation KBATaskDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.view endEditing:YES];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self.view
                                                                              action:@selector(endEditing:)];
                   // endEditing - self.view убирает текстфилды с firstResponder
        [self.view addGestureRecognizer:tap];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (self.task != nil) {
                      // устанавливаем наши UI элементы в зависмости от значения пришедшего task
        self.taskTextField.text = self.task.task;     // заполнили текстфилд
        self.starred = [self.task.starred boolValue]; // передадим текущее соостояние starred для установки нужного image на button
    } else {
                    // спрячем delete button из toolbar если  нету task
        NSMutableArray* toolBarButtons = [self.toolbar.items mutableCopy]; // массив toolbar.items просто NSArray
        [toolBarButtons removeObject:self.deleteBarButton];
        self.toolbar.items = toolBarButtons;
    }
    [self _updateStar]; // установим image у звезды в завсимости от self.starred
    [self.taskTextField becomeFirstResponder]; // для удобства пользователся вью появляется с активной клавой
    
                    // поставим кнопку чтобы убирать клавиатуру
        UIBarButtonItem* hide = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self.view
                                                                action:@selector(endEditing:)];
        UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
        UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0)];
        toolBar.items = @[flexSpace, hide];
        self.taskTextField.inputAccessoryView = toolBar;
}

#pragma mark - Actions
- (IBAction) pressedCancel:(id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) pressedStar:(id)sender {
    self.starred = !self.starred;
    [self _updateStar]; // переключим image
}

- (void) _updateStar {
    if (self.starred) {
        [self.starButton setImage:[UIImage imageNamed:@"Star.png"] forState:UIControlStateNormal];
    } else {
        [self.starButton setImage:[UIImage imageNamed:@"Star2.png"] forState:UIControlStateNormal];
    }
}

- (IBAction) pressedDelete:(id)sender {
    [[KBACoreDataUtils managedObjectContext] deleteObject:self.task];
    [KBACoreDataUtils saveContext];
    [self dismissViewControllerAnimated:YES completion:nil]; // сохраняем и сразу же дисмис контролер
}

- (IBAction) pressedSave:(id)sender {
    if (self.task == nil) {
        self.task = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                                  inManagedObjectContext:[KBACoreDataUtils managedObjectContext]];
    }
    self.task.list = self.list;
       // укажем subclass List он принадлежит. иначе он даже не появится.чтобы Кор Дата знала кому принадлежит созданный таск
    self.task.task = self.taskTextField.text;
    self.task.starred = @(self.starred) ; //[NSNumber numberWithBool:self.starred];
    [KBACoreDataUtils saveContext];
    [self dismissViewControllerAnimated:YES completion:nil]; // сохраняем и сразу же дисмис контролер
}

#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}














@end





















