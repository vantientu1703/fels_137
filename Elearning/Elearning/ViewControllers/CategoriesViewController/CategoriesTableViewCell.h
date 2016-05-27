//
//  CategoriesTableViewCell.h
//  Elearning
//
//  Created by Văn Tiến Tú on 5/23/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoriesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *totalLearnedWord;
@property (weak, nonatomic) IBOutlet UILabel *words;

@end
