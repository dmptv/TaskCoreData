//
//  KBATaskCell.h
//  TaskCoreData
//
//  Created by Dima Tixon on 25/09/16.
//  Copyright © 2016 kba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Task;

@interface KBATaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *starButton;
@property (weak, nonatomic) IBOutlet UILabel *taskLabel;

- (IBAction) pressedStarButton:(id) sender;
- (void) configureCellForTask:(Task*) task  withStarCallback:(void(^)()) starCallback;

@end
