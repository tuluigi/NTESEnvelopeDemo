//
//  UIImageView+NTESHb.h
//  NetEaseHongBao
//
//  Created by kk on 15/4/17.
//  Copyright (c) 2015年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NetEaseWebImageDownloadProgressBlock)(double progress);
typedef void (^NetEaseWebImageDownloadCompletionBlock)(UIImage *image, NSData *data ,NSError *error , BOOL finished);
@interface UIImageView (NTESHb)

-(NSString *)netEase_ImageUrl;

-(void)netEase_setImageWithURL:(NSString *)url placeHolerImage:(UIImage *)placeholerImage;

-(void)netEase_setImageWithURL:(NSString *)url placeHolerImage:(UIImage *)placeHolerImage progress:(NetEaseWebImageDownloadProgressBlock)progressBlock completionHander:(NetEaseWebImageDownloadCompletionBlock)completionBlock;
@end
