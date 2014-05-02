//
//  downloadedCityGuidesClass.m
//  TravelGuide
//
//  Created by Mac on 28/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "downloadedCityGuidesClass.h"
#import "tempDataBase.h"
#import "ViewController.h"
#import "ExistingDatabase.h"
#import "NextViewOfDownloadClass.h"

@implementation downloadedCityGuidesClass

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithNameofHederView:(NSString*)nameHead andTableArr:(NSArray*)arr
{
    downloadedCityArr=arr;
    ViewHeading=nameHead;
    NSLog(@"%@ %@",ViewHeading,downloadedCityArr);
    self = [super initWithNibName:@"downloadedCityGuidesClass" bundle:nil];
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
    headerLable.text=ViewHeading;
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
    
    backBtn=[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    // backBtn=[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    
    rightBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"share" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClicked)];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
    // [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.2 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.01 green:0.01 blue:0.25 alpha:1]];

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
#pragma mark - table view datasource method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return downloadedCityArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
   // [cell.textLabel setTextAlignment:UITextAlignmentCenter];
    [cell.textLabel setFont:[UIFont fontWithName:@"verdana" size:18]];
    if (downloadedCityArr.count>0) {
        cell.textLabel.text=[downloadedCityArr objectAtIndex:indexPath.row];
       NSString *cityiamge=[[ExistingDatabase getsharedInstance]ReceivecityImagesWithCityName:[downloadedCityArr objectAtIndex:indexPath.row]];
        cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",cityiamge]];
  }
    CGSize itemSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cell;
}
#pragma mark - table view delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NextViewOfDownloadClass *nextView=[[NextViewOfDownloadClass alloc]initwithnameOfCity:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    [self.navigationController pushViewController:nextView animated:YES];
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
