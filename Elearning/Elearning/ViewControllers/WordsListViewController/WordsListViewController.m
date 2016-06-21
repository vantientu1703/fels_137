//
//  WordsListViewController.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/20/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "WordsListViewController.h"
#import "WordItem.h"
#import "DBUtil.h"
#import "CategoriesViewController.h"
#import "WordListManager.h"
#import "CategoryManager.h"
#import "WordListTableViewCell.h"
#import "LoadingView.h"
#import "Constants.h"

@interface WordsListViewController ()<NSURLConnectionDataDelegate,UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate,WordListManagerDelegate,CategoryManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *wordsList;
@property (strong, nonatomic) NSMutableArray *arrCategories;
@property (weak, nonatomic) IBOutlet UIButton *btnAll1;
@property (weak, nonatomic) IBOutlet UIButton *btnAll2;
@property (strong, nonatomic) LoadingView *loadingView;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) UILabel *labelNoData;

@end

@implementation WordsListViewController

{
    NSString *_categoryID;
    NSString *_option;
    NSInteger _totalPageWordList;
    NSInteger _currentPageWordList;
    NSInteger _currentPageCategory;
    NSInteger _totalPagesCategory;
}
NSString *const TITLE_REMINDER = @"Reminder";
NSString *const TITLE_FILTER = @"Filter";
NSString *const CANCEL_ACTION = @"Cancel";
NSString *const QUIT_ACTION = @"Quit";
NSString *const RELOAD_ACTION = @"Reload";
NSString *const MESSAGE_REMINDER_CHECK_INTERNET = @"Check internet network,please";
NSString *const MESSAGE_REMINDER_SERVER_ERROR = @"Internal server error";
NSString *const MESSAGE_FITLER = @"Select type filter";
NSString *const ALL_ACTION = @"All";
NSString *const NOT_LEARN_ACTION = @"Not learn";
NSString *const LEARNED_ACTION = @"Learned";
NSString *const NAME_WORDLIST_TABLEVIEWCELL = @"WordListTableViewCell";
NSString *const NO_DATA = @"No data :)~";
NSInteger const PER_PAGE_DATA = 10;
CGFloat const CELL_HEIGHT_WORDLIST = 44.f;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.user = [StoreData getUser];
    _currentPageWordList = 1;
    _currentPageCategory = 1;
    self.wordsList = [[NSMutableArray alloc] init];
    self.arrCategories = [[NSMutableArray alloc] init];
}
- (void)viewWillAppear: (BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Words List";
    [self setupLoadingView];
    _option = @"all_word";
    self.wordsList = [[NSMutableArray alloc] init];
    [self getWordListWithCategoryId:_categoryID
                               page:_currentPageWordList
                             option:_option];
    [self getCategoriesListWithAuthToken:self.user.authToken
                                    page:_currentPageCategory
                             perPageData:PER_PAGE_DATA];
}

#pragma mark - LoadingView

- (void)setupLoadingView {
    self.loadingView = [[LoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.loadingView];
}
- (void)animateDismissLoadingView {
    [UIView animateWithDuration:0.25f animations:^{
        self.loadingView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    }];
}

#pragma mark - CategoryManagerDelegate

- (void)getCategoriesListWithAuthToken:(NSString *)authoToken
                                  page:(NSInteger)page
                           perPageData:(NSInteger)perPageData {
    CategoryManager *catManager = [CategoryManager new];
    catManager.delegate = self;
    [catManager getCategoryWithAuthToken:authoToken
                                    page:_currentPageCategory
                             perPageData:perPageData];
}
- (void)didReceiveCategories:(NSMutableArray *)arrCategories message:(NSString *)message withError:(NSError *)error {
    if (error) {
        [self turnOnAlertWithMessage:message];
    } else {
        if ([message isEqualToString:@""]) {
            [self animateDismissLoadingView];
            if (arrCategories.count > 0) {
                NSMutableArray *arr = arrCategories[0];
                for (NSDictionary *item in arr) {
                    CategoryItem *categoryItem = [DBUtil dbCategoryItem:item];
                    [self.arrCategories addObject:categoryItem];
                }
                if (arrCategories.count > 1) {
                    _totalPagesCategory = [arrCategories[1] integerValue];
                    if (_currentPageCategory < _totalPagesCategory) {
                        _currentPageCategory++;
                        [self getCategoriesListWithAuthToken:self.user.authToken page:_currentPageCategory perPageData:PER_PAGE_DATA];
                    }
                }
            }
        } else {
            [self turnOnAlertWithMessage:message];
        }
    }
}

#pragma mark - WorldListManageDelegate

- (void)getWordListWithCategoryId:(NSString *)categoriesID
                             page:(NSInteger)currentPage
                           option:(NSString *)optionWords {
    WordListManager *wlManager = [[WordListManager alloc] init];
    wlManager.delegate = self;
    [wlManager getWordListWithCategoryId:categoriesID
                                  option:optionWords
                                    page:currentPage
                             perPageData:PER_PAGE_DATA
                               authToken:self.user.authToken];
}
- (void)didReceiveWordListWithArray:(NSMutableArray *)arrWords message:(NSString *)message withError:(NSError *)error {
    if (!error) {
        if (!message.length) {
            [self animateDismissLoadingView];
            if (arrWords.count > 0) {
                NSMutableArray *arr = arrWords[0];
                for (NSDictionary *item in arr) {
                    WordItem *word = [DBUtil dbItemToWordItem:item ];
                    [self.wordsList addObject:word];
                }
                if (!self.wordsList.count) {
                    [self setupLabelNoData];
                } else {
                    [self.labelNoData removeFromSuperview];
                    self.labelNoData = nil;
                }
                [self.tableView reloadData];
                if (arrWords.count > 1) {
                    _totalPageWordList = [arrWords[1] integerValue];
                }
            }
        } else {
            [self turnOnAlertWithMessage:message];
        }
    } else {
        [self turnOnAlertWithMessage:message];
    }
}
#pragma mark - Init label no data;
- (void)setupLabelNoData {
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (!self.labelNoData) {
        self.labelNoData = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, 100.f)];
        self.labelNoData.center = CGPointMake(size.width / 2, size.height / 2);
        self.labelNoData.text = NO_DATA;
        [self.labelNoData setFont:[UIFont systemFontOfSize:20.f]];
        self.labelNoData.textColor = [UIColor blackColor];
        self.labelNoData.textAlignment = NSTextAlignmentCenter;
        self.labelNoData.alpha = 0.3f;
        [self.view addSubview:self.labelNoData];
    }
}
#pragma mark - AlertController when disconnected

- (void)turnOnAlertWithMessage:(NSString *)message {
    if (!message.length) {
        message = MESSAGE_REMINDER_CHECK_INTERNET;
    }
    [AlertManager showAlertWithTitle:TITLE_REMINDER message:message viewControler:self reloadAction:^{
        [self getWordListWithCategoryId:_categoryID
                                   page:_currentPageWordList
                                 option:_option];
        self.arrCategories = [[NSMutableArray alloc] init];
        [self getCategoriesListWithAuthToken:self.user.authToken
                                        page:_currentPageCategory
                                 perPageData:PER_PAGE_DATA];
    }];
}
#pragma mark - All Buttons

- (IBAction)btnAll1:(id)sender {
    if (self.arrCategories.count > 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:TITLE_FILTER message:MESSAGE_FITLER preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *allAction = [UIAlertAction actionWithTitle:ALL_ACTION style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _categoryID = nil;
            [self loadDataWithFilter];
        }];
        [alert addAction:allAction];
        for (CategoryItem *categoryItem in self.arrCategories) {
            NSString *name = categoryItem.name;
            UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithString:name] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [self.btnAll1 setTitle: categoryItem.name forState: UIControlStateNormal];
                _categoryID = categoryItem.ID;
                [self loadDataWithFilter];
            }];
            [alert addAction:action];
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CANCEL_ACTION style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)btnAll2:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:TITLE_FILTER message:MESSAGE_FITLER preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *allAction = [UIAlertAction actionWithTitle:ALL_ACTION style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _option = @"all_word";
        [self.btnAll2 setTitle: ALL_ACTION forState:UIControlStateNormal];
        [self loadDataWithFilter];
    }];
    UIAlertAction *learnedAction = [UIAlertAction actionWithTitle:LEARNED_ACTION style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _option = @"learned";
        [self.btnAll2 setTitle:LEARNED_ACTION forState:UIControlStateNormal];
        [self loadDataWithFilter];
    }];
    UIAlertAction *notLearnedAction = [UIAlertAction actionWithTitle:NOT_LEARN_ACTION style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.btnAll2 setTitle:NOT_LEARN_ACTION forState:UIControlStateNormal];
        _option = @"no_learn";
        [self loadDataWithFilter];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CANCEL_ACTION style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:allAction];
    [alertController addAction:learnedAction];
    [alertController addAction:notLearnedAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}
- (void)loadDataWithFilter {
    _currentPageWordList = 1;
    [self setupLoadingView];
    self.wordsList = [[NSMutableArray alloc] init];
    [self getWordListWithCategoryId:_categoryID
                               page:_currentPageWordList
                             option:_option];
}

#pragma mark - UITableViewDataSources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wordsList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellWordlist";
    WordListTableViewCell *cell = (WordListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    WordItem *wordItem = self.wordsList[indexPath.row];
    for (NSDictionary *item in wordItem.arrAnswers) {
        AnswerItem *answer = [DBUtil dbAnswerItem:item];
        if (answer.isCorrect) {
            cell.labelAnswer.text = answer.content;
        }
    }
    cell.labelQuestion.text = [NSString stringWithFormat:@"%ld.%@", (long)indexPath.row + 1, wordItem.content];
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, CELL_HEIGHT_WORDLIST - 1.f, size.width - 10.0f, 1.0f)];
    separatorLineView.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:separatorLineView];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.wordsList.count - 1) {
        [self loadMoreWords];
    }
}
- (void)loadMoreWords {
    if (_currentPageWordList < _totalPageWordList) {
        _currentPageWordList ++;
        [self getWordListWithCategoryId:_categoryID
                                   page:_currentPageWordList
                                 option:_option];
    }
}
@end
