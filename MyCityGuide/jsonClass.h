//
//  jsonClass.h
//  school
//
//  Created by technocs on 06/03/14.
//  Copyright (c) 2014 technocs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface jsonClass : NSObject<NSURLConnectionDataDelegate>
{
    NSMutableData *WebData;
    NSURLConnection *conn;
    NSMutableArray *ArrData;
}

-(void)getDataUrl:(NSURL*)url;
+(NSData*)postDataToUrl:(NSURL*)url string:(NSString*)jsonString;
@end
