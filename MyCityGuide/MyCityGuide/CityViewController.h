//
//  CityViewController.h
//  MyCityGuide
//
//  Created by Mac on 16/03/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "uipopover+iphone.h"
#import "placessDetailData.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
@interface CityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate,UIAlertViewDelegate>
{
    IBOutlet UILabel *lab;
    NSString *nameOfCity;
    NSString *imageName;
    IBOutlet UIImageView *cityImage;
    IBOutlet UITableView *table;
    UITableViewCell *cell;
    NSMutableArray *tableArr;
    NSArray *imgArr;

  IBOutlet  UIButton *mapBtn;
   IBOutlet UIButton *Dowmload;
   IBOutlet UIButton *More;
    UITextField *searchfield;
    UIButton *HomeBtn;
    
    UIButton *shareBtn;
    NSArray *typeArr;
    UIBarButtonItem *backBtn;
    UIBarButtonItem *rightBarBtn;
    NSMutableArray *iconUrlArr;
    NSMutableArray *mainNameArr;
    NSMutableArray *RatArr;
    NSMutableArray *referArr;
    NSMutableArray *restaurantARR;
    NSMutableArray *HotelARr;
    NSMutableArray *naightLifeArr;
    NSMutableArray *AtrractionArr;
    NSMutableArray *ShoppingArr;
    
    UIView *myactivityView;
    UIActivityIndicatorView *indicator;

    float lat;
    float Long;
    IBOutlet UIViewController *myTableView;
    IBOutlet UIView *btnsCOntView;
    NSArray *LangCodeArr;
    NSArray *langArr;
    NSString *rowText;
    NSString *type;
    UIActivityIndicatorView *activity;
    UIView *actView;
    
    int typeValue;
    placessDetailData *placeInfo;
}
@property(strong,nonatomic)IBOutlet UIButton *More;
-(id)initWithCityname:(NSString*)cityName ;
-(id)initWithCityname:(NSString*)cityName andLatlong:(NSString*)latlong;
- (void)fetchedData:(NSData *)responseData;
-(IBAction)mapBtnClicked:(id)sender;
-(IBAction)DownloadBtnClicked:(id)sender;
-(IBAction)MoreBtnCliked:(id)sender;

-(IBAction)cityGuideDownloads:(id)sender;
-(void)downloadData;
-(void)recivedData:(NSData*)response;
-(void)recieveValidation:(int)value;
-(void)restaurantSaveInDataBase;
-(NSMutableArray*)refArrSent:(NSMutableArray*)reArr;
-(void)hotelDAtaSaveInDb;
@end
