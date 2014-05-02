//
//  cityGuideController.h
//  MyCityGuide
//
//  Created by Mac on 16/03/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cityGuideController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *CityTable;
    UITableViewCell *cell;
    NSString *titleStr;
    UIImage *img;
    NSMutableArray *cityArr;
    UIButton *HomeBtn;
  
    UIButton *shareBtn;
    UIBarButtonItem *backBtn;
    UIBarButtonItem *rightBarBtn;
    
}
-(id)initWithTitle:(NSString*)titleCity andWithCityArr:(NSMutableArray*)Arr;
@end
