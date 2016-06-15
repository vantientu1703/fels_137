//
//  HomeViewController.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/20/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "HomeViewController.h"
#import "User.h"
#import "StoreData.h"
#import "UserActivityTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Constants.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSArray *userActivityArray;
@property (weak, nonatomic) IBOutlet UITableView *userActivityTableView;
@property (weak, nonatomic) IBOutlet UILabel *txtName;
@property (weak, nonatomic) IBOutlet UILabel *txtEmail;
@property (weak, nonatomic) IBOutlet UILabel *txtLearned;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
- (IBAction)btnWords:(id)sender;
- (IBAction)btnLesson:(id)sender;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Profile";
}

- (void)viewWillAppear:(BOOL)animated {
    User *user = [StoreData getUser];
    self.txtName.text = user.name;
    self.txtEmail.text = user.email;
    self.txtLearned.text = [NSString stringWithFormat:LEARNED_WORD_FORMAT, user.learnedWords];
    self.userActivityArray = user.activities;
    NSURL *url = [NSURL URLWithString:user.avatar];
    [self.imgAvatar sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"place.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            self.imgAvatar.image = [UIImage imageNamed:@"noavatar.png"];
        }
    }];
}

- (IBAction)btnWords:(id)sender {
    [self goWords];
}

- (IBAction)btnLesson:(id)sender {
    [self goLesson];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userActivityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"Cell";
    UserActivityTableViewCell *cell = (UserActivityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSDictionary *activity = self.userActivityArray[indexPath.row];
    cell.activityContentLabel.text = [activity valueForKey:@"content"];
    cell.activityCreatedDate.text = [activity valueForKey:@"created_at"];
    return cell;
}

#pragma mark - Open other screen
- (void)goWords {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SecondStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"WordsListViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goLesson {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SecondStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CategoriesViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
