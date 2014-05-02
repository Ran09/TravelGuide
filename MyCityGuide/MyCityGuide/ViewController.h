//
//  ViewController.h
//  MyCityGuide
//
//  Created by Mac on 16/03/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <iAd/iAd.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,ADBannerViewDelegate>
{
    IBOutlet UILabel *northAmLab;
    IBOutlet UIView *nAmView;
    IBOutlet UIView *SAmView;
    IBOutlet UIView *asview;
    IBOutlet UIView *AfView;
    IBOutlet UIView *EuView;
    IBOutlet UIView *oCView;
    IBOutlet UILabel *southAmLab;
    IBOutlet UILabel *asiaLab;
    IBOutlet UILabel *africaLab;
    IBOutlet UILabel *oceaniaLab;
    IBOutlet UILabel *EuropeLab;
    NSMutableArray *cityArr;
    CLLocationManager *locationMngr;
    CLLocationCoordinate2D *coord;
    int currentDist;
    IBOutlet UIButton *but;
    ADBannerView *bannerView;
   IBOutlet UITableView *Viewbanner;
}

-(IBAction)northBtnCliked:(id)sender;
-(IBAction)southAmBtnClicked:(id)sender;
-(IBAction)asiaBtnClicked:(id)sender;
-(IBAction)africaBtnCliked:(id)sender;
-(IBAction)oceaniaBtn:(id)sender;
-(IBAction)EuropeBtn:(id)sender;
@end
