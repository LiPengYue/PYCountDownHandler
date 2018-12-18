//
//  PYCountDownModel.m
//  PYKit_Example
//
//  Created by 李鹏跃 on 2018/12/13.
//  Copyright © 2018年 LiPengYue. All rights reserved.
//

#import "PYCountDownModel.h"
#import "CountDownHandler.h"

@interface PYCountDownModel ()
@property (nonatomic,copy) void(^didSetCountDownNumBlock)(void);
@property (nonatomic,copy) void(^countDownBlock)(CountDownHandler *handler);
@end
@implementation PYCountDownModel

- (void) didSetCountDownNumFunc: (void(^)(void))block {
    self.didSetCountDownNumBlock = block;
}

- (void)dealloc {
    NSLog(@"✅销毁：%@",NSStringFromClass([self class]));
}
- (void)countDownHandler:(CountDownHandler *)handler andCurrentUntil:(CGFloat)until{
    self.currentCountDown = until;
    if (self.didSetCountDownNumBlock) {
        self.didSetCountDownNumBlock();
    }
}
@end
