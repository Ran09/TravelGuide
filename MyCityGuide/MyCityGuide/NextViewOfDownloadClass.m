//
//  NextViewOfDownloadClass.m
//  TravelGuide
//
//  Created by Mac on 28/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "NextViewOfDownloadClass.h"
#import "ExistingDatabase.h"
#import "tempDataBase.h"
#import "listofviewOfclass.h"
#import "ViewController.h"

@implementation NextViewOfDownloadClass

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initwithnameOfCity:(NSString*)cityNm
{
    MyCity=cityNm;
    self = [super initWithNibName:@"NextViewOfDownloadClass" bundle:nil];
    if (self) {
        // Custom initialization
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.01 green:0.01 blue:0.25 alpha:1]];
    UIView *ht=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 5)];
    [ht setBackgroundColor:[UIColor colorWithRed:0.03 green:0.03 blue:0.9 alpha:0.8]];
    [listTable setTableHeaderView:ht];
     imgArr=[[NSArray alloc]initWithObjects:@"Restaurant.png",@"hotel.png",@"night.png",@"attr.png",@"shopping.jpg", nil];
    imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[[ExistingDatabase getsharedInstance]ReceivecityImagesWithCityName:MyCity]]];
    cityNameLable.text=MyCity;
//    HomeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    HomeBtn.frame=CGRectMake(210, -5, 60, 50);
//    
//    [HomeBtn setImage:[UIImage imageNamed:@"home_icon.png"] forState:UIControlStateNormal];
//    [self.navigationController.navigationBar addSubview:HomeBtn];
    [HomeBtn addTarget:self action:@selector(HomeBtnCliked) forControlEvents:UIControlEventTouchUpInside];
    
    // backBtn=[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
   // [self.navigationItem setLeftBarButtonItem:backBtn];
    rightBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"share" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClicked)];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
    
    
  //  [cityNameLable setText:[NSString stringWithFormat:@" %@",nameOfCity]];
    listArr=[[NSArray alloc]initWithObjects:@"Restaurants",@"Hotels",@"Night Life",@"Attractions",@"Shopping",nil];
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

#pragma mark - table view dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    //[cell.textLabel setTextAlignment:UITextAlignmentCenter];
    [cell.textLabel setFont:[UIFont fontWithName:@"verdana" size:18]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    NSArray *arr=[[tempDataBase getSharedInstance]recivedataforfirstList:[listArr objectAtIndex:indexPath.row] andWithCity:MyCity];
    NSLog(@" data %@ ",arr);
    int values=arr.count;
    cell.textLabel.text=[listArr objectAtIndex:indexPath.row];
    cell.imageView.image=[UIImage imageNamed:[imgArr objectAtIndex:indexPath.row]];
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr=[[tempDataBase getSharedInstance]recivedataforfirstList:[tableView cellForRowAtIndexPath:indexPath].textLabel.text andWithCity:MyCity];
    NSLog(@" arr values %@",arr);
    listofviewOfclass *listView=[[listofviewOfclass alloc]initwithnameOfcity:MyCity andType:[tableView cellForRowAtIndexPath:indexPath].textLabel.text andArr:arr];
    [self.navigationController pushViewController:listView animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
#pragma  mark - homebtn method
-(void)HomeBtnCliked
{
    ViewController *HomeView=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    [self presentModalViewController:HomeView animated:NO];
    // [HomeView release];
}
#pragma mark -sharebtn method

-(void)shareBtnClicked
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"share information" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alert show];
}
#pragma mark - backbtn method
-(void)backBtnClicked
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
