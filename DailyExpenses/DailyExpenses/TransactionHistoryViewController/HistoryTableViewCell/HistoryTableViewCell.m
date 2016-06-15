//
//  HistoryTableViewCell.m
//  DailyExpenses
//
//  Created by Pradeep on 15/06/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.mainView.layer.cornerRadius = 2.0f;
    self.mainView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.mainView.layer.borderWidth = 1.0f;
    self.mainView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
