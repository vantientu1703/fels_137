//
//  CategoryItem.h
//  Elearning
//
//  Created by Văn Tiến Tú on 5/22/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryItem : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *url;
@property (nonatomic) NSInteger totalLearnedWords;

@end
