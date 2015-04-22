//
//  NTESEnvelopNetOperation.h
//  NTESEnvelopeDemo
//
//  Created by kk on 15/4/20.
//  Copyright (c) 2015年 Luigi. All rights reserved.
//


@class NTESEnvelopNetOperation;
@class NTESResponseResult;

typedef void(^NTESEnvelopProgressBlock) (double opProgress);
typedef void(^NTESEnvelopResponseBlock)(NTESEnvelopNetOperation *completedOperation);
typedef void(^NTESEnvelopResponseErrorBlock)(NTESEnvelopNetOperation *completedOperation, NSError *error);
typedef void(^NTESEnvelopErrorBlock)(NSError *error);

typedef void(^NTESEnvelopResponseResultBlock)(NTESResponseResult *responseResult);

typedef NS_ENUM(NSInteger, NTESEnvelopPostDataEncodingType){
    NTESEnvelopPostDataEncodingTypeURL        =0,//default
    NTESEnvelopPostDataEncodingTypeJSON       ,
    NTESEnvelopPostDataEncodingTypePlist      ,
    NTESEnvelopPostDataEncodingTypeCustome    ,
};

typedef NS_ENUM(NSInteger, NTESEnvelopOperationState){
    NTESEnvelopOperationStateReady            =1,
    NTESEnvelopOperationStateExecuting        ,
    NTESEnvelopOperationStateFinished         ,
};

@interface NTESEnvelopNetOperation : NSOperation
#pragma mark -ReadlonyProperty
@property (nonatomic, copy,   readonly) NSString *url;
@property (nonatomic, strong, readonly) NSMutableURLRequest *request;
@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;
@property (nonatomic, strong, readonly) NSMutableDictionary *postParaDic;
@property (copy,   nonatomic, readonly) NSString *uniqueId;


@property (assign,nonatomic)          NTESEnvelopPostDataEncodingType postDataEncoding;
@property (assign,nonatomic,readonly) NTESEnvelopOperationState operationState;
@property (nonatomic, assign)         NSStringEncoding stringEncoding;

#pragma  mark - initMethod
- (instancetype)initWithURLString:(NSString *)aURLString
                           params:(NSDictionary *)params
                       httpMethod:(NSString *)method;


-(void) addHeaders:(NSDictionary*) headersDictionary;

-(void) onCompletionHandler:( NTESEnvelopResponseBlock) response onErrorHandler:(NTESEnvelopErrorBlock) error ;
-(void)onDownloadProgressChangedHandler:(NTESEnvelopProgressBlock)downloadProgressBlock  completionHandler:(NTESEnvelopResponseBlock)response
                            errorHander:(NTESEnvelopErrorBlock)error;

#pragma  mark - OperationTool
-(NSData *)   responseData;
-(NSString *) responseString;
-(NSDictionary *) responseDictiory;
@end
