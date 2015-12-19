//
//  ViewController.m
//  DULoopBanner
//
//  Created by dreamer on 15/12/18.
//  Copyright (c) 2015 Xiao Du. All rights reserved.
//


#import "ViewController.h"
#import "DULoopBannerView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet DULoopBannerView *banner;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSMutableArray *imageNames = [NSMutableArray array];
    for (int index = 0; index < 4; ++index) {
        NSString *imageName = [NSString stringWithFormat:@"banner%i",index];
        [imageNames addObject:imageName];
    }
    self.banner.bannerData = [NSArray arrayWithArray:imageNames];
}


@end