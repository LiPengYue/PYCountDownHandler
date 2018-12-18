//
//  SpecialsCountDownManager.h
//  yiapp
//
//  Created by 李鹏跃 on 2018/12/13.
//  Copyright © 2018年 yi23. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 倒计时工具
 @warning  需要自行保证CountDownHandler生命周期
 @warning  如果需求为 tableView的cell中有倒计时:
 
 1. 必须 在数据源数组的set方法中 调用‘registerCountDownEventWithDelegates’方法，进行批量注册，无需判断是否重复注册，方法内部进行了排除

 2. 在tableView中持有CountDownHandler，并且需要在tableView的DataSource方法‘cellFroRowAtIndexPath’中,调用 registerCountDownEventWithDelegate，把model，作为delegate，在代理方法中执行所需要的倒计时计算操作（耗时操作需要异步处理）
 
 3. 在cell中监听model的值的变化，并刷新label的text
 4. 在cell的model的set方法中，判断label是否有text，如果没有需要赋值初始值，初始值直接使用model的倒计时开始时间计算即可，否则会出现一开始label没有赋值的情况
 */

@class CountDownHandler;

@protocol CountDownHandlerDelegate<NSObject>
/// 倒计时回调,当‘registerCountDownEventWithDelegate’调用的时候，会主动触发一次 ‘ 方法
- (void) countDownHandler: (CountDownHandler *)handler andCurrentUntil: (CGFloat)until;
@end


@interface CountDownHandler : NSObject

/**
 倒计时 时间 间隔 （秒单位） 默认为1
 */
@property (nonatomic, assign) CGFloat timeInterval;

/**
  现在已经进行时间 (负数 秒单位) 默认为0
 */
@property (nonatomic, assign) CGFloat currentTime;

/**
 最多同时存在多少个需要倒计时的model
 @warning 最好是两个屏幕所能盛放的cell的数量）， 默认为100
 */
@property (nonatomic, assign) NSInteger targetMaxCount;

/**
 开始倒计时 创建 dispatch_source_t
 */
- (void) start;

/**
 结束倒计时 把timer赋值为nil 不会删除所需要倒计时的model
 */
- (void) end;

/**
 注册倒计时事件
 */
- (void) registerCountDownEventWithDelegate: (id <CountDownHandlerDelegate>)delegate;

/**
 批量添加delegate，

 @param delegates delegate数组 如果数中有元素已经添加，那么将不再添加
 @bug 在有上拉加载的需求中，如果依然 依据当前self.currentTime计算时间的话,会出现差错，因为新返回的数据，需要从0开始倒计时，而不是直接减去currentTime
 
    所以在添加到注册列表的过程中，在delegate中记录了此时的currentTime（记做delegateCurrentTime），
 
    在进行倒计时时候，会利用currentTime - delegateCurrentTime, 得到需要真正的倒计时间
 */
- (void)registerCountDownEventWithDelegates: (NSArray<id <CountDownHandlerDelegate>>*)delegates;

/**
 不再相应倒计时
 @param target 注销倒计时的model
 */
- (void) endReceiveWithDelegate: (id)delegate;

/**
 获取delegates
 */
- (NSArray *) getCurrentDelegates;

/**
 清除所需要倒计时的target
 */
- (void) removeAllDelegate;

/**
 进入后台后，是否停止倒计时 默认为false
 */
@property (nonatomic,assign) BOOL isStopWithBackstage;

/**
 当倒计时 currentTime超过这个值后，currentTime 将重新赋值为0 默认为maxCGFloat
 */
@property (nonatomic,assign) CGFloat maxCurrentCount;
@end
