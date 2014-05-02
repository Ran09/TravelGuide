//
//  cityGuideController.m
//  MyCityGuide
//
//  Created by Mac on 16/03/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "cityGuideController.h"
#import "DownloadGuideViewController.h"
#import "ViewController.h"
#import "ExistingDatabase.h"

@implementation cityGuideController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithTitle:(NSString*)titleCity andWithCityArr:(NSMutableArray *)Arr
{
    titleStr=titleCity;
    cityArr=Arr;
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
   
}

- (void)didReceiveMemoryWarning
{
   

    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
   
    cell.textLabel.text=[cityArr objectAtIndex:indexPath.row];
    [cell.textLabel setTextAlignment:UITextAlignmentLeft];
    NSLog(@"%f",cell.textLabel.frame.size.width);
    NSLog(@"%@",[cityArr objectAtIndex:indexPath.row]);
    NSArray *cityImages=[[ExistingDatabase getsharedInstance]receiveCityImageArr:[cityArr objectAtIndex:indexPath.row]];
    NSLog(@"%@",cityImages);
     cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[cityImages objectAtIndex:0]]];
    CGSize itemSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
//    [cell.textLabel setFont:[UIFont fontWithName:@"noteworthy" size:0]];
//    [UIView beginAnimations:@"ani" context:nil];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDuration:2.0];
    [cell.textLabel setFont:[UIFont fontWithName:@"verdana" size:18]];
   // [UIView commitAnimations];
  //  [cell.detailTextLabel setText:@"detail lable"];
    //[cell.imageView setFrame:CGRectMake(0, 0, 40, 40)];
  
   // cell.imageView.image=[UIImage imageNamed:[cityArr objectAtIndex:indexPath.row]];
    
   // cell.imageView.image=[UIImage imageNamed:@"Untitled.png"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
   // [text release];
 
    return cell;
    }

#pragma mark - TableViewDelegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CityViewController *citView=[[CityViewController alloc]initWithCityname:[NSString stringWithFormat:@" %@",[tableView cellForRowAtIndexPath:indexPath].textLabel.text] andWithImageName:[cityArr objectAtIndex:indexPath.row]];
    //if ([[[[tableView cellForRowAtIndexPath:indexPath]textLabel]text]isEqualToString:@"India"]) {
    
//    NSArray *arr;
//    controller=[[controllerClass alloc]init];
//    arr=[controller receiveSpecificData:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
//    NSLog(@"%@",arr);
  // city=[[NSMutableArray alloc]init];
     NSMutableArray *city=[[ExistingDatabase getsharedInstance]reciviewCityName:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    NSLog(@"%@",city);
    NSMutableArray *cityImages=[[ExistingDatabase getsharedInstance]receiveCityImageArr:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    NSLog(@"imges -------------- %@",cityImages);
        DownloadGuideViewController *downloadView=[[DownloadGuideViewController alloc]initWithImageName:[NSString stringWithFormat:@" %@",[tableView cellForRowAtIndexPath:indexPath].textLabel.text] andWithArr:city andWithImageArr:cityImages];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:downloadView];
    
        [self.navigationController presentModalViewController:nav animated:YES]; 
  
  //  }else {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"please select India only" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
//        [alert setAlertViewStyle:UIAlertViewStyleDefault];
//        [alert show];
   // }
    
}

//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [NSString stringWithFormat:@"%@ >> Countries",titleStr];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(85, 8, 25, 25)];
    logoImage.image=[UIImage imageNamed:@"logo.png"];
    [self.navigationController.navigationBar addSubview:logoImage];
    
    UILabel *head=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, 120, 20)];
    [head setText:@"Travel Guide"];
    [head setBackgroundColor:[UIColor clearColor]];
    [head setTextColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar addSubview:head];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.01 green:0.01 blue:0.25 alpha:1]];
   // [head release];
    UILabel *hederView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [hederView setText:[NSString stringWithFormat:@"%@ >> Countries",titleStr]];
    [CityTable setTableHeaderView:hederView];
    [hederView setBackgroundColor:[UIColor colorWithRed:0.01 green:0.01 blue:0.2 alpha:1]];
    [hederView setTextColor:[UIColor whiteColor]];
    HomeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
       // HomeBtn.frame=CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
   
    
    HomeBtn.frame=CGRectMake(210, -5, 60, 50);
    
    [HomeBtn setImage:[UIImage imageNamed:@"home_icon.png"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:HomeBtn];
    [HomeBtn addTarget:self action:@selector(HomeBtnCliked) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn=[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    rightBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"share" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClicked)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightBarBtn, nil]];
  //  [hederView release];
    // Do any additional setup after loading the view from its nib.
}

-(void)backBtnClicked
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
-(void)HomeBtnCliked
{
    ViewController *HomeView=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    [self presentModalViewController:HomeView animated:NO];
    [HomeView release];
   // [HomeView release];
}

-(void)shareBtnClicked
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"share information" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void)viewDidUnload
{
    [cityArr release];
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
