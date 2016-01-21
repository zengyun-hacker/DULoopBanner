//
//  DULoopBannerView.h
//  DULoopBannerSample
//
//  Created by dreamer on 15/12/18.
//  Copyright © 2015年 Xiao Du. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DUImageTapCallback)(NSInteger index, NSString *imageUrl);

IB_DESIGNABLE
@interface DULoopBannerView : UIView

@property (nonatomic, copy) NSArray *bannerData;
@property (nonatomic) IBInspectable NSInteger pageNumber;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, copy) DUImageTapCallback tapCallback;

- (instancetype)initWithFrame:(CGRect)frame withBannerData:(NSArray *)bannerData;

- (instancetype)initWithFrame:(CGRect)frame withBannerData:(NSArray *)bannerData withScrollViewWidth:(CGFloat)width;

- (instancetype)initWithFrame:(CGRect)frame withBannerData:(NSArray *)bannerData withScrollViewWidth:(CGFloat)width imageTapCallback:(DUImageTapCallback)callback;

@end
