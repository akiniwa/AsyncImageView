//
//  AsyncImageView.m
//
//  Created by Shinya Akiba on 13/09/22.
//  Copyright (c) 2013年 Shinya Akiba. All rights reserved.
//

#import "AsyncImageView.h"
#import "HttpClient.h"
#import "ImageLoader.h"

@implementation AsyncImageView
{
    UIActivityIndicatorView *activity;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setImageWithUrl:(NSString*)imageUrl {
    ImageLoader* imageLoader = [ImageLoader sharedInstance];
    UIImage *jacketImage = [imageLoader cacedImageForUrl:imageUrl];
    [self setImage:jacketImage];

    if (!jacketImage) {
        activity = [self activityIndicator];
        [self addSubview:activity];
        [activity startAnimating];
        
        __weak AsyncImageView *_self = self;
        [imageLoader loadImage:imageUrl completion:^(UIImage *image) {
            [_self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
        }];
    }
}

- (void)setImage:(UIImage *)image {
    [super setImage:image];
    [activity stopAnimating];
}

- (UIActivityIndicatorView*)activityIndicator {
    CGRect r = self.frame;
    activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height)];
    [activity setBackgroundColor:[UIColor clearColor]];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activity hidesWhenStopped];
    return activity;
}

@end
