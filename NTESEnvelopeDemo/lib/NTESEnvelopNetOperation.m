//
//  NTESEnvelopNetOperation.m
//  NTESEnvelopeDemo
//
//  Created by kk on 15/4/20.
//  Copyright (c) 2015年 Luigi. All rights reserved.
//

#import "NTESEnvelopKit.h"

@interface NTESEnvelopNetOperation ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property (strong, nonatomic) NSURLConnection *connection;

@property (strong, nonatomic,readwrite) NSMutableURLRequest   *request;
@property (strong, nonatomic,readwrite) NSHTTPURLResponse     *response;
@property (strong, nonatomic,readwrite) NSMutableDictionary   *postParaDic;


@property(assign,nonatomic) BOOL isCancelled;
@property (strong, nonatomic) NSMutableData *mutableData;
@property (assign, nonatomic) NSUInteger downloadedDataSize;
@property (nonatomic, assign) NSInteger startPosition;




@property(assign,nonatomic,readwrite)NTESEnvelopOperationState operationState;


@property(copy,nonatomic)NTESEnvelopProgressBlock progressBlock;
@property(copy,nonatomic)NTESEnvelopResponseBlock responseBlock;
@property(copy,nonatomic)NTESEnvelopErrorBlock errorBlock;
@property(copy,nonatomic)NTESEnvelopResponseErrorBlock responseErrorBlock;

#if TARGET_OS_IPHONE
@property(nonatomic,assign)UIBackgroundTaskIdentifier backgroundTaskId;
#endif


@end

@implementation NTESEnvelopNetOperation
-(instancetype)copyWithZone:(NSZone *)zone{
    NTESEnvelopNetOperation *theCopy  =[[NTESEnvelopNetOperation allocWithZone:zone] init];
    [theCopy setConnection:[self.connection copy]];
    [theCopy setRequest:[self.request copy]];
    [theCopy setResponse:[self.response copy]];
    [theCopy setPostParaDic:[self.postParaDic copy]];
    [theCopy setIsCancelled:self.isCancelled];
    
    [theCopy setMutableData:[self.mutableData copy]];
    [theCopy setDownloadedDataSize:self.downloadedDataSize];
    [theCopy setStartPosition:self.startPosition];
    //[theCopy setServerTrust:[[self.serverTrust copy]];
    [theCopy setOperationState:self.operationState];
    [theCopy setProgressBlock:[self.progressBlock copy]];
    [theCopy setResponseBlock:[self.responseBlock copy]];
    [theCopy setErrorBlock:[self.errorBlock copy]];
    [theCopy setResponseErrorBlock:[self.responseErrorBlock copy]];
    
    
    return theCopy;
}
-(instancetype)mutableCopyWithZone:(NSZone *)zone{
    NTESEnvelopNetOperation *theCopy  =[[NTESEnvelopNetOperation allocWithZone:zone] init];
    [theCopy setConnection:[self.connection mutableCopy]];
    [theCopy setRequest:[self.request mutableCopy]];
    [theCopy setResponse:[self.response mutableCopy]];
    [theCopy setPostParaDic:[self.postParaDic mutableCopy]];
    [theCopy setIsCancelled:self.isCancelled];
    
    [theCopy setMutableData:[self.mutableData mutableCopy]];
    [theCopy setDownloadedDataSize:self.downloadedDataSize];
    [theCopy setStartPosition:self.startPosition];
    //[theCopy setServerTrust:[[self.serverTrust copy]];
    [theCopy setOperationState:self.operationState];
    [theCopy setProgressBlock:[self.progressBlock mutableCopy]];
    [theCopy setResponseBlock:[self.responseBlock mutableCopy]];
    [theCopy setErrorBlock:[self.errorBlock mutableCopy]];
    [theCopy setResponseErrorBlock:[self.responseErrorBlock mutableCopy]];
    
    return theCopy;
}

-(void)dealloc{
    [_connection cancel];
    _connection=nil;
}

#pragma nark- MianMethod
-(void)main{
    @autoreleasepool {
        [self start];
    }
}
-(void) endBackgroundTask {
#if TARGET_OS_IPHONE
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
            self.backgroundTaskId = UIBackgroundTaskInvalid;
        }
    });
#endif
}
-(void)start{
#if TARGET_OS_IPHONE
    self.backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.backgroundTaskId != UIBackgroundTaskInvalid){
                [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
                self.backgroundTaskId = UIBackgroundTaskInvalid;
                [self cancel];
            }
        });
    }];
#endif
    if (!self.isCancelled) {
        if (([self.request.HTTPMethod isEqualToString:@"POST"]||[self.request.HTTPMethod isEqualToString:@"PUT"]||[self.request.HTTPMethod isEqualToString:@"PACH"])&& !self.request.HTTPBodyStream) {
            [self.request setHTTPBody:[self bodyData]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.connection=[[NSURLConnection alloc]  initWithRequest:self.request delegate:self startImmediately: NO];
            [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            [self.connection start];
        });
        self.operationState=NTESEnvelopOperationStateExecuting;
    }else{
        self.operationState=NTESEnvelopOperationStateFinished;
        [self endBackgroundTask];
    }
}
#pragma mark -GetterMethod
-(NSString *)url{
    return _request.URL.absoluteString;
}
-(NSMutableURLRequest *)request{
    return _request;
}
-(NSHTTPURLResponse *)readonlyResponse{
    return _response;
}
-(NSString *)uniqueId{
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@ %@", self.request.HTTPMethod, self.url];
    return [str netEase_md5];
}


-(void)setOperationState:(NTESEnvelopOperationState)operationState{
    
    switch (operationState) {
        case NTESEnvelopOperationStateReady:{
            [self willChangeValueForKey:@"isReady"];
        }
            break;
        case NTESEnvelopOperationStateExecuting:{
            [self willChangeValueForKey:@"isReady"];
            [self willChangeValueForKey:@"isExecuting"];
        }break;
        case NTESEnvelopOperationStateFinished:{
            [self willChangeValueForKey:@"isExecuting"];
            [self willChangeValueForKey:@"isFinished"];
        }break;
        default:
            break;
    }
    _operationState=operationState;
    switch (operationState) {
        case NTESEnvelopOperationStateReady:{
            [self didChangeValueForKey:@"isReady"];
        }
            break;
        case NTESEnvelopOperationStateExecuting:{
            [self didChangeValueForKey:@"isReady"];
            [self didChangeValueForKey:@"isExecuting"];
        }break;
        case NTESEnvelopOperationStateFinished:{
            [self didChangeValueForKey:@"isExecuting"];
            [self didChangeValueForKey:@"isFinished"];
        }break;
        default:
            break;
    }
    
}
#pragma mark -setterMethod
-(void)setPostDataEncoding:(NTESEnvelopPostDataEncodingType)postDataEncoding{
    _postDataEncoding=postDataEncoding;
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(self.stringEncoding));
    switch (self.postDataEncoding) {
        case NTESEnvelopPostDataEncodingTypeURL:{
            [self.request setValue:
             [NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset]
                forHTTPHeaderField:@"Content-Type"];
        }
            break;
        case NTESEnvelopPostDataEncodingTypeJSON:{
            [self.request setValue:
             [NSString stringWithFormat:@"application/json; charset=%@", charset]
                forHTTPHeaderField:@"Content-Type"];
        }
            break;
        case NTESEnvelopPostDataEncodingTypePlist:{
            [self.request setValue:
             [NSString stringWithFormat:@"application/x-plist; charset=%@", charset]
                forHTTPHeaderField:@"Content-Type"];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark- NSOperation stuff
- (BOOL)isConcurrent{
    return YES;
}
-(BOOL) isReady{
    return (self.operationState== NTESEnvelopOperationStateReady&& [super isReady]);
}
-(BOOL) isFinished{
    if (self.operationState == NTESEnvelopOperationStateFinished) {
        return YES;
    }else{
        return NO;
    }
}
-(BOOL) isExecuting{
    return  (self.operationState==NTESEnvelopOperationStateExecuting);
}
-(void)cancel{
    if ([self isCancelled]) {
        return;
    }
    @synchronized(self){
        self.isCancelled=YES;
        [self.connection cancel];
        self.responseBlock=nil;
        self.responseErrorBlock=nil;
        self.errorBlock=nil;
        if (self.operationState==NTESEnvelopOperationStateExecuting) {
            self.operationState = NTESEnvelopOperationStateFinished;
        }
        [self endBackgroundTask];
    }
    [super cancel];
}

- (instancetype)initWithURLString:(NSString *)aURLString
                           params:(NSDictionary *)params
                       httpMethod:(NSString *)method{
    self=[super init];
    if (self) {
        NSURL *finalURL = nil;
        self.postParaDic=[NSMutableDictionary dictionary];
        
        if (params) {
            self.postParaDic=[params copy];
        }
        self.stringEncoding = NSUTF8StringEncoding; // use a delegate to get these values later
        
        if (nil==method||[method isEqualToString:@""]) {
            method=@"GET";
        }
        if (([method isEqualToString:@"GET"]||[method isEqualToString:@"DELETE"])&&(params&&[params count])) {
            finalURL=[NSURL URLWithString:[NSString  stringWithFormat:@"%@?%@",aURLString,[self.postParaDic  netEaseUrlEncodedKeyValueString]]];
        }else{
            finalURL=[NSURL URLWithString:aURLString];
        }
        if(finalURL == nil) {
            DLog(@"Cannot create a URL with %@ and parameters %@ and method %@", aURLString, self.postParaDic, method);
            return nil;
        }
        self.request = [NSMutableURLRequest requestWithURL:finalURL
                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                           timeoutInterval:NTESEnvelopKitRequestTimeOutInSeconds];
        
        [self.request setHTTPMethod:method];
        
        if (([method isEqualToString:@"POST"] ||
             [method isEqualToString:@"PUT"]) && (params && [params count] > 0)) {
            self.postDataEncoding = NTESEnvelopPostDataEncodingTypeURL;
        }
        self.operationState=NTESEnvelopOperationStateReady;
    }
    return self;
}
-(NSData *)bodyData{
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSMutableData *body = [NSMutableData data];
    [self.postParaDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *thisFieldString = [NSString stringWithFormat:
                                     @"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@",
                                     boundary, key, obj];
        
        [body appendData:[thisFieldString dataUsingEncoding:[self stringEncoding]]];
        [body appendData:[@"\r\n" dataUsingEncoding:[self stringEncoding]]];
    }];
    [body appendData: [[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:self.stringEncoding]];
    
    return body;
}





-(void) addHeaders:(NSDictionary*) headersDictionary{
    [headersDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.request addValue:obj forHTTPHeaderField:key];
    }];
}


-(void) onCompletionHandler:( NTESEnvelopResponseBlock) response onErrorHandler:(NTESEnvelopErrorBlock) error {
    self.responseBlock=[response copy];
    self.errorBlock=[error copy];
}
-(void)onDownloadProgressChangedHandler:(NTESEnvelopProgressBlock)downloadProgressBlock  completionHandler:(NTESEnvelopResponseBlock)response
                            errorHander:(NTESEnvelopErrorBlock)error{
    self.progressBlock=[downloadProgressBlock copy];
    self.responseBlock=[response copy];
    self.errorBlock=[error copy];
}
#pragma  mark - OperationTool
-(NSData *)responseData{
    if ([self isFinished]) {
        return  self.mutableData;
    }else{
        return nil;
    }
}
-(NSString *)responseString{
    return [[NSString alloc]  initWithData:[self responseData] encoding:self.stringEncoding];
}
-(NSDictionary *)responseDictiory{
    if ([self responseData]==nil) {
        return nil;
    }else{
        NSError *error=nil;
        NSDictionary *returnDic=[NSJSONSerialization JSONObjectWithData:[self responseData] options:0 error:&error];
        if (error) {
            DLog(@"Json Parsing Error : %@",error);
        }
        return returnDic;
    }
}

#pragma  mark - NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    self.operationState=NTESEnvelopOperationStateFinished;
    self.mutableData=nil;
    self.downloadedDataSize=0;
    if (self.errorBlock) {
        self.errorBlock(error);
    }
    [self endBackgroundTask];
}
-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    //1)获取trust object
    SecTrustRef trust = challenge.protectionSpace.serverTrust;
    SecTrustResultType result;
    //2)SecTrustEvaluate对trust进行验证
    OSStatus status = SecTrustEvaluate(trust, &result);
    if (status == errSecSuccess &&
        (result == kSecTrustResultProceed ||
         result == kSecTrustResultUnspecified)) {
            //3)验证成功，生成NSURLCredential凭证cred，告知challenge的sender使用这个凭证来继续连接
            NSURLCredential *cred = [NSURLCredential credentialForTrust:trust];
            [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
        } else {
            //5)验证失败，取消这次验证流程
            [challenge.sender cancelAuthenticationChallenge:challenge];
        }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSUInteger size=(NSUInteger )[self.response expectedContentLength];
    self.response=(NSHTTPURLResponse *)response;
    self.mutableData=[NSMutableData dataWithCapacity:size];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (self.downloadedDataSize == 0) {
        // This is the first batch of data
        // Check for a range header and make changes as neccesary
        NSString *rangeString = [[self request] valueForHTTPHeaderField:@"Range"];
        if ([rangeString hasPrefix:@"bytes="] && [rangeString hasSuffix:@"-"]) {
            NSString *bytesText = [rangeString substringWithRange:NSMakeRange(6, [rangeString length] - 7)];
            self.startPosition = [bytesText integerValue];
            self.downloadedDataSize = self.startPosition;
            DLog(@"Resuming at %lu bytes", (unsigned long) self.startPosition);
        }
    }
    [self.mutableData  appendData:data];
    self.downloadedDataSize+=data.length;
    if (self.response.expectedContentLength) {
        double progress=(double)self.downloadedDataSize /(double)(self.response.expectedContentLength +self.startPosition);
        if (self.progressBlock) {
            self.progressBlock(progress);
        }
        
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (self.isCancelled) {
        return ;
    }
    self.operationState=NTESEnvelopOperationStateFinished;
    if (self.response.statusCode >= 200 && self.response.statusCode <300 && !self.isCancelled) {
        if (self.responseBlock) {
            self.responseBlock(self);
        }
    }else{
        if (self.errorBlock) {
            self.errorBlock([NSError errorWithDomain:NSURLErrorDomain code:self.response.statusCode userInfo:self.response.allHeaderFields]);
        }
    }
}
@end
