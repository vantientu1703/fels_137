//
//  LoadingView.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/27/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView
{
    UIView *view;
    UIActivityIndicatorView *spinner;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        [self setupView];
    }
    return self;
}

- (void) setupView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    CGSize sizeMainScreen = self.bounds.size;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.center = CGPointMake(sizeMainScreen.width / 2, sizeMainScreen.height / 2 - 40);
    label.text = @"Loading...";
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [spinner setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.height/2.0)];
    [self addSubview:spinner];
    
    [spinner startAnimating];
}

@end
