//
//  DownloadGuideViewController.m
//  MyCityGuide
//
//  Created by Mac on 20/03/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "DownloadGuideViewController.h"
#import "CityViewController.h"
#import "ViewController.h"
#import "ExistingDatabase.h"
#import "tempDataBase.h"
#import "downloadedCityGuidesClass.h"

@implementation DownloadGuideViewController
@synthesize titleText;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithImageName:(NSString*)titlelab;
{
    self.titleText=titlelab;
    self = [super init];
    if (self) {
        //Custom initialization
    }
    return self;
}
-(id)initWithImageName:(NSString*)titlelab andWithArr:(NSMutableArray *)arr andWithImageArr:(NSMutableArray*)imgeArr;
{
    self.titleText=titlelab;
    cityArr=arr;
    CityImageArr=imgeArr;
    NSLog(@"%@   img arr ----- ",CityImageArr);
    self = [super init];
    if (self) {
        //Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)dealloc
{
    [super dealloc];
//    [HomeBtn release];
//    [backBtn release];
//    [rightBarBtn release];
//    [CityTable release];
//    [cityArr release];
//    [cell release];
    
}
-(void)HomeBtnCliked
{
    ViewController *HomeView=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    [self presentModalViewController:HomeView animated:NO];
   // [HomeView release];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    if(cityArr.count==1){
        CityTable.frame=CGRectMake(0, 63, 320, 80*2);
        NSLog(@"in second if");
    }else if (cityArr.count<4) {
        CityTable.frame=CGRectMake(0, 63, 320, cityArr.count*100+2);
        NSLog(@" in first if");
    }
    else if(cityArr.count<5){
        CityTable.frame=CGRectMake(0, 63, 320, cityArr.count*80);}
    
    
    UIImageView *logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(80, 8, 25, 25)];
    logoImage.image=[UIImage imageNamed:@"logo.png"];
    [self.navigationController.navigationBar addSubview:logoImage];
    
    UILabel *head=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, 120, 20)];
    [head setText:@"Travel Guide"];
    [head setBackgroundColor:[UIColor clearColor]];
    [head setTextColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar addSubview:head];

    
    UILabel *hederView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [hederView setText:[NSString stringWithFormat:@"%@ >> Countries",self.titleText]];
    [CityTable setTableHeaderView:hederView];
    [hederView setBackgroundColor:[UIColor colorWithRed:0.01 green:0.01 blue:0.2 alpha:1]];
    [hederView setTextColor:[UIColor whiteColor]];
    
    HomeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    HomeBtn.frame=CGRectMake(210, -5, 60, 50);
   
    [HomeBtn setImage:[UIImage imageNamed:@"home_icon.png"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:HomeBtn];
    [HomeBtn addTarget:self action:@selector(HomeBtnCliked) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn=[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    [self.navigationItem setLeftBarButtonItem:backBtn];
   // backBtn=[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    
    rightBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"share" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClicked)];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
   // [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.2 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.01 green:0.01 blue:0.25 alpha:1]];
    
    UITapGestureRecognizer *downloadTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downloadedLabTaped:)];
    [downlodedGuide addGestureRecognizer:downloadTap];
    
    // Do any additional setup after loading the view from its nib.
   // [hederView release];
}

#pragma mark - dowloaded guide method

-(void)downloadedLabTaped:(UITapGestureRecognizer*)tap
{
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"downloadedguide" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//    [alert show];
    
    NSArray *arr=[[tempDataBase getSharedInstance]receiveAllDownloadcity];
    NSLog(@"%@ %i",arr,arr.count);
    
    downloadedCityGuidesClass *cityguides=[[downloadedCityGuidesClass alloc]initWithNameofHederView:@" Downloaded guides" andTableArr:arr];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:cityguides];
    [self.navigationController presentModalViewController:nav animated:NO];
}

#pragma mark - TableViewDataSourceMethods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cityArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"cell";
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
//    cell.textLabel.frame=CGRectMake(60, 0, 10, 0);
//    cell.textLabel.font=[UIFont systemFontOfSize:0.0];
//    [UIView beginAnimations:@"animation" context:nil];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDuration:2.0];
//    cell.textLabel.frame=CGRectMake(0, 0, 200, 30);
//    cell.textLabel.font=[UIFont systemFontOfSize:18.0];
//    [UIView commitAnimations];
    NSString *text=[cityArr objectAtIndex:indexPath.row];
    cell.textLabel.text=[text stringByDeletingPathExtension];
    [cell.textLabel setTextAlignment:UITextAlignmentCenter];
    [cell.textLabel setFont:[UIFont fontWithName:@"verdana" size:18]];
  //    NSLog(@"%@",titleText);
   
    cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[CityImageArr objectAtIndex:indexPath.row]]];
    

    CGSize itemSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

   //  cell.imageView.image=[UIImage imageNamed:@"kabul.jpg"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
  //  [cellIdentifier release];
    return cell;
   // [cell release];
}

#pragma mark - TableViewDelegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CityViewController *citView=[[CityViewController alloc]initWithCityname:[NSString stringWithFormat:@" %@",[tableView cellForRowAtIndexPath:indexPath].textLabel.text] andWithImageName:[cityArr objectAtIndex:indexPath.row]];
    NSString *latlong=[[ExistingDatabase getsharedInstance]reciveLatLong:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    NSLog(@" %@ ",latlong);
    
    CityViewController *cityView=[[CityViewController alloc]initWithCityname:[tableView cellForRowAtIndexPath:indexPath].textLabel.text andLatlong:latlong];
    
   // [latlong release];
    
   // UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:cityView];
    
    [self.navigationController pushViewController:cityView animated:YES];
    //[cityView release];
}
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [NSString stringWithFormat:@"%@ >> Countries",titleText];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(void)backBtnClicked
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
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
