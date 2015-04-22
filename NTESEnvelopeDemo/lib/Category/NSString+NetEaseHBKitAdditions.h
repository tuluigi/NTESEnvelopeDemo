//
//  NSString+NTESHbKitAdditions.h
//  NetEaseHongBao
//
//  Created by kk on 15/4/13.
//  Copyright (c) 2015年 Luigi. All rights reserved.
//



@interface NSString (NTESHbKitAdditions)
- (NSString *) netEase_md5;
+ (NSString*) netEase_uniqueString;
- (NSString*) netEase_urlEncodedString;
- (NSString*) netEase_urlDecodedString;
@end
