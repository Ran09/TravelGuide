//
//  DownloadGuideViewController.h
//  MyCityGuide
//
//  Created by Mac on 20/03/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadGuideViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIImageView *imgView;
    IBOutlet UILabel *lab;
   
    IBOutlet UILabel *sizeLaB;
    NSString *nameImg;
    NSString *titleText;
    IBOutlet UITableView *CityTable;
    NSMutableArray *cityArr;
    UIButton *HomeBtn;
    NSMutableArray *CityImageArr;
    
    UIButton *shareBtn;
    UIBarButtonItem *backBtn;
    UIBarButtonItem *rightBarBtn;
   
    UITableViewCell *cell;
    IBOutlet UILabel *downlodedGuide;
    IBOutlet UILabel *mostViewdCity;
}
@property(nonatomic,retain)NSString *titleText;

-(id)initWithImageName:(NSString*)titlelab;
-(id)initWithImageName:(NSString*)titlelab andWithArr:(NSMutableArray*)arr andWithImageArr:(NSMutableArray*)imgeArr;

@end
