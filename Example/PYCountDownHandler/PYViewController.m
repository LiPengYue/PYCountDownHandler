//
//  PYViewController.m
//  PYCountDownHandler
//
//  Created by LiPengYue on 12/18/2018.
//  Copyright (c) 2018 LiPengYue. All rights reserved.
//

#import "PYViewController.h"
#import "PYCountDownViewController.h"

@interface PYViewController ()
@property (nonatomic,strong) UIButton *modalCountDownVCButton;
@end

@implementation PYViewController

#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}


#pragma mark - functions

- (void) setup {
    [self setupNav];
    [self setupView];
    [self registerEvents];
}
// MARK: network


// MARK: handle views
- (void) setupNav {
    
}

- (void) setupView {
    [self.view addSubview:self.modalCountDownVCButton];
    self.modalCountDownVCButton.frame = self.view.bounds;
}

// MARK: handle event
- (void) registerEvents {
    
}

// MARK: properties get && set

/// - modalCountDownVCButton Button
- (UIButton *) modalCountDownVCButton {
    if (!_modalCountDownVCButton) {
        _modalCountDownVCButton = [UIButton new];
        [_modalCountDownVCButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [_modalCountDownVCButton setTitle:@"进入时视图" forState:UIControlStateNormal];
        _modalCountDownVCButton.backgroundColor = UIColor.blackColor;
        [_modalCountDownVCButton addTarget:self action:@selector(click_modalCountDownVCButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modalCountDownVCButton;
}
- (void)click_modalCountDownVCButton {
    PYCountDownViewController *vc = [PYCountDownViewController new];
    [self presentViewController:vc animated:true completion:nil];
}

// MARK:life cycles


@end

