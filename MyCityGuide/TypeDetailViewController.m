//
//  TypeDetailViewController.m
//  MyCityGuide
//
//  Created by Mac on 05/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "TypeDetailViewController.h"
#import "MapViewController.h"
#import "ExistingDatabase.h"
#import "ViewController.h"
@implementation TypeDetailViewController
@synthesize result;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithResultArr:(NSDictionary*)resultArr withName:(NSString*)Name andCityName:(NSString*)cityName andreference:(NSString*)reference andRating:(float)rat;
{
    self.result=resultArr;
    NAMECITY=cityName;
    NAME=Name;
    rfrnce=reference;
    rating=rat;
    NSLog(@"%@ \n %@ ref %@ ",NAMECITY,NAME,rfrnce);
    self=[super init];
    if (self) {
        
    }
    return  self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)HomeBtnCliked
{
    ViewController *HomeView=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    [self presentModalViewController:HomeView animated:NO];
    // [HomeView release];
}
-(IBAction)MApBtnClicked:(id)sender
{
    NSString *LatLong=[[ExistingDatabase getsharedInstance]reciveLatLong:NAMECITY];
    NSArray *arr=[LatLong componentsSeparatedByString:@","];
    float lat=[[arr objectAtIndex:0]floatValue];
    float Long=[[arr objectAtIndex:1]floatValue];
    NSLog(@"%@",LatLong);
    MapViewController *mapView=[[MapViewController alloc]initWithMapView:NAMECITY andLat:lat andLong:Long];
    //UINavigationController *nav=[UINavigationController alloc]initWithRootViewController:mapView
    
    [self.navigationController pushViewController:mapView animated:YES];
   // [LatLong release];
  //  [arr release];
    //[mapView release];
}

-(void)BackBtnClicked;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{//formatted_phone_number
    //icon
    //vicinity
    //website
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.01 green:0.01 blue:0.25 alpha:1]];
    
    UIImageView *logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(80, 8, 25, 25)];
    logoImage.image=[UIImage imageNamed:@"logo.png"];
    [self.navigationController.navigationBar addSubview:logoImage];
    
    UILabel *head=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, 120, 20)];
    [head setText:@"Travel Guide"];
    [head setBackgroundColor:[UIColor clearColor]];
    [head setTextColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar addSubview:head];

    
    imageName=[[ExistingDatabase getsharedInstance]ReceivecityImagesWithCityName:NAMECITY];
    NSLog(@"img name %@ ",imageName);
    cityImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",imageName]];
    
    HomeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    HomeBtn.frame=CGRectMake(210, -5, 60, 50);
    
    [HomeBtn setImage:[UIImage imageNamed:@"home_icon.png"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:HomeBtn];
    [HomeBtn addTarget:self action:@selector(HomeBtnCliked) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn=[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(BackBtnClicked)];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    rightBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"share" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClicked)];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
    NSLog(@"result data %@",self.result);
    ViciLab.text=[NSString stringWithFormat:@"%@",[self.result objectForKey:@"formatted_address"]];
    phoneLab.text=[NSString stringWithFormat:@"%@",[self.result objectForKey:@"formatted_phone_number"]];
    WebsitLab.text=[NSString stringWithFormat:@"%@",[self.result objectForKey:@"website"]];
    AddLAb.text=[NSString stringWithFormat:@"%@",[self.result objectForKey:@"formatted_address"]];
    NAmeLAb.text=[NSString stringWithFormat:@"%@",[self.result objectForKey:@"name"]];
     UIImage *urlImg=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.result objectForKey:@"icon"]]]];
    iconImg.image=urlImg;
    imgView.layer.cornerRadius=25;
    imgView.layer.masksToBounds=YES;
  //  imgView.backgroundColor=[UIColor clearColor];
    imgView.layer.borderColor=[UIColor whiteColor].CGColor;
    imgView.layer.borderWidth=2;
   // imgView.backgroundColor=[UIColor colorWithRed:0.4 green:0.4 blue:0.6 alpha:1];
    NSLog(@"rating %f",rating);
    NSDictionary *geo=[self.result objectForKey:@"geometry"];
    NSDictionary *loc=[geo objectForKey:@"location"];
    float latitude=[[loc objectForKey:@"lat"]floatValue];
    float longitude=[[loc objectForKey:@"lng"]floatValue];
    NSLog(@"%f %f ",latitude,longitude);
    BOOL suc;
    placeInfo=[[placessDetailData alloc]init];
    placeInfo.city=NAMECITY;
    placeInfo.type=NAME;
    placeInfo.icon=[self.result objectForKey:@"icon"];
    placeInfo.name=NAmeLAb.text;
    placeInfo.rating=rating;
    placeInfo.reference=rfrnce;
    placeInfo.address=ViciLab.text;
     placeInfo.phoneNo=phoneLab.text;
    placeInfo.website=WebsitLab.text;
    placeInfo.latitude=latitude;
    placeInfo.logitude=longitude;
   
       
    suc=[[tempDataBase getSharedInstance]saveData:placeInfo];
    if (suc==YES) {
        NSLog(@" data is successfully saved");
    }
    [super viewDidLoad];
    NameView.layer.borderWidth=1;
    NameView.layer.borderColor=[UIColor blackColor].CGColor;
    NameView.layer.cornerRadius=5;
    NameView.layer.masksToBounds=YES;
    AddImg.backgroundColor=[UIColor clearColor];
    phoneImg.backgroundColor=[UIColor clearColor];
    
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = NameView.bounds;
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1] CGColor], (id)[[UIColor whiteColor] CGColor],(id)[[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] CGColor], nil];
//    [NameView.layer insertSublayer:gradient atIndex:0];
    
    DetailView.layer.borderWidth=1;
    DetailView.layer.borderColor=[UIColor blackColor].CGColor;
    DetailView.layer.cornerRadius=3;
    DetailView.layer.masksToBounds=YES;
    
//    CAGradientLayer *gradient2 = [CAGradientLayer layer];
//    gradient2.frame = DetailView.bounds;
//    gradient2.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] CGColor], (id)[[UIColor whiteColor] CGColor],(id)[[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] CGColor], nil];
//    [DetailView.layer insertSublayer:gradient2 atIndex:0];
    CityNAmeLab.text=NAMECITY;
    // Do any additional setup after loading the view from its nib.
}

-(void)shareBtnClicked
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"share information" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alert show];
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

@end
