//
//  TypeDetailViewController.h
//  MyCityGuide
//
//  Created by Mac on 05/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "tempDataBase.h"
#import "placessDetailData.h"
@interface TypeDetailViewController : UIViewController
{
    IBOutlet UIView *NameView;
    IBOutlet UIView *DetailView;
    NSDictionary *result;
    NSString *NAMECITY;
    NSString *imageName;
    NSString *rfrnce;
    float rating;
    
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
    NSDictionary *ResultedDic;
    IBOutlet UIView *imgView;
    
    UIButton *HomeBtn;
    
    UIButton *shareBtn;
    UIBarButtonItem *backBtn;
    UIBarButtonItem *rightBarBtn;
    
    tempDataBase *tempDb;
    placessDetailData *placeInfo;
}
@property(nonatomic,retain)NSDictionary *result;
-(id)initWithResultArr:(NSDictionary*)resultArr withName:(NSString*)Name andCityName:(NSString*)cityName andreference:(NSString*)reference andRating:(float)rat;
-(IBAction)MApBtnClicked:(id)sender;
-(void)BackBtnClicked;
@end
