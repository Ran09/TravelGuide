//
//  ListDetailView.h
//  TravelGuide
//
//  Created by Mac on 28/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ListDetailView : UIViewController
{
    UIButton *HomeBtn;
    UIBarButtonItem *backBtn;
    UIBarButtonItem *rightBarBtn;
    
    NSString *citiName;
    NSString *mainName;
    NSString *typeName;
    
    IBOutlet UIImageView *cityImage;
    
    IBOutlet UIImageView *iconImg;
    IBOutlet UILabel *NAmeLAb;
    IBOutlet UILabel *ViciLab;
    IBOutlet UILabel *AddLAb;
    IBOutlet UILabel *phoneLab;
    IBOutlet UILabel *WebsitLab;
    IBOutlet UIImageView *AddImg;
    IBOutlet UIImageView *phoneImg;
    IBOutlet UIImageView *webSitImg;
    NSString *NAME;
    IBOutlet UILabel *CityNAmeLab;
    IBOutlet UIView *imgView;
    
}

-(id)initcityname:(NSString*)city andtype:(NSString*)type andname:(NSString*)name;
@end
