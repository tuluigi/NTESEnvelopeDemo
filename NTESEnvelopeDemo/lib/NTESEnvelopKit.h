//
//  NTESEnvelopKit.h
//  NTESEnvelopeDemo
//
//  Created by kk on 15/4/20.
//  Copyright (c) 2015年 Luigi. All rights reserved.
//

#ifndef NTESEnvelopeDemo_NTESEnvelopKit_h
#define NTESEnvelopeDemo_NTESEnvelopKit_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NTESEnvelopNetOperation.h"
#import "NTESEnvelopNetEngine.h"
#import "NSDictionary+RequeseEncode.h"
#import "NSString+NetEaseHBKitAdditions.h"
#ifdef DEBUG
#ifndef DLog
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#endif
#ifndef ELog
#   define ELog(err) {if(err) DLog(@"%@", err)}
#endif
#else
#ifndef DLog
#   define DLog(...)
#endif
#ifndef ELog
#   define ELog(err)
#endif
#endif

//超时时间
#define NTESEnvelopKitRequestTimeOutInSeconds 15

//网络请求数量变化
#define NTESEnvelopEngineOperationCountChanged @"NTESEnvelopEngineOperationCountChanged"
#endif
