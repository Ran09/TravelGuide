//
//  cityDetailViewController.h
//  MyCityGuide
//
//  Created by Mac on 02/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "placessDetailData.h"
#import "tempDataBase.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
@interface cityDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *detailTable;
    NSMutableArray *iconUrlArr;
    NSMutableArray *mainNameArr;
    NSMutableArray *detailNameArr;
    NSMutableArray *RatArr;
    NSMutableArray *referArr;
    UIBarButtonItem *rightBarBtn;
    NSArray *resultsArr;
    NSDictionary *dicResult;
    NSString *CITYName;
    NSString *TypeTitle;
    //UITableViewCell *cell;
    UIView *myactivityView;
    UIActivityIndicatorView *indicator;
    UIImage *urlImg;
    NSString *referenceplace;
    placessDetailData *placesInfo;
    tempDataBase *tempDb;
    float rating;
}
-(id)initWithicon:(NSArray*)iconUrl name:(NSArray*)namearr rating:(NSArray*)rattingArr reference:(NSArray*)referenceArr andwithCityName:(NSString*)city withType:(NSString*)type;

-(id)initWithicon:(NSArray*)results andWithCityNAme:(NSString*)cityNAme andWithTitle:(NSString*)Mytitle;
+ (UIImage*)imageWithImage:(UIImage*)image 
              scaledToSize:(CGSize)newSize;
@end
