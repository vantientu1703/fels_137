//
//  CategoriesTableViewCell.h
//  Elearning
//
//  Created by Văn Tiến Tú on 5/23/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoriesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewCategory;
@property (weak, nonatomic) IBOutlet UILabel *labelNameCategory;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalLearnedWord;

@end
