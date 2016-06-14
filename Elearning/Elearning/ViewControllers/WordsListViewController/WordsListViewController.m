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
//#import "CategoryManager.h"
#import "WordListTableViewCell.h"
#import "LoadingView.h"

NSString *const USER_TOKEN = @"-Kx03yy94NhYc81Shz63_g"; //TODO:
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

@interface WordsListViewController ()<NSURLConnectionDataDelegate,UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate,WordListManagerDelegate>
// TODO:Hiện tại chưa dùng đến
// CategoryManagerDelegate

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *wordsList;
@property (strong, nonatomic) NSMutableArray *arrCategories;
@property (weak, nonatomic) IBOutlet UIButton *btnAll1;
@property (weak, nonatomic) IBOutlet UIButton *btnAll2;
@property (strong, nonatomic) LoadingView *loadingView;

@end

@implementation WordsListViewController

{
    NSString *_categoryID;
    NSString *_option;
    NSInteger _totalPage;
    NSInteger _currentPage;
}

NSString *const NAME_WORDLIST_TABLEVIEWCELL = @"WordListTableViewCell";
NSInteger const PER_PAGE_DATA = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _currentPage = 1;
    self.wordsList = [[NSMutableArray alloc] init];
}
- (void)viewWillAppear: (BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Words List";
    [self setupLoadingView];
    _option = @"all_word";
    self.wordsList = [[NSMutableArray alloc] init];
    [self getWordListWithCategoryId:_categoryID
                               page:_currentPage
                             option:_option];
    [self getCategoriesListWithAuthToken:USER_TOKEN
                                    page:_currentPage
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
    }];
}

#pragma mark - CategoryManagerDelegate

- (void)getCategoriesListWithAuthToken:(NSString *)authoToken
                                  page:(NSInteger)page
                           perPageData:(NSInteger)perPageData {
// TODO: Hiện tại chưa dùng đến
//    CategoryManager *catManager = [CategoryManager new];
//    catManager.delegate = self;
//    [catManager doGetCategoryWithAuthToken:authoToken
//                                      page:page
//                               perPageData:perPageData];
}
- (void)didReceiveCategoriesWithArray:(NSMutableArray *)arrCategories
                            withError:(NSError *)error {
    
// TODO: Hiện tại chưa dùng đến 
//    if (error) {
//        [self turnOnAlertWithMessage:@""];
//    } else {
//        [self animateDismissLoadingView];
//        self.arrCategories = arrCategories;
//    }
}

#pragma mark - WorldListManageDelegate

- (void)getWordListWithCategoryId:(NSString *)categoriesID
                             page:(NSInteger)pageCurrents
                           option:(NSString *)optionWords {
    WordListManager *wlManager = [[WordListManager alloc] init];
    wlManager.delegate = self;
    [wlManager getWordListWithCategoryId:categoriesID
                                  option:optionWords
                                    page:pageCurrents
                             perPageData:PER_PAGE_DATA
                               authToken:USER_TOKEN];
}
- (void)didReceiveWordListWithArray:(NSMutableArray *)arrWords message:(NSString *)message withError:(NSError *)error {
    if (!error) {
        if ([message isEqualToString:@""]) {
            [self animateDismissLoadingView];
            if (arrWords.count > 0) {
                NSMutableArray *arr = arrWords[0];
                for (NSDictionary *item in arr) {
                    WordItem *word = [DBUtil dbItemToWordItem:item ];
                    [self.wordsList addObject:word];
                }
                [self.tableView reloadData];
                if (arrWords.count > 1) {
                    _totalPage = [arrWords[1] integerValue];
                }
            }
        } else {
            [self turnOnAlertWithMessage:message];
        }
    } else {
        [self turnOnAlertWithMessage:message];
    }
}

#pragma mark - AlertController when disconnected

- (void)turnOnAlertWithMessage:(NSString *)message {
    UIAlertController *alerController;
    if ([message isEqualToString:@""]) {
        alerController = [UIAlertController alertControllerWithTitle:TITLE_REMINDER message:MESSAGE_REMINDER_CHECK_INTERNET preferredStyle:UIAlertControllerStyleActionSheet];
    } else {
        alerController = [UIAlertController alertControllerWithTitle:TITLE_REMINDER message:message preferredStyle:UIAlertControllerStyleActionSheet];
    }
    UIAlertAction *reloadAction = [UIAlertAction actionWithTitle:RELOAD_ACTION style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _currentPage = 1;
        [self getWordListWithCategoryId:_categoryID
                                   page:_currentPage
                                 option:_option];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:QUIT_ACTION style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }];
    [alerController addAction:reloadAction];
    [alerController addAction:okAction];
    [self presentViewController:alerController
                       animated:YES
                     completion:nil];
}
#pragma mark - All Buttons

- (IBAction)btnAll1:(id)sender {
    [self getCategoriesListWithAuthToken:USER_TOKEN
                                    page:_currentPage
                             perPageData:PER_PAGE_DATA];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TITLE_FILTER message:MESSAGE_FITLER preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *allAction = [UIAlertAction actionWithTitle:ALL_ACTION style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setupLoadingView];
        _categoryID = nil;
        [self.btnAll1 setTitle:ALL_ACTION forState:UIControlStateNormal];
        [self getWordListWithCategoryId:_categoryID
                                   page:_currentPage
                                 option:_option];
    }];
    [alert addAction:allAction];
// TODO: Hiện tại chưa dùng đến
//            for (int i = 0; i < self.arrCategories.count; i ++) {
//                CategoryItem *catergoryItem = [DBUtil dbCategoryItem:self.arrCategories[i]];
//                NSString *name = catergoryItem.name;
//                UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithString:name]
//                                                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                                                                          NSLog(@"You pressed button one");
//                                                                          [self setupLoadingView];
//                                                                          [self.btnAll1 setTitle: catergoryItem.name
//                                                                                        forState: UIControlStateNormal];
//                                                                          categoryID = catergoryItem.ID;
//                                                                          [self getWordListWithCategoryId: categoryID
//                                                                                                   option: option];
//                                                                      }];
//                [alert addAction:action];
//            }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CANCEL_ACTION style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnAll2:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:TITLE_FILTER
                                                                             message:MESSAGE_FITLER
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
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
    _currentPage = 1;
    [self setupLoadingView];
    self.wordsList = [[NSMutableArray alloc] init];
    [self getWordListWithCategoryId:_categoryID
                               page:_currentPage
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
    cell.labelQuestion.text = [NSString stringWithFormat:@"%ld.%@", (long)indexPath.row, wordItem.content];
        return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.wordsList.count - 1) {
        [self loadMoreWords];
    }
}
- (void)loadMoreWords {
    if (_currentPage < _totalPage) {
        _currentPage ++;
        [self getWordListWithCategoryId:_categoryID
                                   page:_currentPage
                                 option:_option];
    }
}
@end
