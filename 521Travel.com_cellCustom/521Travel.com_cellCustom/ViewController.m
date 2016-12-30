//
//  ViewController.m
//  521Travel.com_cellCustom
//
//  Created by youngstar on 16/12/30.
//  Copyright © 2016年 521Travel.com. All rights reserved.
/*
 
 http://www.521travel.com/index.php?s=/news/index/detail/id/455.html
 */

//

#import "ViewController.h"
#import "TableViewCell.h"
#import "MJRefresh.h"
#import "DataModel.h"
#import "MJExtension.h"
#import "SDImageCache.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.dataArray = [NSArray array];
    
    // 接受通知并刷新tableview
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"reload" object:nil];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    __weak ViewController *MJRefresh = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [MJRefresh getData];
        
        [_tableView.mj_header endRefreshing];
    }];
    
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [MJRefresh moreData];
        
        [_tableView.mj_footer endRefreshing];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Model" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *arrayTemp = [data objectForKey:@"ModelInfo"];
    
    self.dataArray = [DataModel mj_objectArrayWithKeyValuesArray:arrayTemp];
    NSLog(@"array%@", _dataArray);//直接打印数据。
    
}

- (void)reload:(UIButton *)button
{
    [_tableView reloadData];
}



- (void)getData
{
    [_tableView reloadData];
}

- (void)moreData
{
    [_tableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[TableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIndentifier];
    }
    
    cell.model = [_dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 计算cell内容的高度
    TableViewCell *cell = (TableViewCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return [cell cellForHeight];
}


@end
