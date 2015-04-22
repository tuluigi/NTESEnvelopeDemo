//
//  ActivityModel.h
//  NTESPacketDemo
//
//  Created by kk on 15/4/20.
//  Copyright (c) 2015年 Luigi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject
@property(nonatomic,copy)NSString *activityID;//活动ID
@property(nonatomic,copy)NSString *activityTitle;//活动标题
@property(nonatomic,copy)NSString *activityLogo;//活动logo
@property(nonatomic,copy)NSString *activityDesc;//活动简介

@property(nonatomic,copy)NSString *activityStartTime;//活动开始时间
@property(nonatomic,copy)NSString *activityEndTime;//结束时间

@end
