//
//  PYCountDownModel.h
//  PYKit_Example
//
//  Created by 李鹏跃 on 2018/12/13.
//  Copyright © 2018年 LiPengYue. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CountDownHandler;
@class PYCountDownTableViewCell;
#include "CountDownHandler.h"
@interface PYCountDownModel : NSObject<CountDownHandlerDataSource>
@property (nonatomic,assign) NSInteger countDownNum;
@property (nonatomic,assign) NSInteger isShowCountDown;
@property (nonatomic,assign) CGFloat currentCountDown;
//- (void) didSetCountDownNumFunc: (void(^)(void))block;
//- (void) countDownFunc: (void(^)(CountDownHandler *handler)) block;
@end
