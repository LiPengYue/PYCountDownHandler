//
//  PYViewController.m
//  PYCountDownHandler
//
//  Created by LiPengYue on 12/18/2018.
//  Copyright (c) 2018 LiPengYue. All rights reserved.
//

#import "PYViewController.h"
#import "PYCountDownTableViewCell.h"
#import "PYCountDownModel.h"
#import <CountDownHandler.h>

static NSString *const k_PYCountDownTableViewCellID = @"k_PYCountDownTableViewCellID";
#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]



#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
@interface PYViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray <PYCountDownModel *> *modelArray;
@property (nonatomic,strong) CountDownHandler *countDownHandler;
@end

@implementation PYViewController

#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}


#pragma mark - functions

- (void) setup {
    self.countDownHandler = [[CountDownHandler alloc]init];
    self.countDownHandler.targetMaxCount = 50;
    [self.countDownHandler start];
    [self loadData];
    [self setupView];
}

// MARK: network
- (void) loadData {
    NSMutableArray * arrayM = @[].mutableCopy;
    for (int i = 0; i < 20; i ++) {
        PYCountDownModel *model = [PYCountDownModel new];
        model.countDownNum = 340;
        
        [arrayM addObject:model];
    }
    self.modelArray = arrayM.copy;
}

// MARK: handle views

- (void) setupView {
    
    [self.view addSubview:self.tableView];
    
    [self layoutTableView];
    
    [self.tableView registerClass:[PYCountDownTableViewCell class] forCellReuseIdentifier:k_PYCountDownTableViewCellID];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    [self setupFooterView];
    
    // tableView 偏移20/64适配
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void) layoutTableView {
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    [self.view addConstraints:@[top,left,bottom,right]];
}

- (void) setupFooterView {
    
    UIButton *footerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 40)];
    footerButton.backgroundColor = UIColor.redColor;
    [footerButton setTitle:@"点击加载更多" forState:UIControlStateNormal];
    [footerButton setTitle:@"加载中" forState:UIControlStateSelected];
    self.tableView.tableFooterView = footerButton;
    [footerButton addTarget:self action:@selector(clickLoadData:) forControlEvents:UIControlEventTouchUpInside];
}
/// 加载数据
- (void) clickLoadData:(UIButton *)button {
    button.selected = true;
    button.userInteractionEnabled = false;
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), q, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray * arrayM = self.modelArray.mutableCopy;
            for (int i = 0; i < 20; i ++) {
                PYCountDownModel *model = [PYCountDownModel new];
                model.countDownNum = 340;
                
                [arrayM addObject:model];
            }
            self.modelArray = arrayM.copy;
            button.selected = false;
            button.userInteractionEnabled = true;
        });
    });
}

// MARK: properties get && set
- (void)setModelArray:(NSArray<PYCountDownModel *> *)modelArray {
    _modelArray = modelArray;
    [self.countDownHandler registerCountDownEventWithDelegates:modelArray];
    [self.tableView reloadData];
}

// MARK: - delegate && datesource

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}


//MARK: - delegate && datasource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PYCountDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:k_PYCountDownTableViewCellID forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[PYCountDownTableViewCell class]]) {
        PYCountDownModel *model = self.modelArray[indexPath.row];
        cell.model = model;
        [self.countDownHandler registerCountDownEventWithDelegate: cell.model];
    }
    return cell;
}

// MARK:life cycles
- (void)dealloc {
    [self.countDownHandler end];
    NSLog(@"✅%@",NSStringFromClass([self class]));
}
@end

