//
//  TableViewController.h
//  MyCityGuide
//
//  Created by Mac on 07/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *MyTable;
    UITableViewCell *cell;
}

@end
