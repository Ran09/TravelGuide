//
//  listofviewOfclass.m
//  TravelGuide
//
//  Created by Mac on 28/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "listofviewOfclass.h"
#import "ViewController.h"
#import "ListDetailView.h"

@implementation listofviewOfclass

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initwithnameOfcity:(NSString*)city andType:(NSString*)type andArr:(NSArray*)arr
{
    nameOfcity=city;
    Sendedtype=type;
    arrvalues=arr;
    self = [super initWithNibName:@"listofviewOfclass" bundle:nil];
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
    iconUrlArr=[[NSMutableArray alloc]init];
    nameArr=[[NSMutableArray alloc]init];
    for (int i=0; i<arrvalues.count; i++) {
        NSString *icon=[arrvalues objectAtIndex:i];
        NSArray *arr=[icon componentsSeparatedByString:@","];
        NSLog(@"  arr  %@ ",arr);
        [iconUrlArr addObject:[arr objectAtIndex:0]];
        [nameArr addObject:[arr objectAtIndex:1]];
    }
    NSLog(@" icon %@ name %@",iconUrlArr,nameArr);
    rightBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"share" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClicked)];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
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
#pragma  mark -tableviewdatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrvalues.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
NSString *cellidentifier=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
    }
    
    cell.textLabel.text=[nameArr objectAtIndex:indexPath.row];
    
    if ([[iconUrlArr objectAtIndex:indexPath.row]isEqualToString:@"http://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png"]) {
        
        //   
        urlImg=[UIImage imageNamed:@"restaurant-71.png"];
        
    }else if([[iconUrlArr objectAtIndex:indexPath.row]isEqualToString:@"http://maps.gstatic.com/mapfiles/place_api/icons/lodging-71.png"]){
        urlImg=[UIImage imageNamed:@"lodging-71.png"];
    }
    else if([[iconUrlArr objectAtIndex:indexPath.row]isEqualToString:@"http://maps.gstatic.com/mapfiles/place_api/icons/bar-71.png"]){
        urlImg=[UIImage imageNamed:@"bar-71.png"];
    }else if([[iconUrlArr objectAtIndex:indexPath.row]isEqualToString:@"http://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png"]){
        urlImg=[UIImage imageNamed:@"generic_business-71.png"];
    }
    else if([[iconUrlArr objectAtIndex:indexPath.row]isEqualToString:@"http://maps.gstatic.com/mapfiles/place_api/icons/shopping-71.png"]){
        urlImg=[UIImage imageNamed:@"shopping-71.png"];
    }else if([[iconUrlArr objectAtIndex:indexPath.row]isEqualToString:@"http://maps.gstatic.com/mapfiles/place_api/icons/library-71.png"]){
        urlImg=[UIImage imageNamed:@"library-71.png"];
    }else if([[iconUrlArr objectAtIndex:indexPath.row]isEqualToString:@"http://maps.gstatic.com/mapfiles/place_api/icons/worship_hindu-71.png"]){
        urlImg=[UIImage imageNamed:@"worship_hindu-71.png"];
    }else if([[iconUrlArr objectAtIndex:indexPath.row]isEqualToString:@"http://maps.gstatic.com/mapfiles/place_api/icons/art_gallery-71.png"]){
        urlImg=[UIImage imageNamed:@"art_gallery-71.png"];}
    else if([[iconUrlArr objectAtIndex:indexPath.row]isEqualToString:@"http://maps.gstatic.com/mapfiles/place_api/icons/museum-71.png"]){
        urlImg=[UIImage imageNamed:@"museum-71.png"];}
    else if([[iconUrlArr objectAtIndex:indexPath.row]isEqualToString:@"http://maps.gstatic.com/mapfiles/place_api/icons/generic_recreational-71.png"]){
        urlImg=[UIImage imageNamed:@"generic_recreational-71.png"];}
    else if([[iconUrlArr objectAtIndex:indexPath.row]isEqualToString:@"http://maps.gstatic.com/mapfiles/place_api/icons/worship_general-71.png"]){
        urlImg=[UIImage imageNamed:@"worship_general-71.png"];}
    else if([[iconUrlArr objectAtIndex:indexPath.row]isEqualToString:@"http://maps.gstatic.com/mapfiles/place_api/icons/cafe-71.png"]){
    urlImg=[UIImage imageNamed:@"cafe-71.png"];
    }
    else{
        urlImg=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[iconUrlArr objectAtIndex:indexPath.row]]]];
    }
    cell.imageView.image=urlImg;
    CGSize itemSize = CGSizeMake(25, 25);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return cell;
}

#pragma mark - tableviewdelegte methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"detail remaining to show" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
//    [alert show];
    
    ListDetailView *listDetail=[[ListDetailView alloc]initcityname:nameOfcity andtype:Sendedtype andname:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    [self.navigationController pushViewController:listDetail animated:YES];
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
