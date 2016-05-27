//
//  CategoryItem.h
//  Elearning
//
//  Created by Văn Tiến Tú on 5/22/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryItem : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) int learnedWords;

@end
