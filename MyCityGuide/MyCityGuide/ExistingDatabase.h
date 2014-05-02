//
//  ExistingDatabase.h
//  MyCityGuide
//
//  Created by Mac on 02/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExistingDatabase : NSObject
{
    NSString *databasepath;
    NSMutableArray *record;
    NSString *latLong;
    NSString *dataStr;
}
+(ExistingDatabase*)getsharedInstance;

- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;
-(NSMutableArray*)receiveAllData;
//- (void) getInitialDataToDisplay;
-(NSMutableArray*)reciviewCityName:(NSString*)countryName;
-(NSString*)reciveLatLong:(NSString*)cityName;
-(NSMutableArray*)receiveCityImageArr:(NSString*)CountryName;
-(NSString*)ReceivecityImagesWithCityName:(NSString*)CityName;
-(NSMutableArray*)receiveAllDataFromPlacesDetail;


- (BOOL)saveDataofCityDetail:(NSString*)cityName withTyp:(NSString*)type iconUrl:(NSString*)iconUrl name:(NSString*)name rating:(float)rating reference:(NSString*)reference;

-(BOOL)updateDatadtailedData:(NSString*)reference lat:(float)lat lng:(float)lng address:(NSString*)address phoneNo:(NSString*)phneNo websit:(NSString*)website;

-(BOOL)deleteDataFromPlacesDetail:(NSString*)city;
- (BOOL) saveData:(NSString*)cityDetail;
-(NSString*)reciveCityImageWithCityName:(NSString*)city;
@end
