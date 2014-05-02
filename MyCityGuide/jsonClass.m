//
//  jsonClass.m
//  school
//
//  Created by technocs on 06/03/14.
//  Copyright (c) 2014 technocs. All rights reserved.
//

#import "jsonClass.h"

@implementation jsonClass
-(void)getDataUrl:(NSURL *)url
{
    NSMutableURLRequest *urlReq=[NSMutableURLRequest requestWithURL:url];
    conn=[[NSURLConnection alloc]initWithRequest:urlReq delegate:self];
    [conn start];
}

+(NSData*)postDataToUrl:(NSURL*)url string:(NSString*)jsonString
{
    NSData *responseData=nil;
    NSMutableURLRequest *UrlReq=[[NSMutableURLRequest alloc]initWithURL:url];
   // responseData=[NSMutableData data];
    NSString *bodyData=jsonString;
    [UrlReq setHTTPMethod:@"POST"];
    NSData *req=[NSData dataWithBytes:[bodyData UTF8String] length:[bodyData length]];
    [UrlReq setHTTPBody:req];
    NSURLResponse *responce;
    NSError *error=nil;
    responseData=[NSURLConnection sendSynchronousRequest:UrlReq returningResponse:&responce error:&error];
    [url release];
    [UrlReq release];
    NSString *responceStr=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"final output is %@",responceStr);
    [responceStr release];
    return responseData;
    [responseData release];
}

#pragma mark NSURLConnectionDelegate methods

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // [xmlData appendData:data];
    NSLog(@"in connection");
   // NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"json %@",json);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Connection didReceiveResponse: %@ - %@", response, [response MIMEType]);
    NSLog(@"connection response");
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSLog(@"Connection didReceiveAuthenticationChallenge: %@", challenge);
	NSLog(@"connection authentication");
	
}
//
//
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    NSLog(@"did fail with error");
}
//
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
}
@end
