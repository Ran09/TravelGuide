//
//  MapViewController.h
//  MyCityGuide
//
//  Created by Mac on 05/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapPoint.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface MapViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationManager *mangr;
  IBOutlet  MKMapView *mapView;

    BOOL firstLaunch;
    CLLocationCoordinate2D currentCentre;
    MKPinAnnotationView *annotationView;
    int currenDist;
    NSString *Namecity;
    float latitude;
    float logitude;
   
    UIButton *HomeBtn;
    UIBarButtonItem *rightBarBtn;
    NSString *imagename;
    IBOutlet UIImageView *cityImage;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (void)plotPositions:(NSArray *)data;
-(void) queryGooglePlaces: (NSString *) googleType;
-(id)initWithMapView:(NSString*)CityName andLat:(float)lat andLong:(float)Long ;


@end
