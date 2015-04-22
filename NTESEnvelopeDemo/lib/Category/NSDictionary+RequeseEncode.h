//
//  NSDictionary+RequeseEncode.h
//  NetEaseHongBao
//
//  Created by kk on 15/4/13.
//  Copyright (c) 2015年 Luigi. All rights reserved.
//



@interface NSDictionary (RequeseEncode)
-(NSString*) netEaseUrlEncodedKeyValueString;
-(NSString*) netEaseJsonEncodedKeyValueString;
-(NSString*) netEasePlistEncodedKeyValueString;
@end
