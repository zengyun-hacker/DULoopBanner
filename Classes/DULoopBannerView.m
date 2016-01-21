//
//  DULoopBannerView.m
//  DULoopBannerSample
//
//  Created by dreamer on 15/12/18.
//  Copyright © 2015年 Xiao Du. All rights reserved.
//

#import "DULoopBannerView.h"
#import "UIImageView+setImage.h"
#import "View+MASAdditions.h"

static CGFloat IMAGE_INSET = 5;
static UIViewContentMode const IMAGE_COTENT_MODE = UIViewContentModeScaleAspectFit;
static NSInteger const TAG_IMAGE_START = 50000;

@interface DULoopBannerView () <UIScrollViewDelegate>

@property (nonatomic) NSMutableArray<UIImageView *> *images;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) CGFloat lastScrollOffset;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic) BOOL loopOn;

@end

@implementation DULoopBannerView

- (instancetype)initWithFrame:(CGRect)frame withBannerData:(NSArray *)bannerData {
    return [[DULoopBannerView alloc] initWithFrame:frame withBannerData:bannerData withScrollViewWidth:frame.size.width / 2];
}

- (instancetype)initWithFrame:(CGRect)frame withBannerData:(NSArray *)bannerData withScrollViewWidth:(CGFloat)width {
    return [[DULoopBannerView alloc] initWithFrame:frame withBannerData:bannerData withScrollViewWidth:width imageTapCallback:nil];
}

- (instancetype)initWithFrame:(CGRect)frame withBannerData:(NSArray *)bannerData withScrollViewWidth:(CGFloat)width imageTapCallback:(DUImageTapCallback)callback {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupScrollViewWithWidth:width];
        [self setupPageControl];
        self.backgroundColor = [UIColor grayColor];
        self.bannerData = bannerData;
        self.tapCallback = callback;
    }
    
    return self;
}

- (void)setBannerData:(NSArray *)bannerData {
    _bannerData = bannerData;
    [self setupImage];
}

- (void)setupScrollViewWithWidth:(CGFloat)width {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((self.frame.size.width - width) / 2, 0, width, self.frame.size.height)];
    self.scrollView.clipsToBounds = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.lastScrollOffset = 0;
    [self addSubview:self.scrollView];
}

- (void)setupPageControl {
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
    self.pageControl.frame = CGRectMake(0, self.frame.size.height - self.pageControl.frame.size.height, self.pageControl.frame.size.width, self.pageControl.frame.size.height);
    self.pageControl.hidesForSinglePage = YES;
    [self addSubview:self.pageControl];
}

- (void)setupImage {
    if (self.bannerData.count == 0) {
        return;
    }
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }

    if (self.bannerData.count < 3)
    {
        [self setupNormalImage];
    }
    else {
        [self setupLoopImage];
    }
    self.pageControl.numberOfPages = self.bannerData.count;
    self.currentPage = 0;

}

- (void)setupLoopImage {
    self.loopOn = YES;
    CGFloat imageWidth = self.scrollView.frame.size.width - IMAGE_INSET;
    CGFloat imageLeft = (imageWidth + IMAGE_INSET) * 2;
    self.images = [NSMutableArray array];
    for (NSInteger index = 0; index < self.bannerData.count; ++index) {
        UIImageView *imageView = [UIImageView new];
        [imageView setImageWithName:self.bannerData[index]];
        imageView.contentMode = IMAGE_COTENT_MODE;
        [self.scrollView addSubview:imageView];
        imageView.frame = CGRectMake(imageLeft, 0, imageWidth, self.frame.size.height);
        imageLeft = imageView.frame.size.width + imageView.frame.origin.x + IMAGE_INSET;
        [self.images addObject:imageView];

        //add gesture
        imageView.tag = TAG_IMAGE_START + index;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loopImageTapped:)];
        [imageView addGestureRecognizer:tapGestureRecognizer];
    }

    //add last image to the first place
    UIImageView *lastImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth + IMAGE_INSET, 0, imageWidth, self.frame.size.height)];
    [lastImage setImageWithName:self.bannerData[self.bannerData.count - 1]];
    lastImage.contentMode = IMAGE_COTENT_MODE;
    [self.images insertObject:lastImage atIndex:0];
    [self.scrollView addSubview:lastImage];
    //add gesture
    lastImage.userInteractionEnabled = YES;
    lastImage.tag = TAG_IMAGE_START + self.bannerData.count - 1;
    UITapGestureRecognizer *lastImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loopImageTapped:)];
    [lastImage addGestureRecognizer:lastImageTap];

    UIImageView *secondLastImage =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, self.frame.size.height)];
    [secondLastImage setImageWithName:self.bannerData[self.bannerData.count - 2]];
    secondLastImage.contentMode = IMAGE_COTENT_MODE;
    [self.images insertObject:secondLastImage atIndex:0];
    [self.scrollView addSubview:secondLastImage];
    //add gesture
    secondLastImage.userInteractionEnabled = YES;
    secondLastImage.tag = TAG_IMAGE_START + self.bannerData.count - 2;
    UITapGestureRecognizer *secondLastImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loopImageTapped:)];
    [secondLastImage addGestureRecognizer:secondLastImageTap];

    //add first image to the last place
    UIImageView *firstImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageLeft, 0, imageWidth, self.frame.size.height)];
    [firstImage setImageWithName:self.bannerData[0]];
    firstImage.contentMode = IMAGE_COTENT_MODE;
    [self.scrollView addSubview:firstImage];
    [self.images addObject:firstImage];
    //add gesture
    firstImage.userInteractionEnabled = YES;
    firstImage.tag = TAG_IMAGE_START;
    UITapGestureRecognizer *firstImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loopImageTapped:)];
    [firstImage addGestureRecognizer:firstImageTap];

    UIImageView *secondImage = [[UIImageView alloc] initWithFrame:CGRectMake(firstImage.frame.origin.x + firstImage.frame.size.width + IMAGE_INSET, 0, imageWidth, self.scrollView.frame.size.height)];
    [secondImage setImageWithName:self.bannerData[1]];
    secondImage.contentMode = IMAGE_COTENT_MODE;
    [self.scrollView addSubview:secondImage];
    [self.images addObject:secondImage];
    //add gesture
    secondImage.userInteractionEnabled = YES;
    secondImage.tag = TAG_IMAGE_START + 1;
    UITapGestureRecognizer *secondImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loopImageTapped:)];
    [secondImage addGestureRecognizer:secondImageTap];

    self.scrollView.contentSize = CGSizeMake((imageWidth + IMAGE_INSET) * (self.bannerData.count + 4), self.frame.size.height);
    self.scrollView.contentOffset = CGPointMake((imageWidth + IMAGE_INSET) * 2,0);
}

- (void)setupNormalImage{
    CGFloat imageWidth = self.scrollView.frame.size.width - IMAGE_INSET;
    CGFloat imageLeft = 0;
    self.images = [NSMutableArray array];
    for (NSInteger index = 0; index < self.bannerData.count; ++index) {
        UIImageView *imageView = [UIImageView new];
        [imageView setImageWithName:self.bannerData[index]];
        imageView.contentMode = IMAGE_COTENT_MODE;
        [self.scrollView addSubview:imageView];
        imageView.frame = CGRectMake(imageLeft, 0, imageWidth, self.frame.size.height);
        imageLeft = imageView.frame.size.width + imageView.frame.origin.x + IMAGE_INSET;
        [self.images addObject:imageView];

        //add gesture
        imageView.tag = index + TAG_IMAGE_START;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(normalImageTapped:)];
        [imageView addGestureRecognizer:tapGestureRecognizer];
    }

    self.scrollView.contentSize = CGSizeMake((imageWidth + IMAGE_INSET) * self.bannerData.count, self.frame.size.height);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *child = [super hitTest:point withEvent:event];
    if (child == self) {
        if (self.alpha == 0.0 || self.hidden || !self.userInteractionEnabled)
        {
            return nil;
        }
        return self.scrollView;
    }
    
    return child;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageSize = scrollView.frame.size.width;
    CGFloat currentScrollOffset = scrollView.contentOffset.x;
    CGFloat rightCriticalOffset = pageSize * (self.images.count - 2);
    CGFloat leftCriticalOffset = pageSize;
    NSInteger currentPage = (NSInteger)((scrollView.contentOffset.x + (0.5f * scrollView.width)) / scrollView.frame.size.width) - 2;
    if (currentPage < 0) {
        currentPage = self.bannerData.count - currentPage;
    }
    else if (currentPage > self.bannerData.count - 1) {
        currentPage -= self.bannerData.count;
    }
    self.pageControl.currentPage = currentPage;
    if (!self.loopOn) {
        return;
    }
    if (currentScrollOffset - self.lastScrollOffset > 0 && currentScrollOffset > rightCriticalOffset) {
        //scroll to right
        [scrollView scrollRectToVisible:CGRectMake(currentScrollOffset - self.bannerData.count * pageSize,0,pageSize,self.scrollView.frame.size.height) animated:NO];
    }
    else if (currentScrollOffset - self.lastScrollOffset < 0 && currentScrollOffset < leftCriticalOffset){
        //scroll to left
        [scrollView scrollRectToVisible:CGRectMake(currentScrollOffset + self.bannerData.count * pageSize, 0, pageSize, self.scrollView.frame.size.height) animated:NO];
    }
    
    self.lastScrollOffset = currentScrollOffset;
}

- (void)normalImageTapped:(UITapGestureRecognizer *)sender {
    if (self.tapCallback && sender.view.tag >= TAG_IMAGE_START) {
        NSInteger index = sender.view.tag - TAG_IMAGE_START;
        self.tapCallback(index, self.bannerData[index]);
    }
}

- (void)loopImageTapped:(UITapGestureRecognizer *)sender {
    if (self.tapCallback && sender.view.tag >= TAG_IMAGE_START) {
        NSInteger index = sender.view.tag - TAG_IMAGE_START;
        self.tapCallback(index, self.bannerData[index]);
    }
}

@end
