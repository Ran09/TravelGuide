//
//  listofviewOfclass.h
//  TravelGuide
//
//  Created by Mac on 28/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface listofviewOfclass : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *mytable;
    NSString *nameOfcity;
    NSString *Sendedtype;
    NSArray *arrvalues;
    NSMutableArray *iconUrlArr;
    NSMutableArray *nameArr;
    UIImage *urlImg;
    UIButton *HomeBtn;
    UIBarButtonItem *backBtn;
    UIBarButtonItem *rightBarBtn;
}
-(id)initwithnameOfcity:(NSString*)city andType:(NSString*)type andArr:(NSArray*)arr;
@end
