//
//  CityViewController.m
//  MyCityGuide
//
//  Created by Mac on 16/03/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CityViewController.h"
#import "ViewController.h"
#import "cityDetailViewController.h"
#import "AppDelegate.h"
#import "MapViewController.h"
#import "TableViewController.h"
#import "ExistingDatabase.h"
#import "tempDataBase.h"
#import "jsonClass.h"

@implementation CityViewController
int rowValue;
int val;
@synthesize More;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithCityname:(NSString*)cityName 
{
    nameOfCity=cityName;
    
    NSLog(@"in init");
    self = [super initWithNibName:@"CityViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCityname:(NSString*)cityName andLatlong:(NSString *)latlong;
{
    nameOfCity=cityName;
    NSArray *arr=[latlong componentsSeparatedByString:@","];
    lat=[[arr objectAtIndex:0]floatValue];
    Long=[[arr objectAtIndex:1]floatValue];
    NSLog(@"%f %f",lat,Long);
    NSLog(@"in init");
    self = [super initWithNibName:@"CityViewController" bundle:nil];
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
-(void)HomeBtnCliked
{
    ViewController *HomeView=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    [self presentModalViewController:HomeView animated:NO];
   // [HomeView release];
}
-(IBAction)mapBtnClicked:(id)sender
{
    MapViewController *MApViewd=[[MapViewController alloc]initWithMapView:nameOfCity andLat:lat andLong:Long];
    [self.navigationController pushViewController:MApViewd animated:YES];
    //[MApViewd release];
}


-(IBAction)cityGuideDownloads:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Do you want to download this city" message:nil delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No",nil];
    alert.tag=2;
    [alert show];
}

-(IBAction)DownloadBtnClicked:(id)sender
{
   NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=1000000&sensor=true&key=AIzaSyAtoZuIwmbR7sZUt8VHiQYr0Nx7SAFjC5Y&types=night_club|bar",lat,Long];
    // NSString *newUrlstr=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=1000000&sensor=true&key=AIzaSyCTFrT9evA_oUau7wJ9KF-i-UNQldAHff4&types=bar",lat,Long];
    NSURL *googleRequestURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];        
    //  NSData *data=[jsonClass postDataToUrl:URL string:@"json"];
    activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    [self.view addSubview:actView];
    [activity setFrame:CGRectMake((320-30)/2, (460-30)/2, 30, 30)];
    [actView setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]];
    [actView addSubview:activity];
    
    [activity startAnimating];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        if (data)
        {
            [activity stopAnimating];
            [actView removeFromSuperview];
            NSLog(@"Device is connected to the internet");
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Do you want to download this city" message:nil delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No",nil];
            alert.tag=1;
            [alert show];
        }
        else{
            
            NSLog(@"Device is not connected to the internet");
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry Internet Connection is not available" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
    });
}

#pragma mark- uialertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *butTitle=[alertView buttonTitleAtIndex:buttonIndex];
    if (alertView.tag==1) {
        if ([butTitle isEqualToString:@"Yes"]) {
            activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            actView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
            [self.view addSubview:actView];
            [activity setFrame:CGRectMake((320-30)/2, (460-30)/2, 30, 30)];
            [actView setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]];
            [actView addSubview:activity];
            
            [activity startAnimating];
            
            [self performSelector:@selector(downloadData) withObject:nil afterDelay:5];
        }
    }
    else if(alertView.tag==2){
        if ([butTitle isEqualToString:@"Yes"]){
            activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            actView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
            [self.view addSubview:actView];
            [activity setFrame:CGRectMake((320-30)/2, (460-30)/2, 30, 30)];
            [actView setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]];
            [actView addSubview:activity];
            
            [activity startAnimating];
            [self recieveValidation:0];
         
               }
    }
}

-(void)restaurantSaveInDataBase{
    int i=0;
    NSMutableArray *iconArr=[[NSMutableArray alloc]init];
    NSMutableArray *nameArr=[[NSMutableArray alloc]init];
    NSMutableArray *ratArr=[[NSMutableArray alloc]init];
    NSMutableArray *refArr=[[NSMutableArray alloc]init];
    NSMutableArray *addArr=[[NSMutableArray alloc]init];
    NSMutableArray *arrwp=[[NSMutableArray alloc]init];
        while (i<restaurantARR.count) {
           
           NSDictionary *Dic=[restaurantARR objectAtIndex:i];
           if (val==0&&[[Dic objectForKey:@"icon"] isEqual:@"http://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png"] ) {
                  [iconArr addObject:[Dic objectForKey:@"icon"]];
                  [ nameArr addObject:[Dic objectForKey:@"name"]];
                                
                if ([Dic objectForKey:@"rating"]!=NULL) {
                [ratArr addObject:[Dic objectForKey:@"rating"]];
                }else{
                    [ratArr addObject:@"0"];
               }
                [refArr addObject:[Dic objectForKey:@"reference"]];
               [addArr addObject:[Dic objectForKey:@"vicinity"]];    
              
           //city,type,icon,name,rating,reference,address,phoneNo,website 
    ////        for (int k=0; k<mainNameArr2.count; k++) {
    ////            placeInfo=[[placessDetailData alloc]init];
    ////            placeInfo.city=nameOfCity;
    ////            placeInfo.type=@"Restaurants";
    ////            placeInfo.icon=[iconUrlArr2 objectAtIndex:k];
    ////            placeInfo.name=[mainNameArr2 objectAtIndex:k];
    ////            placeInfo.rating=[[RatArr2 objectAtIndex:k]floatValue];
    ////            placeInfo.reference=[referArr2 objectAtIndex:k];
    ////            BOOL suc;
    ////        suc=[[tempDataBase getSharedInstance]saveCityDetailDownloadsData:placeInfo];
    ////            if (suc==YES) {
    ////                NSLog(@"data saved");
   //           }
              } 
            }
    NSLog(@"%@ %@ %@ %@ %@",iconArr,nameArr,ratArr,addArr,refArr);
  //  arrwp=[self refArrSent:refArr];
    NSLog(@"out of method");
}
-(NSMutableArray*)refArrSent:(NSMutableArray*)reArr;
{// NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=AIzaSyAtoZuIwmbR7sZUt8VHiQYr0Nx7SAFjC5Y",reference];
    NSLog(@"%@",reArr);
    NSMutableArray *arr2=[[NSMutableArray alloc]init];
    for (int i=0; i<reArr.count; i++) {
         NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=AIzaSyAtoZuIwmbR7sZUt8VHiQYr0Nx7SAFjC5Y",[reArr objectAtIndex:0]];
        NSURL *googleRequestURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]; 
        
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
            if (data)
            {
                NSLog(@"Data is comming");
                
            }
            else{
                
                NSLog(@"Device is not connected to the internet");
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry Internet Connection is not available" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
            }
        });

    }
    NSLog(@" in reff method");
    
    return reArr;
}
-(void)hotelDAtaSaveInDb{
    int i=0;
    NSMutableArray *iconArr=[[NSMutableArray alloc]init];
    NSMutableArray *nameArr=[[NSMutableArray alloc]init];
    NSMutableArray *ratArr=[[NSMutableArray alloc]init];
    NSMutableArray *refArr=[[NSMutableArray alloc]init];
    NSMutableArray *addArr=[[NSMutableArray alloc]init];
    
    while (i<restaurantARR.count) {
        
        NSDictionary *Dic=[restaurantARR objectAtIndex:i];
        if (val==0&&[[Dic objectForKey:@"icon"] isEqual:@"http://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png"] ) {
            [iconArr addObject:[Dic objectForKey:@"icon"]];
            [ nameArr addObject:[Dic objectForKey:@"name"]];
            
            if ([Dic objectForKey:@"rating"]!=NULL) {
                [ratArr addObject:[Dic objectForKey:@"rating"]];
            }else{
                [ratArr addObject:@"0"];
            }
            [refArr addObject:[Dic objectForKey:@"reference"]];
            [addArr addObject:[Dic objectForKey:@"vicinity"]]; 
        }
    }
    NSLog(@"out of second method");
    [activity stopAnimating];
    [actView removeFromSuperview];
}

-(void)recieveValidation:(int)value
{
   
    typeValue=value;
  //  for (int i=0; i<typeArr.count; i++) {
        
     //    typeArr=[[NSArray alloc]initWithObjects:@"restaurant",@"lodging",@"night_club|bar",@"restaurant|lodging|bar|night_club|hindu_temple|spa|museum|church|shopping_mall",@"shopping_mall", nil];
    NSString *url;
    if (typeValue==5) {
        NSLog(@"in return");
           [self restaurantSaveInDataBase];
        [self hotelDAtaSaveInDb];
        return;
    }else{
    if (typeValue==0) {
        url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=10000&sensor=true&key=AIzaSyAtoZuIwmbR7sZUt8VHiQYr0Nx7SAFjC5Y&types=restaurant",lat,Long];
    }else if(typeValue==1){
    url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=10000&sensor=true&key=AIzaSyAtoZuIwmbR7sZUt8VHiQYr0Nx7SAFjC5Y&types=lodging",lat,Long];
    }else if(typeValue==2){url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=10000&sensor=true&key=AIzaSyAtoZuIwmbR7sZUt8VHiQYr0Nx7SAFjC5Y&types=night_club|bar",lat,Long];}
    else if(typeValue==3){url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=10000&sensor=true&key=AIzaSyAtoZuIwmbR7sZUt8VHiQYr0Nx7SAFjC5Y&types=restaurant|lodging|bar|night_club|hindu_temple|spa|museum|church|shopping_mall",lat,Long];}
    else if(typeValue==4){url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=10000&sensor=true&key=AIzaSyAtoZuIwmbR7sZUt8VHiQYr0Nx7SAFjC5Y&types=shopping_mall",lat,Long];}
        NSURL *googleRequestURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]; 
        
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
            if (data)
            {
                NSLog(@"Device is connected to the internet");
                [self performSelectorOnMainThread:@selector(getresponsedata:) withObject:data waitUntilDone:YES];
                
            }
            else{
                
                NSLog(@"Device is not connected to the internet");
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry Internet Connection is not available" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
                [activity stopAnimating];
                [actView removeFromSuperview];
            }
        });
        
    }

}


-(void)getresponsedata:(NSData*)responseData
{
    
    

    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData 
                          
                          options:kNilOptions 
                          error:&error];
    // NSLog(@"%@",error);
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    //NSLog(@"error %@",error);
    NSLog(@"dic%i %@",typeValue,json);
    NSArray *arr=[json objectForKey:@"results"];
 //   NSLog(@" arr %@ ",arr);
    
    
    
    
    
    if (val==0) {
        NSLog(@"in values 0");
        restaurantARR=[[NSMutableArray alloc]init];
      [  restaurantARR addObject:[json objectForKey:@"results"]];
    }else if(val==1){
        NSLog(@"in values 1");
        HotelARr=[[NSMutableArray alloc]init];
        HotelARr=[[NSMutableArray alloc]initWithArray:arr];
    }else if(val==2){
        naightLifeArr=[[NSMutableArray alloc]init];
        naightLifeArr=[[NSMutableArray alloc]initWithArray:arr];
    }else if(val==3){
        AtrractionArr=[[NSMutableArray alloc]init];
        AtrractionArr=[[NSMutableArray alloc]initWithArray:arr];
    }else if(val==4){
        ShoppingArr=[[NSMutableArray alloc]init];
        ShoppingArr=[[NSMutableArray alloc]initWithArray:arr];
    }
    NSLog(@" restaurant arr %@  ",restaurantARR);
//    iconUrlArr2=[[NSMutableArray alloc]init];
//    mainNameArr2=[[NSMutableArray alloc]init];
//    RatArr2=[[NSMutableArray alloc]init];
//    referArr2=[[NSMutableArray alloc]init];
//    int i=0;

////       else if (val==1&&[[Dic objectForKey:@"icon"] isEqual:@"http://maps.gstatic.com/mapfiles/place_api/icons/lodging-71.png"] ) {
////            [iconUrlArr2 addObject:[Dic objectForKey:@"icon"]];
////            [ mainNameArr2 addObject:[Dic objectForKey:@"name"]];
////            
////            if ([Dic objectForKey:@"rating"]!=NULL) {
////                [RatArr2 addObject:[Dic objectForKey:@"rating"]];
////            }else{
////                [RatArr2 addObject:@"0"];
////            }
////            [referArr2 addObject:[Dic objectForKey:@"reference"]];
////         
////            //city,type,icon,name,rating,reference,address,phoneNo,website 
//////            for (int k=0; k<mainNameArr2.count; k++) {
//////                placeInfo=[[placessDetailData alloc]init];
//////                placeInfo.city=nameOfCity;
//////                placeInfo.type=@"Hotels";
//////                placeInfo.icon=[iconUrlArr2 objectAtIndex:k];
//////                placeInfo.name=[mainNameArr2 objectAtIndex:k];
//////                placeInfo.rating=[[RatArr2 objectAtIndex:k]floatValue];
//////                placeInfo.reference=[referArr2 objectAtIndex:k];
//////                BOOL suc;
//////                suc=[[tempDataBase getSharedInstance]saveCityDetailDownloadsData:placeInfo];
//////                if (suc==YES) {
//////                    NSLog(@"data saved");
//////                }
//////            } 
////       } else if (val==2&&[[Dic objectForKey:@"icon"] isEqual:@"http://maps.gstatic.com/mapfiles/place_api/icons/bar-71.png"] ) {
////           [iconUrlArr2 addObject:[Dic objectForKey:@"icon"]];
////           [ mainNameArr2 addObject:[Dic objectForKey:@"name"]];
////           
////           if ([Dic objectForKey:@"rating"]!=NULL) {
////               [RatArr2 addObject:[Dic objectForKey:@"rating"]];
////           }else{
////               [RatArr2 addObject:@"0"];
////           }
////           [referArr2 addObject:[Dic objectForKey:@"reference"]];
////           
////           //city,type,icon,name,rating,reference,address,phoneNo,website 
//////           for (int k=0; k<mainNameArr2.count; k++) {
//////               placeInfo=[[placessDetailData alloc]init];
//////               placeInfo.city=nameOfCity;
//////               placeInfo.type=@"Night Life";
//////               placeInfo.icon=[iconUrlArr2 objectAtIndex:k];
//////               placeInfo.name=[mainNameArr2 objectAtIndex:k];
//////               placeInfo.rating=[[RatArr2 objectAtIndex:k]floatValue];
//////               placeInfo.reference=[referArr2 objectAtIndex:k];
//////               BOOL suc;
//////               suc=[[tempDataBase getSharedInstance]saveCityDetailDownloadsData:placeInfo];
//////               if (suc==YES) {
//////                   NSLog(@"data saved");
//////               }
//////           } 
////       } else if (val==4&&([[Dic objectForKey:@"icon"] isEqual:@"http://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png"]||[[Dic objectForKey:@"icon"] isEqual:@"http://maps.gstatic.com/mapfiles/place_api/icons/shopping-71.png"])) {
////           [iconUrlArr2 addObject:[Dic objectForKey:@"icon"]];
////           [ mainNameArr2 addObject:[Dic objectForKey:@"name"]];
////           
////           if ([Dic objectForKey:@"rating"]!=NULL) {
////               [RatArr2 addObject:[Dic objectForKey:@"rating"]];
////           }else{
////               [RatArr2 addObject:@"0"];
////           }
////           [referArr2 addObject:[Dic objectForKey:@"reference"]];
////           
////           //city,type,icon,name,rating,reference,address,phoneNo,website 
//////           for (int k=0; k<mainNameArr2.count; k++) {
//////               placeInfo=[[placessDetailData alloc]init];
//////               placeInfo.city=nameOfCity;
//////               placeInfo.type=@"Shopping";
//////               placeInfo.icon=[iconUrlArr2 objectAtIndex:k];
//////               placeInfo.name=[mainNameArr2 objectAtIndex:k];
//////               placeInfo.rating=[[RatArr2 objectAtIndex:k]floatValue];
//////               placeInfo.reference=[referArr2 objectAtIndex:k];
//////               BOOL suc;
//////               suc=[[tempDataBase getSharedInstance]saveCityDetailDownloadsData:placeInfo];
//////               if (suc==YES) {
//////                   NSLog(@"data saved");
//////               }
//////           } 
////       } else if(val==3) {
////           [iconUrlArr2 addObject:[Dic objectForKey:@"icon"]];
////           [ mainNameArr2 addObject:[Dic objectForKey:@"name"]];
////           
////           if ([Dic objectForKey:@"rating"]!=NULL) {
////               [RatArr2 addObject:[Dic objectForKey:@"rating"]];
////           }else{
////               [RatArr2 addObject:@"0"];
////           }
////           [referArr2 addObject:[Dic objectForKey:@"reference"]];
////         
////           //city,type,icon,name,rating,reference,address,phoneNo,website 
//////           for (int k=0; k<mainNameArr2.count; k++) {
//////               placeInfo=[[placessDetailData alloc]init];
//////               placeInfo.city=nameOfCity;
//////               placeInfo.type=@"Attractions";
//////               placeInfo.icon=[iconUrlArr2 objectAtIndex:k];
//////               placeInfo.name=[mainNameArr2 objectAtIndex:k];
//////               placeInfo.rating=[[RatArr2 objectAtIndex:k]floatValue];
//////               placeInfo.reference=[referArr2 objectAtIndex:k];
//////               BOOL suc;
//////               suc=[[tempDataBase getSharedInstance]saveCityDetailDownloadsData:placeInfo];
//////               if (suc==YES) {
//////                   NSLog(@"data saved");
//////               }
//////           } 
////       }   
//        
//    }
    val=val+1;
    [self recieveValidation:val];
}


/*
-(void)recivedData:(NSData*)response
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:response 
                          
                          options:kNilOptions 
                          error:&error];
    // NSLog(@"%@",error);
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    //NSLog(@"error %@",error);
    NSLog(@"dic%i %@",typeValue,json);
    
    // hotels  http://maps.gstatic.com/mapfiles/place_api/icons/lodging-71.png
    
    // night life http://maps.gstatic.com/mapfiles/place_api/icons/bar-71.png
    
    NSArray *arr=[json objectForKey:@"results"];
    
    restaurantARR=[[NSMutableArray alloc]init];
    HotelARr=[[NSMutableArray alloc]init];
    naightLifeArr=[[NSMutableArray alloc]init];
    AtrractionArr=[[NSMutableArray alloc]init];
    ShoppingArr=[[NSMutableArray alloc]init];
    NSArray *allData=[[tempDataBase getSharedInstance]reciveAllCityDetailDownlaodsData];
    
    int i=0;
    while (i<arr.count) {
        
        NSDictionary *Dic=[arr objectAtIndex:i];
        if ([[Dic objectForKey:@"icon"] isEqual:@"http://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png"] ) {
            
            if (allData.count>0) {
            NSArray *dpName=[[tempDataBase getSharedInstance]checkDuplicateNames:nameOfCity andtype:@"Restaurants"];
            if (dpName.count>0) {
                
            for (int j=0; j<dpName.count; j++) {
                if ([[dpName objectAtIndex:j] isEqualToString:[Dic objectForKey:@"name"]]) {
                    NSLog(@"duplicate name");
                }else{
                    [iconUrlArr2 addObject:[Dic objectForKey:@"icon"]];
                    [ mainNameArr2 addObject:[Dic objectForKey:@"name"]];
                    
                    if ([Dic objectForKey:@"rating"]!=NULL) {
                        [RatArr2 addObject:[Dic objectForKey:@"rating"]];
                    }else{
                        [RatArr2 addObject:@"0"];
                    }
                    [referArr2 addObject:[Dic objectForKey:@"reference"]];
                    
                    type=@"Restaurants";
                    
                     //city,type,icon,name,rating,reference,address,phoneNo,website 
                    for (int k=0; k<iconUrlArr2.count; k++) {
                    placeInfo=[[placessDetailData alloc]init];
                    placeInfo.city=nameOfCity;
                    placeInfo.type=@"Restaurants";
                        placeInfo.icon=[iconUrlArr2 objectAtIndex:k];
                        placeInfo.name=[mainNameArr2 objectAtIndex:k];
                        placeInfo.rating=[[RatArr2 objectAtIndex:k]floatValue];
                        placeInfo.reference=[referArr2 objectAtIndex:k];
                        BOOL suc;
                        suc=[[tempDataBase getSharedInstance]saveCityDetailDownloadsData:placeInfo];
                    } 
                }
            }
            }
            }else{
                [iconUrlArr2 addObject:[Dic objectForKey:@"icon"]];
                [ mainNameArr2 addObject:[Dic objectForKey:@"name"]];
                
                if ([Dic objectForKey:@"rating"]!=NULL) {
                    [RatArr2 addObject:[Dic objectForKey:@"rating"]];
                }else{
                    [RatArr2 addObject:@"0"];
                }
                [referArr2 addObject:[Dic objectForKey:@"reference"]];
                
                type=@"Restaurants";
                
                //city,type,icon,name,rating,reference,address,phoneNo,website 
                for (int k=0; k<iconUrlArr2.count; k++) {
                    placeInfo=[[placessDetailData alloc]init];
                    placeInfo.city=nameOfCity;
                    placeInfo.type=@"Restaurants";
                    placeInfo.icon=[iconUrlArr2 objectAtIndex:k];
                    placeInfo.name=[mainNameArr2 objectAtIndex:k];
                    placeInfo.rating=[[RatArr2 objectAtIndex:k]floatValue];
                    placeInfo.reference=[referArr2 objectAtIndex:k];
                    BOOL suc;
                    suc=[[tempDataBase getSharedInstance]saveCityDetailDownloadsData:placeInfo];
                } 
            }
        }else if([[Dic objectForKey:@"icon"] isEqual:@"http://maps.gstatic.com/mapfiles/place_api/icons/lodging-71.png"] )
        {if (allData.count>0) {
            NSArray *dpName=[[tempDataBase getSharedInstance]checkDuplicateNames:nameOfCity andtype:@"Hotels"];
            if (dpName.count>0) {
                
                for (int j=0; j<dpName.count; j++) {
                    if ([[dpName objectAtIndex:j] isEqualToString:[Dic objectForKey:@"name"]]) {
                        NSLog(@"duplicate name");
                }else{
                    [iconUrlArr2 addObject:[Dic objectForKey:@"icon"]];
                    [ mainNameArr2 addObject:[Dic objectForKey:@"name"]];
            
                    if ([Dic objectForKey:@"rating"]!=NULL) {
                        [RatArr2 addObject:[Dic objectForKey:@"rating"]];
                    }else{
                        [RatArr2 addObject:@"0"];
                    }
                    [referArr2 addObject:[Dic objectForKey:@"reference"]];
            
                    type=@"Hotels";
                    for (int k=0; k<iconUrlArr2.count; k++) {
                        placeInfo=[[placessDetailData alloc]init];
                        placeInfo.city=nameOfCity;
                        placeInfo.type=@"Hotels";
                        placeInfo.icon=[iconUrlArr2 objectAtIndex:k];
                        placeInfo.name=[mainNameArr2 objectAtIndex:k];
                        placeInfo.rating=[[RatArr2 objectAtIndex:k]floatValue];
                        placeInfo.reference=[referArr2 objectAtIndex:k];
                        BOOL suc;
                        suc=[[tempDataBase getSharedInstance]saveCityDetailDownloadsData:placeInfo];
                    }
                    }
                }
            }else{
                [iconUrlArr2 addObject:[Dic objectForKey:@"icon"]];
                [ mainNameArr2 addObject:[Dic objectForKey:@"name"]];
                
                if ([Dic objectForKey:@"rating"]!=NULL) {
                    [RatArr2 addObject:[Dic objectForKey:@"rating"]];
                }else{
                    [RatArr2 addObject:@"0"];
                }
                [referArr2 addObject:[Dic objectForKey:@"reference"]];
                
                type=@"Restaurants";
                
                //city,type,icon,name,rating,reference,address,phoneNo,website 
                for (int k=0; k<iconUrlArr2.count; k++) {
                    placeInfo=[[placessDetailData alloc]init];
                    placeInfo.city=nameOfCity;
                    placeInfo.type=@"Hotels";
                    placeInfo.icon=[iconUrlArr2 objectAtIndex:k];
                    placeInfo.name=[mainNameArr2 objectAtIndex:k];
                    placeInfo.rating=[[RatArr2 objectAtIndex:k]floatValue];
                    placeInfo.reference=[referArr2 objectAtIndex:k];
                    BOOL suc;
                    suc=[[tempDataBase getSharedInstance]saveCityDetailDownloadsData:placeInfo];
                } 
            }
        }
        }else if([[Dic objectForKey:@"icon"] isEqual:@"http://maps.gstatic.com/mapfiles/place_api/icons/bar-71.png"] )
        {if (allData.count>0) {
            NSArray *dpName=[[tempDataBase getSharedInstance]checkDuplicateNames:nameOfCity andtype:@"Night Life"];
            if (dpName.count>0) {
                
                for (int j=0; j<dpName.count; j++) {
                    if ([[dpName objectAtIndex:j] isEqualToString:[Dic objectForKey:@"name"]]) {
                        NSLog(@"duplicate name");
                    }else{
                        [iconUrlArr2 addObject:[Dic objectForKey:@"icon"]];
                        [ mainNameArr2 addObject:[Dic objectForKey:@"name"]];
            
                        if ([Dic objectForKey:@"rating"]!=NULL) {
                            [RatArr2 addObject:[Dic objectForKey:@"rating"]];
                        }else{
                            [RatArr2 addObject:@"0"];
                        }
                        [referArr2 addObject:[Dic objectForKey:@"reference"]];
                        type=@"Night Life";
                        for (int k=0; k<iconUrlArr2.count; k++) {
                            placeInfo=[[placessDetailData alloc]init];
                            placeInfo.city=nameOfCity;
                            placeInfo.type=@"Night Life";
                            placeInfo.icon=[iconUrlArr2 objectAtIndex:k];
                            placeInfo.name=[mainNameArr2 objectAtIndex:k];
                            placeInfo.rating=[[RatArr2 objectAtIndex:k]floatValue];
                            placeInfo.reference=[referArr2 objectAtIndex:k];
                            BOOL suc;
                            suc=[[tempDataBase getSharedInstance]saveCityDetailDownloadsData:placeInfo];
                        }
                    }
                }
            }
        } else{
            [iconUrlArr2 addObject:[Dic objectForKey:@"icon"]];
            [ mainNameArr2 addObject:[Dic objectForKey:@"name"]];
            
            if ([Dic objectForKey:@"rating"]!=NULL) {
                [RatArr2 addObject:[Dic objectForKey:@"rating"]];
            }else{
                [RatArr2 addObject:@"0"];
            }
            [referArr2 addObject:[Dic objectForKey:@"reference"]];
            
            type=@"Restaurants";
            
            //city,type,icon,name,rating,reference,address,phoneNo,website 
            for (int k=0; k<iconUrlArr2.count; k++) {
                placeInfo=[[placessDetailData alloc]init];
                placeInfo.city=nameOfCity;
                placeInfo.type=@"Night Life";
                placeInfo.icon=[iconUrlArr2 objectAtIndex:k];
                placeInfo.name=[mainNameArr2 objectAtIndex:k];
                placeInfo.rating=[[RatArr2 objectAtIndex:k]floatValue];
                placeInfo.reference=[referArr2 objectAtIndex:k];
                BOOL suc;
                suc=[[tempDataBase getSharedInstance]saveCityDetailDownloadsData:placeInfo];
            } 
        }
        }
        else if(([[Dic objectForKey:@"icon"] isEqual:@"http://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png"]||[[Dic objectForKey:@"icon"] isEqual:@"http://maps.gstatic.com/mapfiles/place_api/icons/shopping-71.png"]))
        {if (allData.count>0) {
            NSArray *dpName=[[tempDataBase getSharedInstance]checkDuplicateNames:nameOfCity andtype:@"Shopping"];
            if (dpName.count>0) {
                
                for (int j=0; j<dpName.count; j++) {
                    if ([[dpName objectAtIndex:j] isEqualToString:[Dic objectForKey:@"name"]]) {
                        NSLog(@"duplicate name");
                    }else{
                        [iconUrlArr2 addObject:[Dic objectForKey:@"icon"]];
                        [ mainNameArr2 addObject:[Dic objectForKey:@"name"]];
            
                        if ([Dic objectForKey:@"rating"]!=NULL) {
                            [RatArr2 addObject:[Dic objectForKey:@"rating"]];
                        }else{
                            [RatArr2 addObject:@"0"];
                        }
                        [referArr2 addObject:[Dic objectForKey:@"reference"]];
            
                        type=@"Shopping";
                        for (int k=0; k<iconUrlArr2.count; k++) {
                            placeInfo=[[placessDetailData alloc]init];
                            placeInfo.city=nameOfCity;
                            placeInfo.type=@"Shopping";
                            placeInfo.icon=[iconUrlArr2 objectAtIndex:k];
                            placeInfo.name=[mainNameArr2 objectAtIndex:k];
                            placeInfo.rating=[[RatArr2 objectAtIndex:k]floatValue];
                            placeInfo.reference=[referArr2 objectAtIndex:k];
                            BOOL suc;
                            suc=[[tempDataBase getSharedInstance]saveCityDetailDownloadsData:placeInfo];
                        }
                    }
                }
            }
        }else{
            [iconUrlArr2 addObject:[Dic objectForKey:@"icon"]];
            [ mainNameArr2 addObject:[Dic objectForKey:@"name"]];
            
            if ([Dic objectForKey:@"rating"]!=NULL) {
                [RatArr2 addObject:[Dic objectForKey:@"rating"]];
            }else{
                [RatArr2 addObject:@"0"];
            }
            [referArr2 addObject:[Dic objectForKey:@"reference"]];
            
            type=@"Restaurants";
            
            //city,type,icon,name,rating,reference,address,phoneNo,website 
            for (int k=0; k<iconUrlArr2.count; k++) {
                placeInfo=[[placessDetailData alloc]init];
                placeInfo.city=nameOfCity;
                placeInfo.type=@"Shopping";
                placeInfo.icon=[iconUrlArr2 objectAtIndex:k];
                placeInfo.name=[mainNameArr2 objectAtIndex:k];
                placeInfo.rating=[[RatArr2 objectAtIndex:k]floatValue];
                placeInfo.reference=[referArr2 objectAtIndex:k];
                BOOL suc;
                suc=[[tempDataBase getSharedInstance]saveCityDetailDownloadsData:placeInfo];
            } 
        }
        }

        else
        {  
            if (allData.count>0) {
            NSArray *dpName=[[tempDataBase getSharedInstance]checkDuplicateNames:nameOfCity andtype:@"Attractions"];
            if (dpName.count>0) {
                
                for (int j=0; j<dpName.count; j++) {
                    if ([[dpName objectAtIndex:j] isEqualToString:[Dic objectForKey:@"name"]]) {
                        NSLog(@"duplicate name");
                    }else{
                        [iconUrlArr2 addObject:[Dic objectForKey:@"icon"]];
                        [ mainNameArr2 addObject:[Dic objectForKey:@"name"]];
            
                        if ([Dic objectForKey:@"rating"]!=NULL)     {
                            [RatArr2 addObject:[Dic objectForKey:@"rating"]];
                        }else{
                            [RatArr2 addObject:@"0"];
                        }
                        [referArr2 addObject:[Dic objectForKey:@"reference"]];
            
                        type=@"Attractions";
                        for (int k=0; k<iconUrlArr2.count; k++) {
                            placeInfo=[[placessDetailData alloc]init];
                            placeInfo.city=nameOfCity;
                            placeInfo.type=@"Attractions";
                            placeInfo.icon=[iconUrlArr2 objectAtIndex:k];
                            placeInfo.name=[mainNameArr2 objectAtIndex:k];
                            placeInfo.rating=[[RatArr2 objectAtIndex:k]floatValue];
                            placeInfo.reference=[referArr2 objectAtIndex:k];
                            BOOL suc;
                            suc=[[tempDataBase getSharedInstance]saveCityDetailDownloadsData:placeInfo];
                        }
                    }
                }
            }
            
            } else{
                [iconUrlArr2 addObject:[Dic objectForKey:@"icon"]];
                [ mainNameArr2 addObject:[Dic objectForKey:@"name"]];
                
                if ([Dic objectForKey:@"rating"]!=NULL) {
                    [RatArr2 addObject:[Dic objectForKey:@"rating"]];
                }else{
                    [RatArr2 addObject:@"0"];
                }
                [referArr2 addObject:[Dic objectForKey:@"reference"]];
                
             //   type=@"Restaurants";
                
                //city,type,icon,name,rating,reference,address,phoneNo,website 
                for (int k=0; k<iconUrlArr2.count; k++) {
                    placeInfo=[[placessDetailData alloc]init];
                    placeInfo.city=nameOfCity;
                    placeInfo.type=@"Attractions";
                    placeInfo.icon=[iconUrlArr2 objectAtIndex:k];
                    placeInfo.name=[mainNameArr2 objectAtIndex:k];
                    placeInfo.rating=[[RatArr2 objectAtIndex:k]floatValue];
                    placeInfo.reference=[referArr2 objectAtIndex:k];
                    BOOL suc;
                    suc=[[tempDataBase getSharedInstance]saveCityDetailDownloadsData:placeInfo];
                } 
            }       //
    }
        i++;
    }

   
}
*/
-(void)downloadData
{
   
     NSArray *arr=[[tempDataBase getSharedInstance]receiveAllDownloadData];
    int conter=arr.count;
    if (arr.count>0) {
        
    
    NSArray *cities=[[tempDataBase getSharedInstance]receiveAllDownloadcity];
    for (int j=0; j<cities.count; j++) {
        if ([[cities objectAtIndex:j]isEqualToString:nameOfCity]) {
            NSLog(@"duplicate data");
            
        }
    }
        [activity stopAnimating];
        [actView removeFromSuperview];
        UIAlertView *dupli=[[UIAlertView alloc]initWithTitle:@"This city is already downloaded" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [dupli show];

    }else{          BOOL suc;
                suc=[[tempDataBase getSharedInstance]savedatainDownloads:nameOfCity andDownlaods:conter+1];
               if (suc==YES) {
                    NSLog(@"data is saved");
                   UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"City is downloaded" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                   [alert show];
                 }
    BOOL update;
    update=[[tempDataBase getSharedInstance]updateDownloadCounter:arr.count andContervalue2:conter+1 ]; 
    if (update==YES) {
        NSLog(@"data is updated");
    }
    NSLog(@" conter %i",conter+1);
     NSArray *arr1=[[tempDataBase getSharedInstance]receiveAllDownloadData];
    NSLog(@"%@ arr2 data",arr1);
    
        [activity stopAnimating];
        [actView removeFromSuperview];
    }
    
}

-(IBAction)MoreBtnCliked:(id)sender
{
    UIPopoverController *pop=[[UIPopoverController alloc]initWithContentViewController:myTableView];
    [pop setDelegate:self];
    pop.popoverContentSize=CGSizeMake(150, 200);
    [pop presentPopoverFromRect:More.frame inView:btnsCOntView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}
#pragma mark - View lifecycle

-(void)dealloc
{
    [super dealloc];
   // [cell release];
    
}

- (void)viewDidLoad
{
    NSLog(@"in viewdidload");
    
    [super viewDidLoad];
    val=0;
      More.tag=1;
    
//    UIImageView *logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(80, 8, 25, 25)];
//    logoImage.image=[UIImage imageNamed:@"logo.png"];
//    [self.navigationController.navigationBar addSubview:logoImage];
//    
//    UILabel *head=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, 120, 20)];
//    [head setText:@"Travel Guide"];
//    [head setBackgroundColor:[UIColor clearColor]];
//    [head setTextColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar addSubview:head];

    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.01 green:0.01 blue:0.25 alpha:1]];
    imageName=[[ExistingDatabase getsharedInstance]ReceivecityImagesWithCityName:nameOfCity];
    NSLog(@"images name %@",imageName);
    
    cityImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",imageName]];
    
    HomeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    HomeBtn.frame=CGRectMake(210, -5, 60, 50);
   
    [HomeBtn setImage:[UIImage imageNamed:@"home_icon.png"] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:HomeBtn];
    [HomeBtn addTarget:self action:@selector(HomeBtnCliked) forControlEvents:UIControlEventTouchUpInside];
    
   // backBtn=[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    [self.navigationItem setLeftBarButtonItem:backBtn];
    rightBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"share" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClicked)];
    [self.navigationItem setRightBarButtonItem:rightBarBtn];
    
    
    [lab setText:[NSString stringWithFormat:@" %@",nameOfCity]];
 
    
    typeArr=[[NSArray alloc]initWithObjects:@"restaurant",@"lodging",@"night_club|bar",@"restaurant|lodging|bar|night_club|hindu_temple|spa|museum|church|shopping_mall",@"shopping_mall", nil];
    tableArr=[[NSMutableArray alloc]initWithObjects:@"Restaurants",@"Hotels",@"Night Life",@"Attractions",@"Shopping",nil];
    imgArr=[[NSArray alloc]initWithObjects:@"Restaurant.png",@"hotel.png",@"night.png",@"attr.png",@"shopping.jpg", nil];
    LangCodeArr=[[NSArray alloc]initWithObjects:@"ar",@"eu",@"bg",@"bn",@"ca",@"cs",@"da",@"de",@"el",@"en",@"en-AU",@"en-GB",@"es",@"eu",@"fa",@"fi",@"fil",@"fr",@"gl",@"gu",@"hi",@"hr",@"hu",@"id",@"it",@"iw",@"ja",@"kn",@"ko",@"lt",@"lv",@"ml",@"mr",@"nl",@"nn",@"no",@"or",@"pl",@"pt",@"pt-BR",@"pt-PT",@"rm",@"ro",@"ru",@"sk",@"sl",@"sr",@"sv",@"tl",@"ta",@"te",@"th",@"tr",@"uk",@"vi",@"zh-CN",@"zh-TW", nil];
    langArr=[[NSArray alloc]initWithObjects:@"ARABIC",@"BASQUE",@"BULGARIAN",@"BENGALI",@"CATALAN",@"CZECH",@"DANISH",@"GERMAN",@"GREEK",@"ENGLISH",@"ENGLISH (AUSTRALIAN)",@"ENGLISH (GREAT BRITAIN)",@"SPANISH",@"BASQUE",@"FARSI",@"FINNISH",@"FILIPINO",@"FRENCH",@"GALICIAN",@"GUJARATI",@"HINDI",@"CROATIAN",@"HUNGARIAN",@"INDONESIAN",@"ITALIAN",@"HEBREW",@"JAPANESE",@"KANNADA",@"KOREAN",@"LITHUANIAN",@"LATVIAN",@"MALAYALAM",@"MARATHI",@"DUTCH",@"NORWEGIAN NYNORSK",@"NORWEGIAN",@"ORIYA",@"POLISH",@"PORTUGUESE",@"PORTUGUESE (BRAZIL)",@"PORTUGUESE (PORTUGAL)",@"ROMANSCH",@"ROMANIAN",@"RUSSIAN",@"SLOVAK",@"SLOVENIAN",@"SERBIAN",@"SWEDISH",@"TAGALOG",@"TAMIL",@"TELUGU",@"THAI",@"TURKISH",@"UKRAINIAN",@"VIETNAMESE",@"CHINESE (SIMPLIFIED)",@"CHINESE (TRADITIONAL)", nil];
    // Do any additional setup after loading the view from its nib.
}

-(void)shareBtnClicked
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"share information" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alert show];
}

#pragma mark- tableview data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"cell";
    cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text=[tableArr objectAtIndex:indexPath.row];
    cell.imageView.image=[UIImage imageNamed:[imgArr objectAtIndex:indexPath.row]];
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    cell.backgroundColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    //    cell.imageView.layer.cornerRadius=30;
    //    cell.imageView.layer.masksToBounds=YES;
    cell.textLabel.font=[UIFont fontWithName:@"verdana" size:20];

    cell.textLabel.textColor=[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor=[UIColor colorWithRed:0.25 green:0.01 blue:0.01 alpha:0.05];
    [cell.textLabel setFont:[UIFont fontWithName:@"verdana" size:18]];
   
    return cell;
}

#pragma mark-tableviewdelegates

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{//browser key==AIzaSyCTFrT9evA_oUau7wJ9KF-i-UNQldAHff4
    //https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=1000000&sensor=true&key=AIzaSyCTFrT9evA_oUau7wJ9KF-i-UNQldAHff4&types=restaurant|lodging|bar|night_club|hindu_temple|spa|museum|church|shopping_mall*language=ar
    //restaurant|lodging|bar|night_club|hindu_temple|spa|museum|church|shopping_mall
    //"112","Asia","India","Mumbai","18.9750","72.8258"

    //radius=1000000
   // NSArray* places;
    
    //new browser key==AIzaSyBJGHTDQzq7-hxwfA9cLmt32hRYgCSLQ9M

    //mahendra browser key==AIzaSyAtoZuIwmbR7sZUt8VHiQYr0Nx7SAFjC5Y
    
    //mahi browser new key==AIzaSyBYEVE9L4Ca8QAP2b9VeuY_ZutoBfNEWtE
    myactivityView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, table.frame.size.width, table.frame.size.height)];
    
   // UITableViewCell *cellview=[tableView cellForRowAtIndexPath:indexPath];
    indicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame=CGRectMake(320/2-30, myactivityView.frame.size.height/2-50, 50, 50);
   // cellview.accessoryView=indicator;
    [myactivityView addSubview:indicator];
    //indicator.center=myactivityView.center;
    [indicator startAnimating];
   // [indicator release];
    [myactivityView setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5]];
    [table addSubview:myactivityView];
   // [myactivityView release];
    
    rowText=[[NSString alloc]init];
    rowText=[NSString stringWithFormat:@"%@",[tableArr objectAtIndex:indexPath.row]];
    if ([rowText isEqualToString:@"Restaurants"]) {
        rowValue=1;
    }else if([rowText isEqualToString:@"Hotels"]){
    rowValue=2;
    }else if([rowText isEqualToString:@"Night Life"]){
        rowValue=3;
    }else if([rowText isEqualToString:@"Attractions"]){
        rowValue=4;
    }else if([rowText isEqualToString:@"Shopping"]){
        rowValue=5;
    }
    NSLog(@" arr value %@",rowText);
   // NSLog(@" row text %@ ",[tableView cellForRowAtIndexPath:indexPath].textLabel.text );
    
    NSString *url;
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Night Life"]) {
        url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=100000&sensor=true&key=AIzaSyCTFrT9evA_oUau7wJ9KF-i-UNQldAHff4&types=night_club|bar",lat,Long];
       // NSString *newUrlstr=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=1000000&sensor=true&key=AIzaSyCTFrT9evA_oUau7wJ9KF-i-UNQldAHff4&types=bar",lat,Long];
       NSURL *googleRequestURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];        
      //  NSData *data=[jsonClass postDataToUrl:URL string:@"json"];
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
            if (data)
            {
                NSLog(@"Device is connected to the internet");
                [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
            }
            else{
                [indicator stopAnimating];
                [myactivityView removeFromSuperview];
                NSLog(@"Device is not connected to the internet");
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry Internet Connection is not available" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
            }
        });
        
    }
    
    else if([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Attractions"]){
        url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=100000&sensor=true&key=AIzaSyCTFrT9evA_oUau7wJ9KF-i-UNQldAHff4&types=restaurant|lodging|bar|night_club|hindu_temple|spa|museum|church|shopping_mall",lat,Long];
        // NSString *newUrlstr=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=1000000&sensor=true&key=AIzaSyCTFrT9evA_oUau7wJ9KF-i-UNQldAHff4&types=bar",lat,Long];
         NSURL *googleRequestURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
        //  NSData *data=[jsonClass postDataToUrl:URL string:@"json"];
        
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
            if (data)
            {
                NSLog(@"Device is connected to the internet");
                [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
            }
            else{
                [indicator stopAnimating];
                [myactivityView removeFromSuperview];
                NSLog(@"Device is not connected to the internet");
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry Internet Connection is not available" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
            }
        });
    }
    
    else{
        
    url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=100000&sensor=true&key=AIzaSyCTFrT9evA_oUau7wJ9KF-i-UNQldAHff4&types=%@",lat,Long,[typeArr objectAtIndex:indexPath.row]];
        NSLog(@"%@",url);
      //  NSURL *URL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
   // NSData *data=[jsonClass postDataToUrl:URL string:@"json"];
   NSURL *googleRequestURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
            if (data)
            {
                NSLog(@"Device is connected to the internet");
            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
            }
            else{
                [indicator stopAnimating];
            [myactivityView removeFromSuperview];
                NSLog(@"Device is not connected to the internet");
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry Internet Connection is not available" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
            }
        });


    }
  
   
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *urlStr=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=1000000&sensor=true&key=AIzaSyCTFrT9evA_oUau7wJ9KF-i-UNQldAHff4&types=lodging",lat,Long];
//    NSURL *URL=[NSURL URLWithString:urlStr];
//    NSData *data=[jsonClass postDataToUrl:URL string:@"json"];
//    NSError *err;
//    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
//    icon=[[NSMutableArray alloc]init];
//    icon=[dic objectForKey:@"results"];
//  
//    
//     NSLog(@"%@ cityname  ,%@ title",nameOfCity,[tableView cellForRowAtIndexPath:indexPath].textLabel.text);
//    cityDetailViewController *detailView=[[cityDetailViewController alloc]initWithicon:icon andWithCityNAme:nameOfCity andWithTitle:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
//   // [self.navigationController presentModalViewController:detailView animated:NO];
//   [self.navigationController pushViewController:detailView animated:YES];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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
    //NSLog(@"error %@",error);
   NSLog(@"dic %@",json);
   
// hotels  http://maps.gstatic.com/mapfiles/place_api/icons/lodging-71.png
    
    // night life http://maps.gstatic.com/mapfiles/place_api/icons/bar-71.png
    
    NSArray *arr=[json objectForKey:@"results"];
    iconUrlArr=[[NSMutableArray alloc]init];
    mainNameArr=[[NSMutableArray alloc]init];
    RatArr=[[NSMutableArray alloc]init];
    referArr=[[NSMutableArray alloc]init];
    int i=0;
    while (i<arr.count) {
        
        NSDictionary *Dic=[arr objectAtIndex:i];
        if (rowValue==1 &&[[Dic objectForKey:@"icon"] isEqual:@"http://maps.gstatic.com/mapfiles/place_api/icons/restaurant-71.png"] ) {
            [iconUrlArr addObject:[Dic objectForKey:@"icon"]];
            [ mainNameArr addObject:[Dic objectForKey:@"name"]];
            
            if ([Dic objectForKey:@"rating"]!=NULL) {
                [RatArr addObject:[Dic objectForKey:@"rating"]];
            }else{
                [RatArr addObject:@"0"];
            }
            [referArr addObject:[Dic objectForKey:@"reference"]];
            
            type=@"Restaurants";
            
         //   BOOL succes;
           // NSLog(@" name of city %@",nameOfCity);
           // succes=[ExistingDatabase getsharedInstance]saveDataofCityDetail:nameOfCity withTyp:@"Restaurants" lat:latitude Long:Longitude iconUrl:[Dic objectForKey:@"icon"] name:[Dic objectForKey:@"name"] rating:<#(float)#> reference:<#(NSString *)#>
           
        }else if(rowValue==2 && [[Dic objectForKey:@"icon"] isEqual:@"http://maps.gstatic.com/mapfiles/place_api/icons/lodging-71.png"] )
        {
            [iconUrlArr addObject:[Dic objectForKey:@"icon"]];
            [ mainNameArr addObject:[Dic objectForKey:@"name"]];
            
            if ([Dic objectForKey:@"rating"]!=NULL) {
                [RatArr addObject:[Dic objectForKey:@"rating"]];
            }else{
                [RatArr addObject:@"0"];
            }
            [referArr addObject:[Dic objectForKey:@"reference"]];
          
            type=@"Hotels";
            
           
        }else if(rowValue==3 && [[Dic objectForKey:@"icon"] isEqual:@"http://maps.gstatic.com/mapfiles/place_api/icons/bar-71.png"] )
        {
            [iconUrlArr addObject:[Dic objectForKey:@"icon"]];
            [ mainNameArr addObject:[Dic objectForKey:@"name"]];
            
            if ([Dic objectForKey:@"rating"]!=NULL) {
                [RatArr addObject:[Dic objectForKey:@"rating"]];
            }else{
                [RatArr addObject:@"0"];
            }
            [referArr addObject:[Dic objectForKey:@"reference"]];
            type=@"Night Life";
                      
            
        }else if(rowValue==4 )
        {
            [iconUrlArr addObject:[Dic objectForKey:@"icon"]];
            [ mainNameArr addObject:[Dic objectForKey:@"name"]];
            
            if ([Dic objectForKey:@"rating"]!=NULL) {
                [RatArr addObject:[Dic objectForKey:@"rating"]];
            }else{
                [RatArr addObject:@"0"];
            }
            [referArr addObject:[Dic objectForKey:@"reference"]];
           
           type=@"Attractions";
            
        }else if(rowValue==5 && ([[Dic objectForKey:@"icon"] isEqual:@"http://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png"]||[[Dic objectForKey:@"icon"] isEqual:@"http://maps.gstatic.com/mapfiles/place_api/icons/shopping-71.png"]))
        {
            [iconUrlArr addObject:[Dic objectForKey:@"icon"]];
            [ mainNameArr addObject:[Dic objectForKey:@"name"]];
            
            if ([Dic objectForKey:@"rating"]!=NULL) {
                [RatArr addObject:[Dic objectForKey:@"rating"]];
            }else{
                [RatArr addObject:@"0"];
            }
            [referArr addObject:[Dic objectForKey:@"reference"]];
          
            type=@"Shopping";
            
        }
            //
       
        i++;
    }

   
    cityDetailViewController *detailCityView=[[cityDetailViewController alloc]initWithicon:iconUrlArr name:mainNameArr rating:RatArr reference:referArr andwithCityName:nameOfCity withType:type];    //[self.view addSubview:detailCityView.view];
    [indicator stopAnimating];
    [myactivityView removeFromSuperview];
    [indicator release];
    [myactivityView release];
    [self.navigationController pushViewController:detailCityView animated:YES];
   // [detailCityView release];
    NSLog(@"in fetch       *************************        ");
}
//-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 45;
//}

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
