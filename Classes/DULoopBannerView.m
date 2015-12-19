//
//  DULoopBannerView.m
//  DULoopBannerSample
//
//  Created by dreamer on 15/12/18.
//  Copyright © 2015年 Xiao Du. All rights reserved.
//

#import "DULoopBannerView.h"
#import "UIImageView+setImage.h"

static UIViewContentMode const IMAGE_COTENT_MODE = UIViewContentModeScaleAspectFit;

@interface DULoopBannerView () <UIScrollViewDelegate>

@property (nonatomic) NSMutableArray *images;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger lastPage;

@end

@implementation DULoopBannerView

- (void)setBannerData:(NSArray *)bannerData {
    _bannerData = bannerData;
    [self setupView];
}

- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)images {
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.bannerData = images;
        self.delegate = self;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pagingEnabled = YES;
}


- (void)setupView {
    if (self.bannerData.count == 0) {
        return;
    }
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    CGFloat imageWidth = self.frame.size.width / 2;
    CGFloat imaegLeft = imageWidth / 2;
    for (NSInteger index = 0; index < self.bannerData.count; ++index) {
        UIImageView *imageView = [UIImageView new];
        [imageView setImageWithName:self.bannerData[index]];
        imageView.contentMode = IMAGE_COTENT_MODE;
        [self addSubview:imageView];
        imageView.frame = CGRectMake(imaegLeft, 0, imageWidth, self.frame.size.height);
        imaegLeft = imageView.frame.size.width + imageView.frame.origin.x;
        [self.images addObject:imageView];
    }

    //add last image to the first place
    UIImageView *lastImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth / -2,0,imageWidth,self.frame.size.height)];
    [lastImage setImageWithName:self.bannerData[self.bannerData.count - 1]];
    lastImage.contentMode = IMAGE_COTENT_MODE;
    [self.images insertObject:lastImage atIndex:0];
    [self addSubview:lastImage];

    //add first image to the last place
    UIImageView *firstImage = [[UIImageView alloc] initWithFrame:CGRectMake(imaegLeft, 0, imageWidth, self.frame.size.height)];
    [firstImage setImageWithName:self.bannerData[0]];
    firstImage.contentMode = IMAGE_COTENT_MODE;
    [self.images addObject:firstImage];
    [self addSubview:firstImage];
    self.contentSize = CGSizeMake(imageWidth * (self.bannerData.count + 2),self.frame.size.height);
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    self.currentPage =
//}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat kMaxIndex = 23;
    CGFloat targetX = scrollView.contentOffset.x + velocity.x * 60.0;
    CGFloat targetIndex = round(targetX / scrollView.frame.size.width / 2);
    if (targetIndex < 0)
        targetIndex = 0;
    if (targetIndex > kMaxIndex)
        targetIndex = kMaxIndex;
    targetContentOffset->x = targetIndex * scrollView.frame.size.width / 2;
}

@end
