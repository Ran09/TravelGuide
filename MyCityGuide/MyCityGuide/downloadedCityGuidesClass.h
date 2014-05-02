//
//  downloadedCityGuidesClass.h
//  TravelGuide
//
//  Created by Mac on 28/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface downloadedCityGuidesClass : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UILabel *headerLable;
    IBOutlet UITableView *downloadedCityTable;
    NSArray *downloadedCityArr;
    NSString *ViewHeading;
    UIButton *HomeBtn;
    UIBarButtonItem *backBtn;
    UIBarButtonItem *rightBarBtn;
}
-(id)initWithNameofHederView:(NSString*)nameHead andTableArr:(NSArray*)arr;
@end
