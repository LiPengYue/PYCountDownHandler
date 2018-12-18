//
//  SpecialsCountDownManager.m
//  yiapp
//
//  Created by 李鹏跃 on 2018/12/13.
//  Copyright © 2018年 yi23. All rights reserved.
//

#import "CountDownHandler.h"
#import <objc/runtime.h>

static NSString *const K_countDownHandler_startCountDown = @"K_countDownHandler_startCountDown";


@interface CountDownHandler()
@property (nonatomic,strong) NSMutableArray <id<CountDownHandlerDelegate>>*delegates;
@property (nonatomic,strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation CountDownHandler

- (instancetype) init {
    if (self = [super init]) {
        self.timeInterval = 1;
        self.currentTime = 0;
        self.targetMaxCount = 100;
    }
    return self;
}

- (void) start {
    if (!self.timer) {
        [self createTimer];
    }
}

- (void) end {
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
}

- (void)registerCountDownEventWithDelegates:(NSArray<id<CountDownHandlerDelegate>> *)delegates {
    __weak typeof(self)weakSelf = self;
    [delegates enumerateObjectsUsingBlock:^(id<CountDownHandlerDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf registerCountDownEventWithDelegate:obj];
    }];
}
- (void) registerCountDownEventWithDelegate: (id <CountDownHandlerDelegate>)delegate {
    
    __weak typeof(delegate) weakDelegate = delegate;
    __weak typeof(self) weakSelf = self;
    if ([weakSelf getDelegateStartCountDownTime:weakDelegate] < 0) {
        [weakSelf setDelegateStartCountDownTime:delegate];
    }
    if([weakDelegate respondsToSelector:@selector(countDownHandler:andCurrentUntil:)]) {
        CGFloat currentUntil = weakSelf.currentTime - [weakSelf getDelegateStartCountDownTime:delegate];
        [weakDelegate countDownHandler:weakSelf andCurrentUntil:currentUntil];
    }
    if ([self.delegates containsObject:delegate]) {
        return;
    }
    
    if (self.delegates.count > self.targetMaxCount) {
        [self endReceiveWithDelegate:self.delegates.firstObject];
    }
    
    [self lock:^{
        [weakSelf.delegates addObject:weakDelegate];
    }];
}

- (void) endReceiveWithDelegate: (id)delegate {
    if (!delegate) return;
    __weak typeof(self)weakSelf = self;
    [self lock:^{
        [weakSelf.delegates removeObject: delegate];
    }];
}

- (void)timerAction {
    [self lock:^{
        self.currentTime += self.timeInterval;
        __weak typeof (self)weakSelf = self;
        
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        
        dispatch_async(q, ^{
            [self.delegates enumerateObjectsUsingBlock:^(id<CountDownHandlerDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj respondsToSelector:@selector(countDownHandler:andCurrentUntil:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CGFloat currentUntil = weakSelf.currentTime - [weakSelf getDelegateStartCountDownTime:obj];
                        [obj countDownHandler:weakSelf andCurrentUntil:currentUntil];
                    });
                }
            }];
        });
    }];
}

- (void) lock: (void(^)(void))block {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    if (block) {
        block();
    }
    dispatch_semaphore_signal(self.semaphore);
}

- (void) createTimer {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    self.timer = timer;
    /*
     第一个参数:定时器对象
     第二个参数:DISPATCH_TIME_NOW 表示从现在开始计时
     第三个参数:间隔时间 GCD里面的时间最小单位为 纳秒
     第四个参数:精准度(表示允许的误差,0表示绝对精准)
     */
    dispatch_time_t t = self.isStopWithBackstage ? DISPATCH_TIME_NOW : dispatch_walltime(NULL,0);
    dispatch_source_set_timer(timer, t, self.timeInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        [weakSelf timerAction];
    });
    dispatch_resume(timer);
}

- (void)dealloc {
    NSLog(@"✅销毁：%@",NSStringFromClass([self class]));
}

- (NSArray *) getCurrentDelegates {
    return self.delegates.copy;
}

- (void) removeAllDelegate {
    __weak typeof(self)weakSelf = self;
    [self.delegates enumerateObjectsUsingBlock:^(id<CountDownHandlerDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf endReceiveWithDelegate:obj];
    }];
}

// MARK: - get && set
- (NSMutableArray <id<CountDownHandlerDelegate>>*) delegates {
    if (!_delegates) {
        _delegates = [NSMutableArray new];
    }
    return _delegates;
}

- (dispatch_semaphore_t) semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(1);
    }
    return _semaphore;
}

- (void) setDelegateStartCountDownTime: (id<CountDownHandlerDelegate>)delegate {
    objc_setAssociatedObject(delegate, &K_countDownHandler_startCountDown, @(self.currentTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat) getDelegateStartCountDownTime: (id<CountDownHandlerDelegate>)delegate {
    NSNumber *obj = objc_getAssociatedObject(delegate, &K_countDownHandler_startCountDown);
    if (![obj isKindOfClass:[NSNumber class]]) {
        return -1;
    }
    return obj.integerValue;
}
@end
