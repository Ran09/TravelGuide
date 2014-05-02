//
//  ListDetailView.m
//  TravelGuide
//
//  Created by Mac on 28/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ListDetailView.h"
#import "ViewController.h"
#import "ExistingDatabase.h"
#import "tempDataBase.h"

@implementation ListDetailView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initcityname:(NSString*)city andtype:(NSString*)type andname:(NSString*)name
{
    citiName=city;
    typeName=type;
    mainName=name;
    NSLog(@" %@ %@ %@",citiName,typeName,mainName);
    self = [super initWithNibName:@"ListDetailView" bundle:nil];
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
    rightBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"share" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClicked)];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];

     cityImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[[ExistingDatabase getsharedInstance]ReceivecityImagesWithCityName:citiName]]];
    CityNAmeLab.text=citiName;
    NSArray *arr=[[tempDataBase getSharedInstance]recivedataforsecondList:typeName andWithCity:citiName andWithName:mainName];
    NSLog(@"arr %@",arr);
    
    imgView.layer.cornerRadius=25;
    imgView.layer.masksToBounds=YES;
    //  imgView.backgroundColor=[UIColor clearColor];
    imgView.layer.borderColor=[UIColor whiteColor].CGColor;
    imgView.layer.borderWidth=2;
    
    NSString *data=[arr objectAtIndex:0];
    NSLog(@" data %@",data);
    NSArray *Myarr=[data componentsSeparatedByString:@","];
    NSLog(@" my arr %@",Myarr);
    iconImg.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[Myarr objectAtIndex:0]]]];
    NAmeLAb.text=mainName;
    NSArray *addArr=[[tempDataBase getSharedInstance]reciveAddressforsecondList:typeName andWithCity:citiName andWithName:mainName];
    NSLog(@" add arr %@",addArr);
    ViciLab.text=[addArr objectAtIndex:0];
    AddLAb.text=[addArr objectAtIndex:0];
    phoneLab.text=[Myarr objectAtIndex:1];
    WebsitLab.text=[Myarr objectAtIndex:2];
    // Do any additional setup after loading the view from its nib.
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
