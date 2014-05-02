//
//  MapPoint.m
//  TravelGuide
//
//  Created by Mac on 30/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "MapPoint.h"

@implementation MapPoint
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;



- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate 
{
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
        
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]]) 
        return @"Unknown charge";
    else
        return _name;
}

- (NSString *)subtitle {
    return _address;
}

@end
