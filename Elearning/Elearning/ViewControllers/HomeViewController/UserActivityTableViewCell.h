//
//  UserActivityTableViewCell.h
//  Elearning
//
//  Created by Nguyen Van Thieu B on 5/29/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *activityContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityCreatedDate;
@end
