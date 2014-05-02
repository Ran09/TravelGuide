//
//  cityDetailViewController.m
//  MyCityGuide
//
//  Created by Mac on 02/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "cityDetailViewController.h"
#import "TypeDetailViewController.h"
#import "jsonClass.h"
#import "ViewController.h"
@implementation cityDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(id)initWithicon:(NSArray*)iconUrl name:(NSArray*)namearr rating:(NSArray*)rattingArr reference:(NSArray*)referenceArr andwithCityName:(NSString*)city withType:(NSString*)type
{
    iconUrlArr=iconUrl;
    mainNameArr=namearr;
    RatArr=rattingArr;
    referArr=referenceArr;
    CITYName=city;
    TypeTitle=type;
    NSLog(@"%@ %@ %@ %@",iconUrl,namearr,rattingArr,referenceArr);
    NSLog(@"..................................................%@",TypeTitle);
   
    self=[super init];
    if (self) {
        
    }
    return self;
}

-(id)initWithicon:(NSArray*)results andWithCityNAme:(NSString*)cityNAme andWithTitle:(NSString*)Mytitle;
{
    resultsArr=results;
    CITYName=cityNAme;
    TypeTitle=Mytitle;
   // NSLog(@"result ---------------- -------------- ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;%@",resultsArr);
    self = [super initWithNibName:@"cityDetailViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)HomeBtnCliked
{
    ViewController *HomeView=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    [self presentModalViewController:HomeView animated:NO];
    // [HomeView release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark-tableviewdatasource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mainNameArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"cell";
   UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
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
else{
 urlImg=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[iconUrlArr objectAtIndex:indexPath.row]]]];
}//
    
    cell.imageView.frame=CGRectMake(10,10, 20, 20);
    cell.imageView.image=[cityDetailViewController imageWithImage:urlImg scaledToSize:CGSizeMake(25, 25)];
    cell.textLabel.text=[mainNameArr objectAtIndex:indexPath.row];
//    dicResult=[[NSDictionary alloc]init];
//    dicResult=[resultsArr objectAtIndex:indexPath.row];
//    NSLog(@"%@ dic result",dicResult);
   // cell.detailTextLabel.text=[detailNameArr objectAtIndex:indexPath.row];
   cell.detailTextLabel.text=[NSString stringWithFormat:@"rating %@ out of 5",[RatArr objectAtIndex:indexPath.row]];
//    BOOL suc;
//    placesInfo=[[placessDetailData alloc]init];
//    placesInfo.rating=[[RatArr objectAtIndex:indexPath.row]doubleValue];
//    NSLog(@"rating %f",placesInfo.rating);
//    placesInfo.reference=[referArr objectAtIndex:indexPath.row];
//    suc=[[tempDataBase getSharedInstance]updateData:placesInfo];
//    if (suc==YES) {
//        NSLog(@"data is updated");
//    }
   //    if ([iconUrlArr objectAtIndex:indexPath) {
//        <#statements#>http://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png
//    }
    
    
    
   // [urlImg release];
    return cell;
   // [cell release];
}

+ (UIImage*)imageWithImage:(UIImage*)image 
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
#pragma mark-tableviewdelegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
// 
    
   // NSDictionary *reDic=[resultsArr objectAtIndex:indexPath.row];
    NSLog(@" in did select ");
    NSString *reference=[NSString stringWithFormat:@"%@",[referArr objectAtIndex:indexPath.row]];
    referenceplace=[referArr objectAtIndex:indexPath.row];
   // NSArray* places;
  //  NSString *url;
   myactivityView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, detailTable.frame.size.width, detailTable.frame.size.height)];
    
    //  UITableViewCell *cellview=[tableView cellForRowAtIndexPath:indexPath];
    indicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame=CGRectMake(320/2-30, myactivityView.frame.size.height/2-50, 50, 50);
    // cellview.accessoryView=indicator;
    [myactivityView addSubview:indicator];
    //indicator.center=myactivityView.center;
    [indicator startAnimating];
   // [indicator release];
    [myactivityView setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]];
    [detailTable addSubview:myactivityView];
    rating=[[RatArr objectAtIndex:indexPath.row]floatValue];
   // [myactivityView release];
        NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=AIzaSyCTFrT9evA_oUau7wJ9KF-i-UNQldAHff4",reference];
        // NSString *newUrlstr=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=1000000&sensor=true&key=AIzaSyCTFrT9evA_oUau7wJ9KF-i-UNQldAHff4&types=bar",lat,Long];
        NSURL *googleRequestURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        

    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
   
 
    
      // NSDictionary *places = [dic objectForKey:@"result"];
  
  //  [URL release];
    //NSLog(@"%@",places);
  //  NSString *ADD=[places objectForKey:@"website"];
 //    NSLog(@"%@",ADD);
//    TypeDetailViewController *typeDetail=[[TypeDetailViewController alloc]initWithResultArr:places withName:[tableView cellForRowAtIndexPath:indexPath].textLabel.text andCityName:CITYName];
//    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:typeDetail];
//  //  [typeDetail release];
//    [self.navigationController presentModalViewController:nav animated:YES];
//    [indicator stopAnimating];
  //  [nav release];
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData 
                          
                          options:kNilOptions 
                          error:&error];
    // NSLog(@"%@",error);
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    // NSLog(@"error %@",error);
  //  NSLog(@"dic %@",json);
   // NSArray *arr=[json objectForKey:@"result"];
    NSDictionary *places=[json objectForKey:@"result"];
    NSLog(@"reference %@  %.1f",referenceplace,rating);
    
    TypeDetailViewController *typeDetail=[[TypeDetailViewController alloc]initWithResultArr:places withName:TypeTitle andCityName:CITYName andreference:referenceplace andRating:rating];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:typeDetail];
      //  [typeDetail release];
    [indicator stopAnimating];
    [myactivityView removeFromSuperview];
    [indicator release];
    [myactivityView release];
        [self.navigationController presentModalViewController:nav animated:YES];

   
   // [self.navigationController pushViewController:detailCityView animated:YES];
    // [detailCityView release];
    NSLog(@"in fetch");
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - View lifecycle

-(void)dealloc
{
    [super dealloc];
   // [cell release];
  //  [detailTable release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // self.title=TypeTitle;
    
//    UIImageView *logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(80, 8, 25, 25)];
//    logoImage.image=[UIImage imageNamed:@"logo.png"];
//    [self.navigationController.navigationBar addSubview:logoImage];
//    
//    UILabel *head=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, 120, 20)];
//    [head setText:@"Travel Guide"];
//    [head setBackgroundColor:[UIColor clearColor]];
//    [head setTextColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar addSubview:head];

    //    for (int i=0; i<iconUrlArr.count; i++) {
//        BOOL suc;
//        //(city,type,icon,name,rating,reference)
//        placesInfo=[[placessDetailData alloc]init];
//        placesInfo.city=CITYName;
//        placesInfo.type=TypeTitle;
//        placesInfo.icon=[iconUrlArr objectAtIndex:i];
//        placesInfo.name=[mainNameArr objectAtIndex:i];
//        placesInfo.rating=[[RatArr objectAtIndex:i]floatValue];
//        placesInfo.reference=[referArr objectAtIndex:i];
//        suc=[[tempDataBase getSharedInstance]saveData:placesInfo];
//        if (suc==YES) {
//            NSLog(@"data is saved");
//        }
//    }
    
    

    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.01 green:0.01 blue:0.25 alpha:1]];
    rightBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"share" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClicked)];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
  //  [lab setText:[NSString stringWithFormat:@" %@",nameOfCity]];

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
