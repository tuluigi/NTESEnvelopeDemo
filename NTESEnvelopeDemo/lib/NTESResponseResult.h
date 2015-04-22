//
//  NTESResponseResult.h
//  NTESEnvelopDemo
//
//  Created by kk on 15/4/20.
//  Copyright (c) 2015年 Luigi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTESResponseResult : NSObject
@property(nonatomic,assign) NSInteger responseCode;
@property(nonatomic,copy)   NSString *responseMessage;
@property(nonatomic,strong) id        responseData;
@end
