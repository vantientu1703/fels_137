//
//  WordsListViewController.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/20/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "WordsListViewController.h"
#import "iOSRequest.h"
#import "WordItem.h"
#import "DBUtil.h"
#import "CategoriesViewController.h"
#import "HandleAPIServer.h"
#import "WordListManager.h"
#import "CategoryManager.h"
#import "WordListTableViewCell.h"
#import "LoadingView.h"

#define WORDS_LIST @"https://manh-nt.herokuapp.com/words.json"
#define CATEGORIES @"https://manh-nt.herokuapp.com/categories.json"
NSString *const AUTH_TOKEN = @"-Kx03yy94NhYc81Shz63_g";

@interface WordsListViewController ()<NSURLConnectionDataDelegate,UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate,WordListManagerDelegate,CategoryManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *wordsList;
@property (nonatomic, strong) NSMutableArray *arrCategories;
@property (weak, nonatomic) IBOutlet UIButton *btnAll1;
@property (weak, nonatomic) IBOutlet UIButton *btnAll2;
@property (nonatomic, strong) LoadingView *loadingView;


@end

@implementation WordsListViewController
{
    NSString *_categoryID;
    NSString *option;
    NSInteger currentPageCategory;
    NSInteger currentPageWordList;
    NSInteger totalPagesWords;
    NSInteger totalPagesCategory;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Words List";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setupLoadingView];
    option = @"all_word";
    currentPageCategory = 1;
    currentPageWordList = 1;
    
    self.wordsList = [[NSMutableArray alloc] init];
    self.arrCategories = [[NSMutableArray alloc] init];
    [self getWordListWithCategoryId:_categoryID page:currentPageWordList perPageData:10 option:option];
    [self getCategoriesListWithAuthToken:AUTH_TOKEN
                                    page:currentPageCategory
                             perPageData:10];
}
#pragma mark - LoadingView

- (void) setupLoadingView {
    
    self.loadingView = [[LoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.loadingView];
}

- (void) animateDismissLoadingView {
    [UIView animateWithDuration:0.25f animations:^{
        self.loadingView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.loadingView removeFromSuperview];
    }];
}
#pragma mark - CategoryManagerDelegate 

- (void) getCategoriesListWithAuthToken:(NSString*)authoToken
                                   page:(NSInteger) page
                            perPageData:(NSInteger) perPageData {
    CategoryManager *catManager = [CategoryManager new];
    catManager.delegate = self;
    
    [catManager doGetCategoryWithAuthToken:authoToken
                                      page:currentPageCategory
                               perPageData:perPageData];
}

- (void)didReceiveCategoriesWithArray:(NSMutableArray *)arrCategories
                            withError:(NSError *)error {
    if (error) {
        [self turnOnAlertWhenDisconneted];
    } else {
        [self animateDismissLoadingView];
        for (NSDictionary *item in arrCategories[0]) {
            CategoryItem *categoryItem = [DBUtil dbCategoryItem:item];
            [self.arrCategories addObject:categoryItem];
        }
        totalPagesCategory = [arrCategories[1] integerValue];
    }
}
#pragma mark - WorldListManageDelegate
- (void) getWordListWithCategoryId:(NSString*) categoriesID
                              page:(NSInteger)page
                       perPageData:(NSInteger)perPageData
                     option:(NSString*) optionWords {
    WordListManager *wlManager = [[WordListManager alloc] init];
    wlManager.delegate = self;
    
        [wlManager doGetWordListWithCategoryId:categoriesID
                                        option:optionWords
                                          page:page
                                   perPageData:perPageData
                                     authToken:@"-Kx03yy94NhYc81Shz63_g"];

}
- (void)didReceiveWordListWithArray:(NSMutableArray *)arrWords
                          withError:(NSError *)error {
    if (!error) {
        [self animateDismissLoadingView];
        for (NSDictionary *item in arrWords[0]) {
            WordItem *wordItem = [DBUtil dbItemToWordItem:item];
            [self.wordsList addObject:wordItem];
        }
        totalPagesWords = [arrWords[1] integerValue];
        [self.tableView reloadData];
        
    } else {
        [self turnOnAlertWhenDisconneted];
    }
}

#pragma mark - AlertController

- (void) turnOnAlertWhenDisconneted {
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"Reminder"
                                                                            message:@"Check internet network,please"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                     }];
    [alerController addAction:okAction];
    [self presentViewController:alerController
                       animated:YES
                     completion:nil];
}

#pragma mark - All Buttons
- (IBAction)btnAll1:(id)sender {
    
//    [self getCategoriesListWithAuthToken:@"-Kx03yy94NhYc81Shz63_g"
//                                    page:1
//                             perPageData:10];
    
    if (currentPageCategory < totalPagesCategory) {
        for (int i = 1; i < totalPagesCategory; i++) {
            self.arrCategories = [[NSMutableArray alloc] init];
            [self getCategoriesListWithAuthToken:AUTH_TOKEN page:i perPageData:10];
        }
    }
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"FILTER"
                                                                           message:@"Select type filter"
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *allAction = [UIAlertAction actionWithTitle:@"All"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  self.wordsList = [[NSMutableArray alloc] init];
                                                                  [self setupLoadingView];
                                                                  _categoryID = nil;
                                                                  currentPageWordList = 1;
                                                                  [self.btnAll1 setTitle:@"All" forState:UIControlStateNormal];
                                                                  [self getWordListWithCategoryId:_categoryID page:currentPageWordList perPageData:10 option:option];
            }];
            [alert addAction:allAction];
            for (CategoryItem *categoryItem in self.arrCategories) {
                NSString *name = categoryItem.name;
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithString:name]
                                                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                          self.wordsList = [[NSMutableArray alloc] init];
                                                                          NSLog(@"You pressed button one");
                                                                          currentPageWordList = 1;
                                                                          [self setupLoadingView];
                                                                          [self.btnAll1 setTitle:categoryItem.name forState:UIControlStateNormal];
                                                                          _categoryID = categoryItem.ID;
                                                                          [self getWordListWithCategoryId:_categoryID page:currentPageWordList perPageData:10 option:option];
                                                                      }];
                [alert addAction:action];
            }
            UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                  style:UIAlertActionStyleCancel
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    NSLog(@"Cancel");
                
            }];
            [alert addAction:closeAction];
            [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnAll2:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Filter"
                                                                             message:@"Select type filter"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *allAction = [UIAlertAction actionWithTitle:@"All"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          self.wordsList = [[NSMutableArray alloc] init];
                                                          [self setupLoadingView];
                                                          option = @"all_word";
                                                          currentPageWordList = 1;
                                                          [self.btnAll2 setTitle:@"All" forState:UIControlStateNormal];
                                                          [self getWordListWithCategoryId:_categoryID page:currentPageWordList perPageData:10 option:option];
                                                              }];
    UIAlertAction *learnedAction = [UIAlertAction actionWithTitle:@"Learned"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              NSLog(@"Learned word");
                                                              self.wordsList = [[NSMutableArray alloc] init];
                                                              currentPageWordList = 1;
                                                              [self setupLoadingView];
                                                              [self.btnAll2 setTitle:@"Learned" forState:UIControlStateNormal];
                                                              option = @"learned";
                                                              [self getWordListWithCategoryId:_categoryID page:currentPageWordList perPageData:10 option:option];
    }];
    UIAlertAction *notLearnedAction = [UIAlertAction actionWithTitle:@"Not Learn"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              NSLog(@"Not Learn");
                                                              self.wordsList = [[NSMutableArray alloc] init];
                                                              currentPageWordList = 1;
                                                              [self setupLoadingView];
                                                              [self.btnAll2 setTitle:@"Not Learn" forState:UIControlStateNormal];
                                                              option = @"no_learn";
                                                              [self getWordListWithCategoryId:_categoryID page:currentPageWordList perPageData:10 option:option];
                                                          }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              NSLog(@"Cancel");
                                                          }];

    [alertController addAction:allAction];
    [alertController addAction:learnedAction];
    [alertController addAction:notLearnedAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.wordsList.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CellWordlist";
    
    WordListTableViewCell *cell = (WordListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"WordListTableViewCell" owner:self options:nil];
        cell = xib[0];
    }
    WordItem *wordItem = self.wordsList[indexPath.row];
    
    for (int i = 0; i < wordItem.arrAnswers.count; i++) {
        AnswerItem *answer = [DBUtil dbAnswerItem:wordItem.arrAnswers[i]];
        if (answer.isCorrect) {
            cell.labelAnswer.text = answer.content;
        }
    }
    cell.labelQuestion.text = wordItem.content;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.wordsList.count) {
        [self loadMoreWords];
    }
}
- (void)loadMoreWords {
    if (currentPageWordList < totalPagesWords) {
        currentPageWordList++;
        [self getWordListWithCategoryId:_categoryID page:currentPageWordList perPageData:10 option:option];
    }
}
@end
