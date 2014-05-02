//
//  MapViewController.m
//  MyCityGuide
//
//  Created by Mac on 05/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "ViewController.h"
#import "ExistingDatabase.h"

@implementation MapViewController
@synthesize mapView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithMapView:(NSString*)CityName andLat:(float)lat andLong:(float)Long 
{
    latitude=lat;
   logitude=Long;
    Namecity=CityName;
    self=[super init];
    if(self)
    {}
    return self;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc
{
    [super dealloc];
    [annotationView dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imagename=[[ExistingDatabase getsharedInstance]ReceivecityImagesWithCityName:Namecity];
    NSLog(@" image name %@",imagename);
   // cityImageView.image=[UIImage imageNamed:@"%@.jpg",imagename];
    cityImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",imagename]];
    UIImageView *logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(80, 8, 25, 25)];
    logoImage.image=[UIImage imageNamed:@"logo.png"];
    [self.navigationController.navigationBar addSubview:logoImage];
    
    UILabel *head=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, 120, 20)];
    [head setText:@"Travel Guide"];
    [head setBackgroundColor:[UIColor clearColor]];
    [head setTextColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar addSubview:head];
    HomeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    HomeBtn.frame=CGRectMake(210, -5, 60, 50);
    
    [HomeBtn setImage:[UIImage imageNamed:@"home_icon.png"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:HomeBtn];
    [HomeBtn addTarget:self action:@selector(HomeBtnCliked) forControlEvents:UIControlEventTouchUpInside];
    rightBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"share" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClicked)];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
    
    self.mapView.delegate = self;     
    currentCentre.latitude=latitude;
    currentCentre.longitude=logitude;
    currenDist=1000000;
    
    //Instantiate a location object.
    mangr = [[CLLocationManager alloc] init];
    
    //Make this controller the delegate for the location manager.
    [mangr setDelegate:self];
    
    //Set some paramater for the location object.
    [mangr setDistanceFilter:kCLDistanceFilterNone];
    [mangr setDesiredAccuracy:kCLLocationAccuracyBest];
    [mangr startUpdatingLocation];
    // Ensure that we can view our own location in the map view.
    [self.mapView setShowsUserLocation:YES];
    NSLog(@"%f", self.mapView.userLocation.location.coordinate.latitude);
    firstLaunch=YES;
    [self queryGooglePlaces:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)shareBtnClicked
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"share information" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alert show];
}

-(void)HomeBtnCliked
{
    ViewController *HomeView=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    [self presentModalViewController:HomeView animated:NO];
    // [HomeView release];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) queryGooglePlaces: (NSString *) googleType
{
    
    
    // Build the url string we are going to sent to Google. NOTE: The kGOOGLE_API_KEY is a constant which should contain your own API key that you can obtain from Google. See this link for more info:
    // https://developers.google.com/maps/documentation/places/#Authentication
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%i&types=restaurant|lodging|bar|night_club|hindu_temple|spa|museum|church|shopping_mall&sensor=true&key=AIzaSyCTFrT9evA_oUau7wJ9KF-i-UNQldAHff4", currentCentre.latitude, currentCentre.longitude,currenDist];
    
    //Formulate the string as URL object.
    //NSURL *googleRequestURL=[NSURL URLWithString:url];
    NSURL *googleRequestURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData 
                          
                          options:kNilOptions 
                          error:&error];
    NSLog(@"%@",json);
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"]; 
    
    //Write out the data to the console.
    NSLog(@"Google Data: %@", places);
    
    //Plot the data in the places array onto the map with the plotPostions method.
    [self plotPositions:places];
    
    
}
//- (IBAction)toolbarButtonPresses:(id)sender {
//    
//    //Obtain the title of the toolbar button being pressed. The title will be the "type" we send in the url.
//    
//    UIBarButtonItem *button = (UIBarButtonItem *)sender; 
//    NSString *buttonTitle = [button.title lowercaseString];
//    
//    //Set the image title
//   // imageName=[[NSString alloc] init];
//   // imageName=[NSString stringWithFormat:@"%@.png", buttonTitle];
//    
//    
//    
//    //Use this title text to build the URL query and get the data from Google. Change the radius value to increase the size of the search area in meters. The max is 50,000.
//    [self queryGooglePlaces:buttonTitle];
//}

- (void)plotPositions:(NSArray *)data
{
    
    //Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in mapView.annotations) 
    {
        NSLog(@" in for annotation ");
        if ([annotation isKindOfClass:[MapPoint class]]) 
        {
            NSLog(@"in if annotation");
            [mapView removeAnnotation:annotation];
        }
    }
    
    int i;
    //Loop through the array of places returned from the Google API.
    for (i=0; i<[data count]; i++)
    {
        
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        
        //There is a specific NSDictionary object that gives us location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        
        
        //Get our name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        
        //Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        
        //Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        
        //Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        //Create a new annotiation.
        MapPoint *placeObject = [[[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord]autorelease];
        
        
        [mapView addAnnotation:placeObject];
        
        //[place release];
       // [geo release];
       // [name release];
       // [vicinity release];
       // [loc release];
        
    }
    
}


#pragma mark - MKMapViewDelegate methods.


- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{    
    
    //Zoom back to the user location after adding a new set of annotations.
    
    //Get the center point of the visible map.
    
    CLLocationCoordinate2D centre = [mv centerCoordinate];
    
    MKCoordinateRegion region;
    
    //If this is the first launch of the app then set the center point of the map to the user's location.
    if (firstLaunch) {
        region = MKCoordinateRegionMakeWithDistance(mangr.location.coordinate,1000,1000);
        firstLaunch=NO;
    }else {
        //Set the center point to the visible region of the map and change the radius to match the search radius passed to the Google query string.
        region = MKCoordinateRegionMakeWithDistance(centre,currenDist,currenDist);
    }
    
    //Set the visible region of the map.
    [mv setRegion:region animated:YES];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //Define our reuse indentifier.
    static NSString *identifier = @"MapPoint";   
    
    
    if ([annotation isKindOfClass:[MapPoint class]]) {
        
       annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        
        //Get an image to display on the left hand side of the callout.
        UIImageView *test = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_marker.png"]]autorelease];
        
        //Resize the image to make it fit nicely.
        [test setFrame:CGRectMake(0, 0, 30, 30)];
        
        //Set the image in the callout.
        annotationView.leftCalloutAccessoryView = test;
        
         [identifier release];
        return annotationView;
    }
   
    return nil;    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    
    //Get the east and west points on the map so we calculate the distance (zoom level) of the current map view.
//    MKMapRect mRect = self.mapView.visibleMapRect;
//    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
//    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
//    
//    //Set our current distance instance variable.
//    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    NSLog(@"current distance %i",currenDist);
    
    //Set our current centre point on the map instance variable.
   // currentCentre = self.mapView.centerCoordinate;
    NSLog(@" LAt %f long %f",currentCentre.latitude,currentCentre.longitude);
}

#pragma mark-iboutlet btn implemantation

@end
