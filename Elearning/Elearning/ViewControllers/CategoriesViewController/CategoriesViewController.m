//
//  CategoriesViewController.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/20/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "CategoriesViewController.h"
#import "CategoriesTableViewCell.h"
#import "CategoryItem.h"
#import "DBUtil.h"
#import "WordItem.h"
#import "LessonViewController.h"
#import "CategoryManager.h"
#import "WordListManager.h"
#import "LoadingView.h"
#import "UIImageView+WebCache.h"
#import "Constants.h"

@interface CategoriesViewController ()<UITableViewDataSource,UITableViewDelegate,CategoryManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrCategories;
@property (strong, nonatomic) LoadingView *loadingView;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) UILabel *labelNoData;

@end

@implementation CategoriesViewController
{
    NSInteger _currentPageCategory;
    NSInteger _totalPagesCategory;
    NSInteger _perPageData;
}

CGFloat const CATEGORY_CELL_HEIGHT = 80.f;
NSString *const TITLE_ALERT = @"Reminder";
NSString *const TITLE_ACTION_RELOAD = @"Reload";
NSString *const TITLE_ACTION_QUIT = @"Quit";
NSString *const NAME_CATEGORIES_TABLEVIEW_CELL = @"CategoriesTableViewCell";
NSString *const NAME_SECONDSTORYBOARD = @"SecondStoryboard";
NSString *const IDENTIFIER_LESSONV_VIEWCONTROLLER = @"LessonViewcontroller";
NSString *const MESSAGE_REMINDER = @"Check internet network,please";
NSString *const RELOAD_ACT = @"Reload";
NSString *const QUIT_ACT = @"Quit";
NSString *const TOTAL_LEARNED_WORD = @"Your have learned %ld words";
NSString *const NO_LEARN_WORD = @"Your are have not learn word";
NSString * const LABEL_NO_DATA = @"No data :)~";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.user = [StoreData getUser];
    self.arrCategories = [[NSMutableArray alloc] init];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Categories";
    [self setupLoadingView];
    _perPageData = 10;
    _currentPageCategory = 1;
    //Get categories
    self.arrCategories = [[NSMutableArray alloc] init];
    [self getCategoriesListWithAuthToken:self.user.authToken
                                    page:_currentPageCategory
                             perPageData:_perPageData];
}
#pragma mark - LoadingView
- (void)setupLoadingView {
    self.loadingView = [[LoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.loadingView];
}
- (void)animateDismissLoadingView {
    [UIView animateWithDuration:0.1f animations:^{
        self.loadingView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    }];
}
#pragma mark - GetCategories
- (void)getCategoriesListWithAuthToken:(NSString *)authoToken
                                  page:(NSInteger)page
                           perPageData:(NSInteger)perPageData {
    CategoryManager *catManager = [CategoryManager new];
    catManager.delegate = self;
    [catManager getCategoryWithAuthToken:authoToken
                                    page:page
                             perPageData:perPageData];
}
- (void)didReceiveCategories:(NSMutableArray *)arrCategories message:(NSString *)message withError:(NSError *)error {
    if (error) {
        [self turnOnAlertWithMessage:message];
    } else {
        if ([message isEqualToString:@""]) {
            if (arrCategories.count > 0) {
                [self animateDismissLoadingView];
                NSMutableArray *arr = arrCategories[0];
                for (NSDictionary *item in arr) {
                    CategoryItem *categoryIem = [DBUtil dbCategoryItem:item];
                    [self.arrCategories addObject:categoryIem];
                }
                if (!self.arrCategories.count) {
                    [self setupLabelNoData];
                } else {
                    [self.labelNoData removeFromSuperview];
                    self.labelNoData = nil;
                }
                if (arrCategories.count > 1) {
                    _totalPagesCategory = [arrCategories[1] integerValue];
                }
                [self.tableView reloadData];
            }
        } else {
            [self turnOnAlertWithMessage:message];
        }
    }
}
- (void)setupLabelNoData {
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (!self.labelNoData) {
        self.labelNoData = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, 100.f)];
        self.labelNoData.center = CGPointMake(size.width / 2, size.height / 2);
        self.labelNoData.text = LABEL_NO_DATA;
        [self.labelNoData setFont:[UIFont systemFontOfSize:20.f]];
        self.labelNoData.textColor = [UIColor blackColor];
        self.labelNoData.textAlignment = NSTextAlignmentCenter;
        self.labelNoData.alpha = 0.3f;
        [self.view addSubview:self.labelNoData];
    }
}
#pragma mark - AlertController

- (void)turnOnAlertWithMessage:(NSString *)message {
    UIAlertController *alerController;
    if ([message isEqualToString:@""]) {
        alerController = [UIAlertController alertControllerWithTitle:TITLE_ALERT message:MESSAGE_REMINDER preferredStyle:UIAlertControllerStyleActionSheet];
    } else {
        alerController = [UIAlertController alertControllerWithTitle:TITLE_ALERT message:message preferredStyle:UIAlertControllerStyleActionSheet];
    }
    UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:RELOAD_ACT style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _currentPageCategory = 1;
        [self getCategoriesListWithAuthToken:self.user.authToken page:_currentPageCategory perPageData:_perPageData];
    }];
    UIAlertAction *quitAction = [UIAlertAction actionWithTitle:QUIT_ACT style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    [alerController addAction:reloadAction];
    [alerController addAction:quitAction];
    [self presentViewController:alerController
                       animated:YES
                     completion:nil];
}

#pragma mark - UITableViewDataSources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrCategories.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellCategory";
    CategoriesTableViewCell *cell = (CategoriesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    CategoryItem *categoryItem = self.arrCategories[indexPath.row];
    cell.labelNameCategory.text = categoryItem.name;
    if (categoryItem.totalLearnedWords > 0) {
        cell.labelTotalLearnedWord.text = [NSString stringWithFormat:TOTAL_LEARNED_WORD, categoryItem.totalLearnedWords];
    } else {
        cell.labelTotalLearnedWord.text = [NSString stringWithFormat:NO_LEARN_WORD];
    }
    [cell.imageViewCategory sd_setImageWithURL:categoryItem.url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, CATEGORY_CELL_HEIGHT - 1.f, size.width - 10.0f, 1.0f)];
    separatorLineView.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:separatorLineView];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CATEGORY_CELL_HEIGHT;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.arrCategories.count - 1) {
        [self loadMoreCategories];
    }
}
- (void) loadMoreCategories {
    if (_currentPageCategory < _totalPagesCategory) {
        _currentPageCategory++;
        [self getCategoriesListWithAuthToken:self.user.authToken page:_currentPageCategory perPageData:_perPageData];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *st = [UIStoryboard storyboardWithName:NAME_SECONDSTORYBOARD bundle:nil];
    LessonViewController *lessionViewConotroller = [st instantiateViewControllerWithIdentifier:IDENTIFIER_LESSONV_VIEWCONTROLLER];
    lessionViewConotroller.categoryItem = self.arrCategories[indexPath.row];
    [self.navigationController pushViewController:lessionViewConotroller animated:YES];
}
@end
