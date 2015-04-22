//
//  UIImageView+NTESEnvelop.m
//  NetEaseHongBao
//
//  Created by kk on 15/4/17.
//  Copyright (c) 2015年 Luigi. All rights reserved.
//

#import "UIImageView+NetEaseHB.h"
#import "objc/runtime.h"
#import "NTESEnvelopNetEngine.h"
#import "NTESEnvelopNetOperation.h"
static char NetEaseUIImageURLKey;

@implementation UIImageView (NTESEnvelop)
-(NSString *)netEase_ImageUrl{
    return objc_getAssociatedObject(self, &NetEaseUIImageURLKey);
}

-(void)netEase_setImageWithURL:(NSString *)url placeHolerImage:(UIImage *)placeholerImage{
    [self netEase_setImageWithURL:url placeHolerImage:placeholerImage progress:nil completionHander:nil];
}

-(void)netEase_setImageWithURL:(NSString *)url placeHolerImage:(UIImage *)placeHolerImage progress:(NetEaseWebImageDownloadProgressBlock)progressBlock completionHander:(NetEaseWebImageDownloadCompletionBlock)completionBlock{
    objc_setAssociatedObject(self, &NetEaseUIImageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (placeHolerImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
              self.image=placeHolerImage;
        });
    }
    if (url) {
        __weak  __typeof (self) weakSelf= self;
        NTESEnvelopNetOperation *operation=[[NTESEnvelopNetOperation alloc]  initWithURLString:url params:nil httpMethod:@"GET"];
        [operation onDownloadProgressChangedHandler:^(double opProgress) {
            
        } completionHandler:^(NTESEnvelopNetOperation *completedOperation) {
            NSData *data=[completedOperation responseData];
            dispatch_async(dispatch_get_main_queue(), ^{
              weakSelf.image=[UIImage imageWithData:data];
            });
        } errorHander:^(NSError *error) {
            weakSelf.image=placeHolerImage;
        }];
        [[NTESEnvelopNetEngine sharedNetWorkEngine]  enqueueOperation:operation];
    }
}
@end
