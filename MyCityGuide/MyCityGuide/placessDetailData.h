//
//  placessDetailData.h
//  TravelGuide
//
//  Created by Mac on 20/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface placessDetailData : NSObject
@property(nonatomic,retain)NSString *city,*type,*icon,*name,*reference,*address,*phoneNo,*website;
@property(assign)float latitude,logitude,rating;
@end
