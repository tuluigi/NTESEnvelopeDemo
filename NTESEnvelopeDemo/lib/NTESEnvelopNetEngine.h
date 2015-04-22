//
//  NTESEnvelopNetEngine.h
//  NTESEnvelopeDemo
//
//  Created by kk on 15/4/20.
//  Copyright (c) 2015年 Luigi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NTESEnvelopNetOperation;
@interface NTESEnvelopNetEngine : NSObject
#pragma mark - initMethod
+(instancetype )sharedNetWorkEngine;

#pragma mark -enqueue
-(void) enqueueOperation:(NTESEnvelopNetOperation*) operation;
@end
