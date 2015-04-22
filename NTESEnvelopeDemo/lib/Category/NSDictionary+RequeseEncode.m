//
//  NSDictionary+RequeseEncode.m
//  NetEaseHongBao
//
//  Created by kk on 15/4/13.
//  Copyright (c) 2015年 Luigi. All rights reserved.
//
#import "NTESEnvelopKit.h"

@implementation NSDictionary (RequeseEncode)
-(NSString*) netEaseUrlEncodedKeyValueString{
    NSMutableString *string = [NSMutableString string];
    for (NSString *key in self) {
        
        NSObject *value = [self valueForKey:key];
        if([value isKindOfClass:[NSString class]])
            [string appendFormat:@"%@=%@&", [key netEase_urlEncodedString], [((NSString*)value) netEase_urlEncodedString]];
        else
            [string appendFormat:@"%@=%@&", [key netEase_urlEncodedString], value];
    }
    
    if([string length] > 0)
        [string deleteCharactersInRange:NSMakeRange([string length] - 1, 1)];
    
    return string;
}
-(NSString*) netEaseJsonEncodedKeyValueString{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:0 // non-pretty printing
                                                     error:&error];
    if(error)
        DLog(@"JSON Parsing Error: %@", error);
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

}
-(NSString*) netEasePlistEncodedKeyValueString{
    NSError *error = nil;
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:self
                                                              format:NSPropertyListXMLFormat_v1_0
                                                             options:0 error:&error];
    if(error)
        DLog(@"JSON Parsing Error: %@", error);
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end
