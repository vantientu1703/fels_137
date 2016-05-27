//
//  CategoriesViewController.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/20/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "CategoriesViewController.h"
#import "CategoriesTableViewCell.h"
#import "iOSRequest.h"
#import "CategoryItem.h"
#import "DBUtil.h"
#import "WordItem.h"
#import "LessonViewController.h"
#import "CategoryManager.h"
#import "WordListManager.h"
#import "LoadingView.h"
#import "UIImageView+WebCache.h"

#define CELL_HEIGHT 99
@interface CategoriesViewController ()<UITableViewDataSource,UITableViewDelegate,CategoryManagerDelegate,WordListManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrCategories;
@property (nonatomic, strong) NSMutableArray *arrWords;
@property (nonatomic, strong) LoadingView *loadingView;

@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Categories";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setupLoadingView];
    //Get categories
    self.arrCategories = [[NSMutableArray alloc] init];
    
    [self getCategoriesListWithAuthToken:@"-Kx03yy94NhYc81Shz63_g"
                                    page:1
                             perPageData:10];
}
#pragma mark - LoadingView

- (void) setupLoadingView {
    
    self.loadingView = [[LoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.loadingView];
}

- (void) animateDismissLoadingView {
    [UIView animateWithDuration:0.1 animations:^{
        self.loadingView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    }];
}
#pragma mark - GetCategories
- (void) getCategoriesListWithAuthToken:(NSString*)authoToken
                                   page:(int) page
                            perPageData:(int) perPageData {
    CategoryManager *catManager = [CategoryManager new];
    catManager.delegate = self;
    
    [catManager doGetCategoryWithAuthToken:authoToken
                                      page:page
                               perPageData:perPageData];
}

- (void)didReceiveCategoriesWithArray:(NSMutableArray *)arrCategories
                            withError:(NSError *)error {
    if (error) {
        [self turnOnAlertWhenDisconneted];
    } else {
        [self animateDismissLoadingView];
        self.arrCategories = arrCategories;
        [self.tableView reloadData];
    }
}

#pragma mark - WorldListManageDelegate
- (void) getWordListWithCategoryId:(NSString*) categoriesID
                            option:(NSString*) optionWords {
    WordListManager *wlManager = [[WordListManager alloc] init];
    wlManager.delegate = self;
    
    [wlManager doGetWordListWithCategoryId:categoriesID
                                    option:optionWords
                                      page:1
                               perPageData:10
                                 authToken:@"-Kx03yy94NhYc81Shz63_g"];
}
- (void)didReceiveWordListWithArray:(NSMutableArray *)arrWords withError:(NSError *)error {
    
    if (!error) {
        self.arrWords = arrWords;
        [self.tableView reloadData];
        
    } else {
        [self turnOnAlertWhenDisconneted];
    }
}
#pragma mark - AlertController

- (void) turnOnAlertWhenDisconneted {
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"Reminder"
                                                                            message:@"Check internet network,please"
                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Reload"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [self getCategoriesListWithAuthToken:@"-Kx03yy94NhYc81Shz63_g"
                                                                                         page:1
                                                                                  perPageData:10];
                                                         
                                                     }];
    UIAlertAction *quitAction = [UIAlertAction actionWithTitle:@"Quit"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         exit(0);
                                                     }];
    
    [alerController addAction:okAction];
    [alerController addAction:quitAction];
    [self presentViewController:alerController
                       animated:YES
                     completion:nil];
}
#pragma mark - UITableViewDataSources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrCategories.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CellCategory";
    
    CategoriesTableViewCell *cell = (CategoriesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"CategoriesTableViewCell" owner:self options:nil];
        
        cell = xib[0];
    }
    
    CategoryItem *categoryItem = [DBUtil dbCategoryItem:self.arrCategories[indexPath.row]];
    cell.name.text = categoryItem.name;
    
    if (categoryItem.learnedWords > 0) {
        cell.totalLearnedWord.text = [NSString stringWithFormat:@"Your have learned %d words", categoryItem.learnedWords];
    } else {
        cell.totalLearnedWord.text = [NSString stringWithFormat:@"Your are have not learn word"];
    }
    
    // No API
    // cell.words.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.arrWords.count];
    
//    NSData *data = [NSData dataWithContentsOfURL:categoryItem.url];
//    cell.photo.image = [[UIImage alloc] initWithData:data];
    
    [cell.photo sd_setImageWithURL:categoryItem.url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *st = [UIStoryboard storyboardWithName:@"SecondStoryboard" bundle:nil];
    
    
    LessonViewController *lessionViewConotroller = [st instantiateViewControllerWithIdentifier:@"lessonviewcontroller"];
    
    lessionViewConotroller.categoryItem = [DBUtil dbCategoryItem:self.arrCategories[indexPath.row]];
    [self.navigationController pushViewController:lessionViewConotroller animated:YES];
}

@end

