//
//  KBATaskCell.m
//  TaskCoreData
//
//  Created by Dima Tixon on 25/09/16.
//  Copyright © 2016 kba. All rights reserved.
//

#import "KBATaskCell.h"
#import "Task.h"

@interface KBATaskCell ()
@property (strong, nonatomic) void(^starCallback)();
@end

@implementation KBATaskCell

- (void) configureCellForTask:(Task*)task withStarCallback:(void(^)())starCallback {
    self.taskLabel.text = task.task;  // task это тот который по индекс пассу пришел из массива таскс
    self.starCallback = starCallback;   // так блок узнает реализован ли он
    if ([task.starred boolValue]) {   // в звисимости от статуса starred будем менять image
        [self.starButton setImage:[UIImage imageNamed:@"Star.png"] forState:UIControlStateNormal];
    } else {
        [self.starButton setImage:[UIImage imageNamed:@"Star2.png"] forState:UIControlStateNormal];
    }
}

- (IBAction) pressedStarButton:(id) sender {
    if (self.starCallback != nil) {
        // проверяет релизован ли блок. он послал сообщение и получил ответное сообщение Callback , что блок реализован и вызвал его
        self.starCallback();
    }
    // change the status of the starred attribute on this task
    // resort the list based on this update
    
}
@end
