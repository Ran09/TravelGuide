//
//  tempDataBase.h
//  TravelGuide
//
//  Created by Mac on 20/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "placessDetailData.h"

@interface tempDataBase : NSObject
{
    NSString *databasePath;
    placessDetailData *placesDetail;
    NSMutableArray *record;
}
+(tempDataBase*)getSharedInstance;
-(BOOL)createDB;
- (BOOL) saveData:(placessDetailData*)placesInfo;
-(BOOL)updateData:(placessDetailData *)placesInfo;
-(NSMutableArray*)reciveAllData;
+(BOOL)DeleteDatabase;
-(BOOL)deleteDataFromPlacesDetail:(NSString*)city andType:(NSString*)type;
-(BOOL)deleteDataFromPlacesDetail:(NSString*)city andType:(NSString*)type andNAme:(NSString*)name;
-(BOOL)CreateTable;
-(BOOL)savedatainDownloads:(NSString*)city andDownlaods:(int)counter;
-(int)reciveDownloadCounter;
-(NSMutableArray*)receiveAllDownloadData;
-(BOOL)deleterowFromDownloded:(int)rowid;
-(BOOL)updateDownloadCounter:(int)conterValue1 andContervalue2:(int)value2;
-(NSMutableArray*)receiveAllDownloadcity;
-(NSMutableArray*)recivedataforfirstList:(NSString*)type andWithCity:(NSString*)city;
-(NSMutableArray*)recivedataforsecondList:(NSString*)type andWithCity:(NSString*)city andWithName:(NSString*)name;
-(NSMutableArray*)reciveAddressforsecondList:(NSString*)type andWithCity:(NSString*)city andWithName:(NSString*)name;


-(BOOL)deleteFromCityDetailDownloads:(NSString*)rowId;
-(BOOL)CreateTable2;
- (BOOL) saveCityDetailDownloadsData:(placessDetailData*)placesInfo;
-(BOOL)updateCityDownloadsData:(placessDetailData *)placesInfo;
-(NSMutableArray*)reciveAllCityDetailDownlaodsData;
-(NSMutableArray*)checkDuplicateNames:(NSString*)city andtype:(NSString*)type;
@end
