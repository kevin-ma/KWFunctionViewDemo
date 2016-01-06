//
//  ViewController.m
//  KWFunctionViewDemo
//
//  Created by 凯文马 on 16/1/4.
//  Copyright © 2016年 凯文马. All rights reserved.
//

#import "KWViewController.h"
#import "KWShowViewController.h"

@interface KWViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation KWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"效果演示选择";
    [self loadTableView];
}

- (void)loadTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
}

# pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"viewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    NSDictionary *dict = self.datas[indexPath.row];
    cell.textLabel.text = dict[@"title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"对应文件夹：%@",dict[@"subtitle"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.datas[indexPath.row];
    KWShowViewController *vc = [[KWShowViewController alloc] init];
    vc.title = dict[@"title"];
    vc.actionString = dict[@"action"];
    [self.navigationController pushViewController:vc animated:YES];
}


# pragma mark - getter

- (NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [@[
                    @{@"title" : @"无限滚动演示", @"subtitle" : @"KWPageScrollView" ,@"action" : @"pageScrollViewDemo"},
                    @{@"title" : @"通知滚动条" , @"subtitle" : @"KWNoticeScrollView",@"action" : @"noticeScrollViewDemo"},
                   ] mutableCopy];
    }
    return _datas;
}

@end
