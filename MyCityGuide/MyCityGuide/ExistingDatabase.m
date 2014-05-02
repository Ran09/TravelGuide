//
//  ExistingDatabase.m
//  MyCityGuide
//
//  Created by Mac on 02/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ExistingDatabase.h"
#import <sqlite3.h>
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;
ExistingDatabase *sharedInstance;
@implementation ExistingDatabase

-(void)dealloc
{
    [super dealloc];
    [record release];
    [latLong release];
}

+(ExistingDatabase*)getsharedInstance
{
    if (!sharedInstance) {
        sharedInstance=[[super allocWithZone:NULL]init];
        [sharedInstance copyDatabaseIfNeeded];
    }
    return sharedInstance;
}

- (void) copyDatabaseIfNeeded { //Using NSFileManager we can perform many file system operations.
    NSLog(@"in copy data");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if(!success) {
        databasepath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mynewdb.sqlite"];
        success = [fileManager copyItemAtPath:databasepath toPath:dbPath error:&error];
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}
- (NSString *) getDBPath { //Search for standard documents using NSSearchPathForDirectoriesInDomains
    //First Param = Searching the documents directory
    //Second Param = Searching the Users directory and not the System
    //Expand any tildes and identify home directories.
    NSLog(@" in get db path");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"mynewdb.sqlite"];
}

//- (void) getInitialDataToDisplay { 
//    NSMutableArray *arr=[[NSMutableArray alloc]init];
//    const char *dbPath=[databasepath UTF8String];
//                        
//    if (sqlite3_open(dbPath, &database) == SQLITE_OK) {
//        const char *sql = "select * from places";
//        sqlite3_stmt *selectstmt;
//        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
//            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
//                NSString *contName=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
//                NSString *country=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
//                NSString *city=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
//                NSString *str=[NSString stringWithFormat:@"%@,%@,%@",contName,country,city];
//                [arr addObject:str];
//            }
//            NSLog(@" data %@",arr);
//        }
//    }
//    else
//        sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
//}

-(NSMutableArray*)receiveAllData
{
    //[self findDBPath];
    record = [[NSMutableArray alloc]init];
     databasepath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mynewdb.sqlite"];
    NSLog(@"%@",databasepath);
    NSLog(@"%s",[databasepath UTF8String]);
    const char *dbpath=[databasepath UTF8String];
    //NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"select * from places"];
        const char *select_stmt=[selectSQL UTF8String];
        NSLog(@"%i",sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL));
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
            NSLog(@"Problem with prepare statement.");
        }
        else{
            //NSInteger temp=0,num=0;
            NSLog(@"in else part");
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"in while");
                NSString *contname=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 4)];
                NSString *country=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
                NSString *city=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement,6)];
                NSString *datastr=[NSString stringWithFormat:@"%@,%@,%@",contname,country,city];
                [record addObject:datastr];
                //[datastr release];
            }
        }
        
    }
    
    sqlite3_close(database);
    return record;
    [record release];
}

-(NSMutableArray*)reciviewCityName:(NSString*)countryName
{
    record=[[NSMutableArray alloc]init];
    databasepath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mynewdb.sqlite"];
    NSLog(@"%@",databasepath);
    NSLog(@"%s",[databasepath UTF8String]);
    const char *dbpath=[databasepath UTF8String];
    //NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"select * from places where country=\"%@\"",countryName];
        const char *select_stmt=[selectSQL UTF8String];
        NSLog(@"%i",sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL));
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
            NSLog(@"Problem with prepare statement.");
        }
        else{
            //NSInteger temp=0,num=0;
            NSLog(@"in else part");
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"in while");
                NSString *city=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 6)];
               // NSString *datastr=[NSString stringWithFormat:@"%@,%@,%@",contname,country,city];
                [record addObject:city];
            }
        }
        
    }
    
    sqlite3_close(database);
    return record;
    [record release];
}

-(NSString*)reciveLatLong:(NSString*)cityName
{
   // NSMutableArray *record=[[NSMutableArray alloc]init];
    latLong=[[NSString alloc]init];
    databasepath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mynewdb.sqlite"];
    NSLog(@"%@",databasepath);
    NSLog(@"%s",[databasepath UTF8String]);
    const char *dbpath=[databasepath UTF8String];
    //NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"select * from places where city=\"%@\"",cityName];
        const char *select_stmt=[selectSQL UTF8String];
        NSLog(@"%i",sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL));
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
            NSLog(@"Problem with prepare statement.");
        }
        else{
            //NSInteger temp=0,num=0;
            NSLog(@"in else part");
           // while(sqlite3_step(statement)==SQLITE_ROW)
                if (sqlite3_step(statement)==SQLITE_ROW) 
            {
                NSLog(@"in while");
                float lat=sqlite3_column_double(statement, 7);
                //[[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 6)]floatValue];
                float Long=sqlite3_column_double(statement, 8);
                //[[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 7)]integerValue];
               // NSString *city=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
                latLong=[NSString stringWithFormat:@"%f,%f",lat,Long];
                
              //  [record addObject:LatLong];
            }
        }
        
    }
    
    sqlite3_close(database);
    return latLong;
   
}

-(NSMutableArray*)receiveCityImageArr:(NSString*)CountryName
{
    record=[[NSMutableArray alloc]init];
    databasepath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mynewdb.sqlite"];
    NSLog(@"%@",databasepath);
    NSLog(@"%s",[databasepath UTF8String]);
    const char *dbpath=[databasepath UTF8String];
    //NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"select * from places where country=\"%@\"",CountryName];
        const char *select_stmt=[selectSQL UTF8String];
        NSLog(@"%i",sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL));
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
            NSLog(@"Problem with prepare statement.");
        }
        else{
            //NSInteger temp=0,num=0;
            NSLog(@"in else part");
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"in while");
                NSString *cityImage=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                // NSString *datastr=[NSString stringWithFormat:@"%@,%@,%@",contname,country,city];
                [record addObject:cityImage];
            }
        }
        
    }
    
    sqlite3_close(database);
    return record; 
}

-(NSString*)ReceivecityImagesWithCityName:(NSString*)CityName
{
    dataStr=[[NSString alloc]init];
    databasepath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mynewdb.sqlite"];
    NSLog(@"%@",databasepath);
    NSLog(@"%s",[databasepath UTF8String]);
    const char *dbpath=[databasepath UTF8String];
    //NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"select * from places where city=\"%@\"",CityName];
        const char *select_stmt=[selectSQL UTF8String];
        NSLog(@"%i",sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL));
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
            NSLog(@"Problem with prepare statement.");
        }
        else{
            //NSInteger temp=0,num=0;
            NSLog(@"in else part");
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"in while");
                dataStr=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                // NSString *datastr=[NSString stringWithFormat:@"%@,%@,%@",contname,country,city];
            }
        }
        
    }
    
    sqlite3_close(database);
    return dataStr; 
}

-(NSMutableArray*)receiveAllDataFromPlacesDetail
{
    //("city" TEXT,"type" TEXT,"lat" DOUBLE,"lng" DOUBLE,"icon" TEXT,"name" TEXT,"rating" FLOAT,"reference" TEXT,"address" TEXT,"phoneNo" TEXT,"website" TEXT)
    record=[[NSMutableArray alloc]init];
    databasepath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"mynewdb.sqlite"];
    NSLog(@"%@",databasepath);
    
    const char *dbpath=[databasepath UTF8String];
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectStmt=[NSString stringWithFormat:@"select * from placesDetail"];
        const char *sql_stmt=[selectStmt UTF8String];
        NSLog(@"%i ",sqlite3_prepare_v2(database, sql_stmt, -1, &statement, NULL));
        int res=sqlite3_prepare_v2(database, sql_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK) {
            NSLog(@"problem with prepare statement");
            
        }else
        {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSLog(@"in while");
                NSString *city=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
             //   NSString *type=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
              //  NSString *name=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
             //   NSString *address=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 8)];
              //  NSString *data=[NSString stringWithFormat:@"%@,%@,%@,%@",city,type,name,address];
                NSString *data=[NSString stringWithFormat:@"%@",city];
                [record addObject:data];
            }
        }
    }
  //  sqlite3_close(database);
    return record;
}

//- (BOOL)saveDataofCityDetail:(NSString*)cityName withTyp:(NSString*)type iconUrl:(NSString*)iconUrl name:(NSString*)name rating:(float)rating reference:(NSString*)reference{
//    
//    //[self findDBPath];
//    databasepath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"mynewdb.sqlite"];
//    NSLog(@"%@",databasepath);
//    
//    const char *dbpath=[databasepath UTF8String];
//    NSLog(@"DBPATH:%s",dbpath);
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {// "placesDetail" ("city" TEXT, "type" TEXT, "lat" DOUBLE, "lng" DOUBLE, "icon" TEXT, "name" TEXT, "rating" FLOAT, "reference" TEXT, "address" TEXT, "phoneNo" TEXT, "website" TEXT)
//        NSString *insertSQL = [NSString stringWithFormat:@"insert into placesDetail(city,type) values(\"%@\",\"%@\")",cityName,type];
//        
//        NSLog(@"%@",insertSQL);
//        const char *insert_stmt = [insertSQL UTF8String];
//        NSLog(@"%i",sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL));
//        
//        if (sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL)!=SQLITE_OK) {
//            NSLog(@"problem with prepare statement");
//        }
//        
//        else{
//        NSLog(@"%i",sqlite3_step(statement));
//        
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            NSLog(@"in if");
//            sqlite3_close(database);
//            return YES;
//        }
//        else {
//            NSAssert1(0, @"error msg while inserting data.'%s'", sqlite3_errmsg(database));
//            sqlite3_close(database);
//            
//            return NO;
//        }
//        sqlite3_reset(statement);
//        }
//    }
//    return NO;
//}
-(BOOL)deleteDataFromPlacesDetail:(NSString*)city
{
    //[self findDBPath];
    BOOL isSuccess=NO;
    databasepath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"mynewdb.sqlite"];
    NSLog(@"%@",databasepath);
    
    const char *dbpath=[databasepath UTF8String];    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:@"delete from placesDetail where city=\"%@\"",city];
        
        NSLog(@"%@",deleteSQL);
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(database, delete_stmt,-1, &statement, NULL);
        //NSLog(@"%d",sqlite3_step(statement));
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(database);
            isSuccess=YES;
        }
        else {
            sqlite3_close(database);
            
            isSuccess=NO;
        }
        sqlite3_reset(statement);
    }
    sqlite3_close(database);
    return isSuccess;
}

//Update receive Emp Info
-(BOOL)updateDatadtailedData:(NSString*)reference lat:(float)lat lng:(float)lng address:(NSString*)address phoneNo:(NSString*)phneNo websit:(NSString*)website
{    //[self findDBPath];
    databasepath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"mynewdb.sqlite"];
    NSLog(@"%@",databasepath);
    const char *dbpath = [databasepath UTF8String];
    NSLog(@"DBPATH:%s",dbpath);
    BOOL isSuccess=NO;
    NSLog(@"updateing database");
    //sqlite3_stmt *statement;
    //const char*dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        // NSLog(@"%@",&databasePath);
        NSLog(@"db open");
        NSString *querySQL = [NSString stringWithFormat:@"update placesDetail set lat=%f lng=%f address=\"%@\",phoneNo=\"%@\",website=\"%@\" where reference=\"%@\";",lat,lng,address,phneNo,website,reference];
        NSLog(@"%@",querySQL);
        const char *update_stmt = [querySQL UTF8String];
        if(sqlite3_prepare_v2(database, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            //                     // NSLog(@"---> %d",sqlite3_step(statement));
            //sqlite3_bind_text(statement,1,update_stmt,-1,SQLITE_TRANSIENT);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                isSuccess=YES;
                NSLog(@"Updated");
                
            }
            else
            {
                isSuccess=NO;
                NSLog(@"Fail to update");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    return isSuccess;
    
}
- (BOOL) saveData:(NSString*)cityDetail{
    //[self findDBPath];
   // databasepath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"mynewdb.sqlite"];
    const char *dbpath = [databasepath UTF8String];
    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into placesDetail (city) values(\"%@\")",cityDetail];
        
        NSLog(@"%@",insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        NSLog(@"%i",sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL));
        
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        
        //NSLog(@"%i",sqlite3_step(statement));
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(database);
            return YES;
        }
        else {
            sqlite3_close(database);
            
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}

-(NSString*)reciveCityImageWithCityName:(NSString*)city
{
    NSString *CityImage;
    databasepath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mynewdb.sqlite"];
    NSLog(@"%@",databasepath);
    NSLog(@"%s",[databasepath UTF8String]);
    const char *dbpath=[databasepath UTF8String];
    //NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"select * from places where city=\"%@\"",city];
        const char *select_stmt=[selectSQL UTF8String];
        NSLog(@"%i",sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL));
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
            NSLog(@"Problem with prepare statement.");
        }
        else{
            //NSInteger temp=0,num=0;
            NSLog(@"in else part");
            if(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"in while");
                CityImage=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                // NSString *datastr=[NSString stringWithFormat:@"%@,%@,%@",contname,country,city];
                            }
        }
        
    }
    
    sqlite3_close(database);
    return CityImage; 
}

@end
