//
//  NTESEnvelopNetEngine.m
//  NTESEnvelopeDemo
//
//  Created by kk on 15/4/20.
//  Copyright (c) 2015年 Luigi. All rights reserved.
//

#import "NTESEnvelopKit.h"

@interface NTESEnvelopNetEngine ()
@property (assign, nonatomic) Class customOperationSubclass;
@property (strong, nonatomic) dispatch_queue_t operationQueue;

@end


static NSOperationQueue *_sharedNetworkQueue;
@implementation NTESEnvelopNetEngine

#pragma mark Initialization
+(void) initialize {
    if(!_sharedNetworkQueue) {
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            _sharedNetworkQueue = [[NSOperationQueue alloc] init];
            [_sharedNetworkQueue addObserver:[self self] forKeyPath:@"operationCount" options:0 context:NULL];
            //[_sharedNetworkQueue setMaxConcurrentOperationCount:6];
        });
    }
}
-(void)dealloc{
}
+(instancetype )sharedNetWorkEngine{
    static NTESEnvelopNetEngine *sharedNetEaseEngine;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedNetEaseEngine=[[NTESEnvelopNetEngine alloc]  init];
    });
    return sharedNetEaseEngine;
}
- (id) init {
    self=[super init];
    if (self) {
        self.operationQueue=dispatch_queue_create("com.NetEaseHongBao.Operation", DISPATCH_QUEUE_SERIAL);
        NSMutableDictionary *newHeadersDict = [NSMutableDictionary dictionary];
        NSString *userAgentString = [NSString stringWithFormat:@"%@/%@",
                                     [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleNameKey],
                                     [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleVersionKey]];
        newHeadersDict[@"User-Agent"] = userAgentString;
        self.customOperationSubclass = [NTESEnvelopNetOperation class];
    }
    return self;
}



#pragma mark -kVC
+ (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                         change:(NSDictionary *)change context:(void *)context{
    if (object == _sharedNetworkQueue && [keyPath isEqualToString:@"operationCount"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESEnvelopEngineOperationCountChanged object:[NSNumber numberWithInteger:[_sharedNetworkQueue operationCount]]];
#ifdef TARGET_OS_IPHONE
        [UIApplication sharedApplication].networkActivityIndicatorVisible=([_sharedNetworkQueue.operations count]>0);
#endif
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}


#pragma mark -enqueue
-(void) enqueueOperation:(NTESEnvelopNetOperation*) operation {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NTESEnvelopNetOperation *itemOperation  in _sharedNetworkQueue.operations ) {
            if ([itemOperation.uniqueId isEqualToString:operation.uniqueId]) {
                [operation cancel];
            }
        }
        
        [_sharedNetworkQueue addOperation:operation];
    });
}
@end
