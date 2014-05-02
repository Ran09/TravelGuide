//
//  NextViewOfDownloadClass.h
//  TravelGuide
//
//  Created by Mac on 28/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NextViewOfDownloadClass : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIImageView *imageView;
    IBOutlet UITableView *listTable;
    IBOutlet UILabel *cityNameLable;
    UIButton *HomeBtn;
    UIBarButtonItem *backBtn;
    UIBarButtonItem *rightBarBtn;
    NSArray *listArr;
    NSString *MyCity;
    NSArray *imgArr;
}
-(id)initwithnameOfCity:(NSString*)cityNm;
@end
