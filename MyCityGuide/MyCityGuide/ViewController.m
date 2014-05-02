//
//  ViewController.m
//  MyCityGuide
//
//  Created by Mac on 16/03/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "CityViewController.h"
#import "cityGuideController.h"
#import "tempDataBase.h"
#import "ExistingDatabase.h"
@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)dealloc
{
    [cityArr release];
    [super dealloc];
    
    //share button code Socialize* socialize = [[Socialize alloc] initWithDelegate:self];
   // [self.socialize createShareForEntityWithKey:@"http://www.url.com" medium:SocializeShareMediumFacebook text:@"Check this out!"];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
   // [Viewbanner addSubview:bannerView];
    Viewbanner.tableHeaderView = bannerView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];   
    
    NSArray *arr=[[tempDataBase getSharedInstance]reciveAllData];
       NSLog(@"%@ %i",arr,arr.count);
    
   // NSString *cityiamge=[[ExistingDatabase getsharedInstance]ReceivecityImagesWithCityName:[arr objectAtIndex:1]];
  //  NSLog(@"Image %@",cityiamge);
//    BOOL del;
//    del=[tempDataBase DeleteDatabase];
//    if (del==YES) {
//        NSLog(@"database is deleted ");
//    }
//    BOOL cr;
//    cr=[[tempDataBase getSharedInstance]CreateTable2];
//    if (cr==YES) {
//        NSLog(@"table is created");
//    }
//    for (int i=1; i<=arr.count; i++) {
//        BOOL de=[[tempDataBase getSharedInstance]deleterowFromDownloded:i];
//        if (de==YES) {
//            NSLog(@"data is deleted");
//        }
//    }
//    BOOL cr=[[tempDataBase getSharedInstance]CreateTable];
//    if (cr==YES) {
//        NSLog(@"table Created");
//    }
//    
//    BOOL del;
//    del=[[tempDataBase getSharedInstance]deleteDataFromPlacesDetail:@"Surabaya" andType:@"Night Life" andNAme:NULL];
//    if (del==YES) {
//        NSLog(@"database deleted");
//    }

//    BOOL del=[[tempDataBase getSharedInstance]deleteDataFromPlacesDetail:@"Jakarta" andType:@"Restaurants"];
//    if (del==YES) {
//        NSLog(@"data deleted");
//    }
    
      //"112","Asia","India","Mumbai","18.9750","72.8258"
    
    //radius=1000000
//       bannerView=[[ADBannerView alloc]initWithFrame:CGRectZero];
//    bannerView.requiredContentSizeIdentifiers = 
//    [NSSet setWithObjects: 
//     ADBannerContentSizeIdentifierPortrait,	
//     ADBannerContentSizeIdentifierLandscape, nil];
//    bannerView.delegate = self;   
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    UILabel *labHead=[[UILabel alloc]initWithFrame:CGRectMake(60, 5, 200, 30)];
    [labHead setText:@"Select Continent"];
    [labHead setTextColor:[UIColor whiteColor]];
    [labHead setTextAlignment:UITextAlignmentCenter];
    [labHead setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar addSubview:labHead];
    [labHead release];
    
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(northBtnCliked:)];
    [nAmView addGestureRecognizer:tap1];
    [tap1 release];
   
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(southAmBtnClicked:)];
    [SAmView addGestureRecognizer:tap2];
    [tap2 release];
    
    UITapGestureRecognizer *tap3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(asiaBtnClicked:)];
    [asview addGestureRecognizer:tap3];
    [tap3 release];
       
    UITapGestureRecognizer *tap4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(EuropeBtn:)];
    [EuView addGestureRecognizer:tap4];
    [tap4 release];
    
    UITapGestureRecognizer *tap5=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(africaBtnCliked:)];
    [AfView addGestureRecognizer:tap5];
    [tap5 release];
    
    UITapGestureRecognizer *tap6=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oceaniaBtn:)];
    [oCView addGestureRecognizer:tap6];
    [tap6 release];
    
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    
//    return NO;
//}

-(IBAction)northBtnCliked:(id)sender
{
    NSLog(@"in northtap");
    cityArr=[[NSMutableArray alloc]initWithObjects:@"Bahamas",@"Canada",@"Costa Rica",@"Cuba",@"Dominican Republic",@"El Salvador",@"Guatemala",@"Haiti",@"Honduras",@"Jamaica",@"Mexico",@"Nicaragua",@"Panama",@"Trinidad and Tobago",@"United States", nil];
        cityGuideController *cityG=[[cityGuideController alloc]initWithTitle:northAmLab.text andWithCityArr:cityArr];
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:cityG];
    
    [self presentModalViewController:nav animated:YES];
    
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"please select asia continent only" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//    [alert setAlertViewStyle:UIAlertViewStyleDefault];
//    [alert show];
}

-(IBAction)southAmBtnClicked:(id)sender
{
 NSLog(@"in Southtap");
    cityArr=[[NSMutableArray alloc]initWithObjects:@"Argentina",@"Bolivia",@"Brazil",@"Chile",@"Colombia",@"Ecuador",@"Guyana",@"Paraguay",@"Peru",@"Suriname",@"Uruguay",@"Venezuela", nil];

    cityGuideController *cityG=[[cityGuideController alloc]initWithTitle:southAmLab.text andWithCityArr:cityArr];
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:cityG];
    
    [self presentModalViewController:nav animated:YES];
    
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"please select asia continent only" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//    [alert setAlertViewStyle:UIAlertViewStyleDefault];
//    [alert show];
}

-(IBAction)asiaBtnClicked:(id)sender
{
    NSLog(@"in asiatap");
    cityArr=[[NSMutableArray alloc]initWithObjects:@"Afghanistan",@"Bahrain",@"Bangladesh",@"Burma",@"China",@"India",@"Indonesia",@"Iran",@"Iraq",@"Israel",@"Japan",@"Jordan",@"Kazakhstan",@"North Korea",@"South Korea",@"Kuwait",@"Kyrgyzstan",@"Laos",@"Lebanon",@"Malaysia",@"Mongolia",@"Nepal",@"Oman",@"Pakistan",@"Philippines",@"Qatar",@"Russia",@"Saudi Arabia",@"Singapore",@"Sri Lanka",@"Syria",@"Tajikistan",@"Thailand",@"Turkey",@"Turkmenistan",@"United Arab Emirates",@"Uzbekistan",@"Yemen", nil];
   
    cityGuideController *cityG=[[cityGuideController alloc]initWithTitle:asiaLab.text andWithCityArr:cityArr];
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:cityG];
    [self presentModalViewController:nav animated:YES];
   
}

-(IBAction)africaBtnCliked:(id)sender
{
 NSLog(@"in africatap");
    cityArr=[[NSMutableArray alloc]initWithObjects:@"Algeria",@"Angola",@"Benin",@"Botswana",@"Burkina",@"Burundi",@"Cameroon",@"Central African Republic",@"Chad",@"Comoros",@"Congo",@"Congo,Democratic Republic of congo",@"Djibouti",@"Egypt",@"Equatorial Guinea",@"Eritrea",@"Ethiopia",@"Gabon",@"Ghana",@"Guinea",@"Guinea Bissau",@"Ivory Coast",@"Lesotho",@"Liberia",@"Libya",@"Madagascar",@"Malawi",@"Mali",@"Mauritania",@"Morocco",@"Mozambique",@"Niger",@"Nigeria",@"Rwanda",@"Senegal",@"Sierra Leone",@"Somalia",@"South Sudan",@"Sudan", nil];
   
    cityGuideController *cityG=[[cityGuideController alloc]initWithTitle:africaLab.text andWithCityArr:cityArr];
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:cityG];
    [self presentModalViewController:nav animated:YES];
   
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"please select asia continent only" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//    [alert setAlertViewStyle:UIAlertViewStyleDefault];
//    [alert show];
}

-(IBAction)EuropeBtn:(id)sender
{
// NSLog(@"in europetap");
    cityArr=[[NSMutableArray alloc]initWithObjects:@"Albania",@"Armenia",@"Austria",@"Azerbaijan",@"Belarus",@"Belgium",@"Bulgaria",@"Bosnia and Herzegovina",@"Croatia",@"Cyprus",@"Denmark",@"Estonia",@"Finland",@"France",@"Georgia",@"Germany",@"Greece",@"Hungary",@"Iceland",@"Ireland",@"Italy",@"Lithuania",@"Macedonia",@"Montenegro",@"Netherlands",@"Norway",@"Poland",@"Portugal",@"Romania",@"Serbia",@"Slovakia",@"Slovenia",@"Spain",@"Sweden",@"Switzerland",@"Ukraine",@"United Kingdom", nil];
   
    cityGuideController *cityG=[[cityGuideController alloc]initWithTitle:EuropeLab.text andWithCityArr:cityArr];
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:cityG];
    [self presentModalViewController:nav animated:YES];
    
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"please select asia continent only" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//    [alert setAlertViewStyle:UIAlertViewStyleDefault];
//    [alert show];
}

-(IBAction)oceaniaBtn:(id)sender
{
 NSLog(@"in oceaniatap");
    cityArr=[[NSMutableArray alloc]initWithObjects:@"Australia",@"New Zealand",@"Papua New Guinea", nil];
  

    cityGuideController *cityG=[[cityGuideController alloc]initWithTitle:oceaniaLab.text andWithCityArr:cityArr];
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:cityG];
    [self presentModalViewController:nav animated:YES];
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"please select asia continent only" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//    [alert setAlertViewStyle:UIAlertViewStyleDefault];
//    [alert show];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
