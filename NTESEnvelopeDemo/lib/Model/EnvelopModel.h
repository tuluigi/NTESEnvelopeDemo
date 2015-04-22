//
//  EnvelopModel.h
//  NTESEnvelopeDemo
//
//  Created by kk on 15/4/20.
//  Copyright (c) 2015年 Luigi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  小红包实体对象类
 */
@interface EnvelopModel : NSObject
@property(nonatomic,copy)NSString *envelopID;//红包ID

@property(nonatomic,strong)NSDecimalNumber *envelopAmount;//红包金额


@property(nonatomic,copy)NSString *ownerID;//所有者ID
@property(nonatomic,copy)NSString *ownerName;//所有者名称
@property(nonatomic,copy)NSString *ownerImgUrl;//所有者头像
@end
