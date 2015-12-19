//
// Created by dreamer on 15/12/18.
// Copyright (c) 2015 Xiao Du. All rights reserved.
//

#import "UIImageView+setImage.h"
#import <UIImageView+WebCache.h>


@implementation UIImageView (setImage)

- (void)setImageWithName:(NSString *)imageName {
    if ([imageName hasPrefix:@"http://"] || [imageName hasPrefix:@"https://"]) {
        [self sd_setImageWithURL:[NSURL URLWithString:imageName]];
    }
    else {
        self.image = [UIImage imageNamed:imageName];
    }
}

@end