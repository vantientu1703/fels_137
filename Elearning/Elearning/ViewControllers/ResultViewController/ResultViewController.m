//
//  ResultViewController.m
//  Elearning
//
//  Created by Văn Tiến Tú on 5/20/16.
//  Copyright © 2016 Framgia. All rights reserved.
#import "ResultViewController.h"
#import "HomeViewController.h"
#import "CategoriesViewController.h"
#import "ResultTableViewCell.h"
#import "WordItem.h"
#import "DBUtil.h"

@interface ResultViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ResultViewController
NSString *const NAME_RESULT_TABLEVIEW_CELL = @"ResultTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(popViewController:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Back"
                                                                             style: UIBarButtonItemStylePlain
                                                                            target: self
                                                                            action: @selector(backView:)];
}
- (IBAction)backView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)popViewController:(id)sender {
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrWords.count;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellResult";
    ResultTableViewCell *cell = (ResultTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    WordItem *wordItem = [DBUtil dbItemToWordItem:self.arrWords[indexPath.row]];
    cell.labelContent.text = wordItem.content;
    if ([self.arrLearnedWords[indexPath.row][0] isEqualToString:@"false"]) {
        cell.imageView.image = [UIImage imageNamed:@"false.png"];
    } else if ([self.arrLearnedWords[indexPath.row][0] isEqualToString:@"true"]) {
        cell.imageView.image = [UIImage imageNamed:@"true.png"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"hoicham.png"];
    }
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
@end