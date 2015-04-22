//
//  BigEnvelopModel.h
//  NTESEnvelopeDemo
//
//  Created by kk on 15/4/20.
//  Copyright (c) 2015年 Luigi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  大红包实体对象类
 */
@interface BigEnvelopModel : NSObject
@property(nonatomic,copy)NSString *bigEnvelopID;
@property(nonatomic,copy)NSString *activityID;
@property(nonatomic,copy)NSString *activityTitle;
@property(nonatomic,copy)NSString *activityDesc;
@property(nonatomic,copy)NSString *activityLogo;

@property(nonatomic,strong)NSDecimalNumber *totalAmount;//大红包总的金额
@property(nonatomic,assign)NSInteger totoalCount;//小红包总数
@property(nonatomic,assign)NSInteger grabCount;//已经抢的人数

@property(nonatomic,strong)NSMutableArray *envelopListArray;//小红包的arry
@end
