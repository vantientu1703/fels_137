//
//  CategoryManager.h
//  Elearning
//
//  Created by Văn Tiến Tú on 5/26/16.
//  Copyright © 2016 Framgia. All rights reserved.
//
#import <Foundation/Foundation.h>
@protocol CategoryManagerDelegate <NSObject>

- (void)didReceiveCategories:(NSMutableArray *)arrCategories
                     message:(NSString *)message
                   withError:(NSError *)error;
@end

@interface CategoryManager : NSObject

@property (weak, nonatomic) id<CategoryManagerDelegate> delegate;
- (void)getCategoryWithAuthToken:(NSString *)authToken
                            page:(NSInteger)page
                     perPageData:(NSInteger)perPageData;
@end
