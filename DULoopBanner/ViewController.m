//
//  ViewController.m
//  DULoopBanner
//
//  Created by dreamer on 15/12/18.
//  Copyright (c) 2015 Xiao Du. All rights reserved.
//


#import "ViewController.h"
#import "DULoopBannerView.h"
#import "View+MASAdditions.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *bannerContainer;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *imageNames = [NSMutableArray array];
    for (int index = 0; index < 4; ++index) {
        NSString *imageName = [NSString stringWithFormat:@"banner%i",index];
        [imageNames addObject:imageName];
    }
    DULoopBannerView *bannerView = [[DULoopBannerView alloc] initWithFrame:CGRectMake(0,100,[UIScreen mainScreen].bounds.size.width,200) withBannerData:imageNames];
    [self.view addSubview:bannerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}


@end