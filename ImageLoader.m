//
//  ImageLoader.m
//  NSCacheTest
//
//  Created by Asano Satoshi on 3/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageLoader.h"

@interface ImageLoader () {
    NSOperationQueue *_networkQueue;
    NSCache *_imageCache;
    NSCache *_requestingUrls;
}
@end

@implementation ImageLoader 

+(id)sharedInstance {
    static ImageLoader *loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[self alloc] init];
    });
    return loader;
}

-(id)init {
    self = [super init];
    if (self) {
        _networkQueue = [[NSOperationQueue alloc] init];
        _requestingUrls = [[NSCache alloc] init];
        
        _imageCache = [[NSCache alloc] init];
    }
    return self;
}

-(UIImage *)cacedImageForUrl:(NSString *)imageUrl {
    return [_imageCache objectForKey:imageUrl];
}

-(void)loadImage:(NSString *)imageUrl completion:(void(^)(UIImage *image))completion {
    [_requestingUrls setObject:@"lock" forKey:imageUrl];

    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:20];

    NSCache *weakedImageCache = _imageCache;
    NSCache *weakedRequestingUrl = _requestingUrls;

    [NSURLConnection sendAsynchronousRequest:req queue:_networkQueue completionHandler:^(NSURLResponse *res, NSData *imageData, NSError *error) {
        if (imageData) {
            UIImage *image = [UIImage imageWithData:imageData];
            
            [weakedImageCache setObject:image forKey:imageUrl];
            
            [weakedRequestingUrl removeObjectForKey:imageUrl];
            completion(image);
        } else {
            completion(nil);
        }

    }];     
}


@end
