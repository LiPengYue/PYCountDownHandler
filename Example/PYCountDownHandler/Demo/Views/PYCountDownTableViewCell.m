//
//  PYCountDownTableViewCell.m
//  PYKit_Example
//
//  Created by 李鹏跃 on 2018/12/13.
//  Copyright © 2018年 LiPengYue. All rights reserved.
//

#import "PYCountDownTableViewCell.h"
#import "CountDownHandler.h"
#import "PYCountDownModel.h"
#import "PYHandleDate.h"

@interface PYCountDownTableViewCell ()
@property (nonatomic,strong) UILabel *countDownLabel;
@end

@implementation PYCountDownTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void) setup {
    [self.contentView addSubview:self.countDownLabel];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.countDownLabel.frame = self.bounds;
}
/// - countDownLabel label
- (UILabel *) countDownLabel {
    if (!_countDownLabel) {
        _countDownLabel = [UILabel new];
        _countDownLabel.textAlignment = NSTextAlignmentCenter;
        _countDownLabel.font = [UIFont systemFontOfSize:20];
        _countDownLabel.textColor = UIColor.redColor;
    }
    return _countDownLabel;
}


- (void) setModel:(PYCountDownModel *)model {
    _model = model;
    __weak typeof(self)weakSelf = self;
    [self.model didSetCountDownNumFunc:^{
        
        CGFloat countDown = weakSelf.model.countDownNum - weakSelf.model.currentCountDown;
        if (countDown <= 0) {
            weakSelf.countDownLabel.text = @"活动结束";
            return;
        }
        
        [[PYHandleDate sharedHandleDate] compareDateWithDateFormatter:@"yyyy-MM-dd HH:mm:ss" andCompareDate:@0 andSecondCompareDate:@(countDown) andDateBlock:^(NSInteger year, NSInteger month, NSInteger day, NSInteger hour, NSInteger minute, NSInteger second, NSString *dateStr) {
            weakSelf.countDownLabel.text = dateStr;
        }];
    }];
    
}

- (void)dealloc {
    NSLog(@"✅销毁：%@",NSStringFromClass([self class]));
}

@end
