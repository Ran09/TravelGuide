//
//  tempDataBase.m
//  TravelGuide
//
//  Created by Mac on 20/04/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "tempDataBase.h"
#import <sqlite3.h>
static tempDataBase *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;
@implementation tempDataBase
+(tempDataBase*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}


//Create Database & table if it not exist Create it

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"tempDatabase.db"]];
    BOOL isSuccess = NO;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    //int l=0;
    if ([filemgr fileExistsAtPath: databasePath ] != YES)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {//("city" TEXT,"type" TEXT,"lat" DOUBLE,"lng" DOUBLE,"icon" TEXT,"name" TEXT,"rating" FLOAT,"reference" TEXT,"address" TEXT,"phoneNo" TEXT,"website" TEXT)
            char *errMsg;
            const char *sql_stmt ="create table if not exists PlacesDetail(city text,type text,icon text,name text,rating float,reference text ,address text, phoneNo text,website text,latitude float,logitude float)";
            
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            else{
                isSuccess = YES;
            }
            
            // return  isSuccess;
        }
        NSLog(@"%d",sqlite3_open(dbpath, &database));
        int l=  sqlite3_close(database);
        NSLog(@"Close =%d",l);
    }
    return isSuccess;
}
- (BOOL) saveData:(placessDetailData*)placesInfo{
    
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into PlacesDetail (city,type,icon,name,rating,reference,address,phoneNo,website,latitude,logitude) values(\"%@\",\"%@\",\"%@\",\"%@\",%f,\"%@\",\"%@\",\"%@\",\"%@\",%f,%f)",placesInfo.city,placesInfo.type,placesInfo.icon,placesInfo.name,placesInfo.rating,placesInfo.reference,placesInfo.address,placesInfo.phoneNo,placesInfo.website,placesInfo.latitude,placesInfo.logitude];
        
        NSLog(@"%@",insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
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

-(BOOL)updateData:(placessDetailData *)placesInfo
{
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"DBPATH:%s",dbpath);
    BOOL isSuccess=NO;
    NSLog(@"updateing placesDetailData");
    //sqlite3_stmt *statement;
    //const char*dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        // NSLog(@"%@",&databasePath);//city text,type text,icon text,name text,rating float,reference text ,address text, phoneNo text,website text,latitude float,logitude float
        NSLog(@"db open");
        NSString *querySQL = [NSString stringWithFormat:@"update PlacesDetail set rating=%f where reference=\"%@\";",placesInfo.rating,placesInfo.reference];
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
                NSLog(@"File to update");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    return isSuccess;
    
}

-(NSMutableArray*)reciveAllData
{
    record=[[NSMutableArray alloc]init];
    const char *dbpath=[databasePath UTF8String];
    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"select * from PlacesDetail"];
        const char *select_stmt=[selectSQL UTF8String];
        NSLog(@"%s",select_stmt);
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
            NSLog(@"Problem with prepare statement.");
        }
        else{
            //NSInteger temp=0,num=0;
            
            while(sqlite3_step(statement)==SQLITE_ROW){
               placesDetail = [[placessDetailData alloc]init];
                placesDetail.city=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
                placesDetail.type=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
                placesDetail.name=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
                placesDetail.website=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 7)];
                
                NSString *data=[NSString stringWithFormat:@"%@,%@,%@,%@",placesDetail.city,placesDetail.type,placesDetail.name,placesDetail.website];
                [record addObject:data];
                [placesDetail release];
            }
        }
        
    }
    
    sqlite3_close(database);
    return record;
}

-(NSMutableArray*)recivedataforfirstList:(NSString*)type andWithCity:(NSString*)city
{
    record=[[NSMutableArray alloc]init];
    const char *dbpath=[databasePath UTF8String];
    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"select * from PlacesDetail where type=\"%@\" and city=\"%@\"",type,city];
        const char *select_stmt=[selectSQL UTF8String];
        NSLog(@"%s",select_stmt);
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
            NSLog(@"Problem with prepare statement.");
        }
        else{
            //NSInteger temp=0,num=0;
            
            while(sqlite3_step(statement)==SQLITE_ROW){
                placesDetail = [[placessDetailData alloc]init];
              //  placesDetail.city=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
                placesDetail.icon=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                placesDetail.name=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
                placesDetail.rating=[[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 4)]doubleValue];
                
                NSString *data=[NSString stringWithFormat:@"%@,%@,%f",placesDetail.icon,placesDetail.name,placesDetail.rating];
                [record addObject:data];
                [placesDetail release];
            }
        }
        
    }
    
    sqlite3_close(database);
    return record;
}

-(NSMutableArray*)recivedataforsecondList:(NSString*)type andWithCity:(NSString*)city andWithName:(NSString*)name
{
    record=[[NSMutableArray alloc]init];
    const char *dbpath=[databasePath UTF8String];
    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"select * from PlacesDetail where type=\"%@\" and city=\"%@\" and name=\"%@\"",type,city,name];
        const char *select_stmt=[selectSQL UTF8String];
        NSLog(@"%s",select_stmt);
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
            NSLog(@"Problem with prepare statement.");
        }
        else{
            //NSInteger temp=0,num=0;
            
            while(sqlite3_step(statement)==SQLITE_ROW){
                placesDetail = [[placessDetailData alloc]init];
                //  placesDetail.city=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
                placesDetail.icon=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
              //  placesDetail.address=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 6)];
                placesDetail.phoneNo=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 7)];
                placesDetail.website=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 8)];
                
                NSString *data=[NSString stringWithFormat:@"%@,%@,%@",placesDetail.icon,placesDetail.phoneNo,placesDetail.website];
                [record addObject:data];
                [placesDetail release];
            }
        }
        
    }
    
    sqlite3_close(database);
    return record;
}

-(NSMutableArray*)reciveAddressforsecondList:(NSString*)type andWithCity:(NSString*)city andWithName:(NSString*)name
{
    record=[[NSMutableArray alloc]init];
    const char *dbpath=[databasePath UTF8String];
    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"select * from PlacesDetail where type=\"%@\" and city=\"%@\" and name=\"%@\"",type,city,name];
        const char *select_stmt=[selectSQL UTF8String];
        NSLog(@"%s",select_stmt);
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
            NSLog(@"Problem with prepare statement.");
        }
        else{
            //NSInteger temp=0,num=0;
            
            while(sqlite3_step(statement)==SQLITE_ROW){
                placesDetail = [[placessDetailData alloc]init];
                //  placesDetail.city=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
              //  placesDetail.icon=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                  placesDetail.address=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 6)];
              //  placesDetail.phoneNo=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 7)];
             //   placesDetail.website=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 8)];
                
                NSString *data=[NSString stringWithFormat:@"%@",placesDetail.address];
                [record addObject:data];
                [placesDetail release];
            }
        }
        
    }
    
    sqlite3_close(database);
    return record;
}
-(BOOL)deleteDataFromPlacesDetail:(NSString*)city andType:(NSString*)type
{
    //[self findDBPath];
    BOOL isSuccess=NO;
    
    const char *dbpath=[databasePath UTF8String];    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:@"delete from PlacesDetail where city=\"%@\" and type=\"%@\"",city,type];
        
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

-(BOOL)deleteDataFromPlacesDetail:(NSString*)city andType:(NSString*)type andNAme:(NSString*)name
{
    BOOL isSuccess=NO;
    
    const char *dbpath=[databasePath UTF8String];    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:@"delete from PlacesDetail where city=\"%@\" and type=\"%@\" and icon=\"%@\"",city,type,name];
        
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
+(BOOL)DeleteDatabase
{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir=[path objectAtIndex:0];
    NSString *filePath=[docDir stringByAppendingPathComponent:@"tempDatabase.db"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
        return YES;
    }
    return NO;
}

-(BOOL)CreateTable
{
    BOOL isSuceess;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {//("city" TEXT,"type" TEXT,"lat" DOUBLE,"lng" DOUBLE,"icon" TEXT,"name" TEXT,"rating" FLOAT,"reference" TEXT,"address" TEXT,"phoneNo" TEXT,"website" TEXT)
        char *errMsg;
        const char *sql_stmt ="create table if not exists cityDownloaded(city text,downlaods integer)";
        
        if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
            != SQLITE_OK)
        {
            isSuceess = NO;
            NSLog(@"Failed to create table");
        }
        else{
            isSuceess = YES;
        }
        
        // return  isSuccess;
    }
    NSLog(@"%d",sqlite3_open(dbpath, &database));
    int l=  sqlite3_close(database);
    NSLog(@"Close =%d",l);
    return isSuceess;
}

-(BOOL)savedatainDownloads:(NSString*)city andDownlaods:(int)counter
{
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into cityDownloaded (city,downlaods) values(\"%@\",%i)",city,counter];
        
        NSLog(@"%@",insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
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

-(int)reciveDownloadCounter
{
    int counter;
     const char *dbpath=[databasePath UTF8String];
    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"select * from cityDownloaded"];
        const char *select_stmt=[selectSQL UTF8String];
        NSLog(@"%s",select_stmt);
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
            NSLog(@"Problem with prepare statement.");
        }
        else{
            //NSInteger temp=0,num=0;
            
            if (sqlite3_step(statement)==SQLITE_ROW){
               
                counter=[[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)]intValue];
            }
        }
        
    }
    
    sqlite3_close(database);
    return counter;
}

-(BOOL)deleterowFromDownloded:(int)rowid
{
    BOOL isSuccess=NO;
    
    const char *dbpath=[databasePath UTF8String];    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:@"delete from cityDownloaded where rowid=%i",rowid];
        
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

-(NSMutableArray*)receiveAllDownloadData
{ int counter;
    NSString *city;
    record=[[NSMutableArray alloc]init];
    const char *dbpath=[databasePath UTF8String];
    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"select * from cityDownloaded"];
        const char *select_stmt=[selectSQL UTF8String];
        NSLog(@"%s",select_stmt);
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
            NSLog(@"Problem with prepare statement.");
        }
        else{
            //NSInteger temp=0,num=0;
            
            while(sqlite3_step(statement)==SQLITE_ROW){
                city=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
                counter=[[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)]intValue];
                NSString *data=[NSString stringWithFormat:@"%@,%i",city,counter];
                [record addObject:data];
            }
        }
        
    }
    
    sqlite3_close(database);
    
    return  record;
}

-(BOOL)updateDownloadCounter:(int)conterValue1 andContervalue2:(int)value2
{
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"DBPATH:%s",dbpath);
    BOOL isSuccess=NO;
    NSLog(@"updateing placesDetailData");
    //sqlite3_stmt *statement;
    //const char*dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        // NSLog(@"%@",&databasePath);//city text,type text,icon text,name text,rating float,reference text ,address text, phoneNo text,website text,latitude float,logitude float
        NSLog(@"db open");
        NSString *querySQL = [NSString stringWithFormat:@"update cityDownloaded set downlaods=%i where downlaods=%i;",value2,conterValue1];
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
                NSLog(@"File to update");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    return isSuccess;
    
}
-(NSMutableArray*)receiveAllDownloadcity
{     NSString *city;
    record=[[NSMutableArray alloc]init];
    const char *dbpath=[databasePath UTF8String];
    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"select * from cityDownloaded"];
        const char *select_stmt=[selectSQL UTF8String];
        NSLog(@"%s",select_stmt);
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
            NSLog(@"Problem with prepare statement.");
        }
        else{
            //NSInteger temp=0,num=0;
            
            while(sqlite3_step(statement)==SQLITE_ROW){
                city=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
                
               
                [record addObject:city];
            }
        }
        
    }
    
    sqlite3_close(database);
    
    return  record;
}
-(BOOL)CreateTable2
{
    BOOL isSuceess;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {//("city" TEXT,"type" TEXT,"lat" DOUBLE,"lng" DOUBLE,"icon" TEXT,"name" TEXT,"rating" FLOAT,"reference" TEXT,"address" TEXT,"phoneNo" TEXT,"website" TEXT)
        char *errMsg;
        const char *sql_stmt ="create table if not exists cityDetailDownloads(city text,type text,icon text,name text,rating float,reference text ,address text, phoneNo text,website text)";
        
        if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
            != SQLITE_OK)
        {
            isSuceess = NO;
            NSLog(@"Failed to create table");
        }
        else{
            isSuceess = YES;
        }
        
        // return  isSuccess;
    }
    NSLog(@"%d",sqlite3_open(dbpath, &database));
    int l=  sqlite3_close(database);
    NSLog(@"Close =%d",l);
    return isSuceess;
}

- (BOOL) saveCityDetailDownloadsData:(placessDetailData*)placesInfo{
    
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into cityDetailDownloads (city,type,icon,name,rating,reference,address,phoneNo,website) values(\"%@\",\"%@\",\"%@\",\"%@\",%f,\"%@\",\"%@\",\"%@\",\"%@\")",placesInfo.city,placesInfo.type,placesInfo.icon,placesInfo.name,placesInfo.rating,placesInfo.reference,placesInfo.address,placesInfo.phoneNo,placesInfo.website];
        
        NSLog(@"%@",insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
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
-(BOOL)updateCityDownloadsData:(placessDetailData *)placesInfo
{
    const char *dbpath = [databasePath UTF8String];
    NSLog(@"DBPATH:%s",dbpath);
    BOOL isSuccess=NO;
    NSLog(@"updateing placesDetailData");
    //sqlite3_stmt *statement;
    //const char*dbpath=[databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        // NSLog(@"%@",&databasePath);//city text,type text,icon text,name text,rating float,reference text ,address text, phoneNo text,website text,latitude float,logitude float
        NSLog(@"db open");
        NSString *querySQL = [NSString stringWithFormat:@"update cityDetailDownloads set address=\"%@\" and phoneNo=\"%@\" and website=\"%@\" where reference=\"%@\";",placesInfo.address,placesInfo.phoneNo,placesInfo.website,placesInfo.reference];
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
                NSLog(@"File to update");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(database);
    }
    return isSuccess;
    
}

-(NSMutableArray*)reciveAllCityDetailDownlaodsData
{
    record=[[NSMutableArray alloc]init];
    const char *dbpath=[databasePath UTF8String];
    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"select * from cityDetailDownloads"];
        const char *select_stmt=[selectSQL UTF8String];
        NSLog(@"%s",select_stmt);
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
            NSLog(@"Problem with prepare statement.");
        }
        else{
            //NSInteger temp=0,num=0;
          //city,type,icon,name,rating,reference,address,phoneNo,website  
            while(sqlite3_step(statement)==SQLITE_ROW){
                placesDetail = [[placessDetailData alloc]init];
                placesDetail.city=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
                placesDetail.type=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
                placesDetail.icon=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                placesDetail.name=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
                placesDetail.rating=[[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 4)]doubleValue];
                placesDetail.reference=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
                placesDetail.address=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 6)];
                placesDetail.phoneNo=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 7)];
                placesDetail.website=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 8)];
                
                NSString *data=[NSString stringWithFormat:@"%@,%@,%@,%@,%f,%@,%@,%@,%@",placesDetail.city,placesDetail.type,placesDetail.icon,placesDetail.name,placesDetail.rating,placesDetail.reference,placesDetail.address,placesDetail.phoneNo,placesDetail.website];
                [record addObject:data];
                [placesDetail release];
            }
        }
        
    }
    
    sqlite3_close(database);
    return record;
}

-(NSMutableArray*)checkDuplicateNames:(NSString*)city andtype:(NSString*)type
{
   // NSString *data=[[NSString alloc]init];
    record=[[NSMutableArray alloc]init];
    const char *dbpath=[databasePath UTF8String];
    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database)==SQLITE_OK) {
        NSString *selectSQL=[NSString stringWithFormat:@"select * from cityDetailDownloads where city=\"%@\" and type=\"%@\"",city,type];
        const char *select_stmt=[selectSQL UTF8String];
        NSLog(@"%s",select_stmt);
        int res = sqlite3_prepare_v2(database, select_stmt, -1, &statement, NULL);
        if (res!=SQLITE_OK){
            NSLog(@"Problem with prepare statement.");
        }
        else{
            //NSInteger temp=0,num=0;
            //city,type,icon,name,rating,reference,address,phoneNo,website  
            while(sqlite3_step(statement)==SQLITE_ROW){
                placesDetail = [[placessDetailData alloc]init];
              
                placesDetail.name=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
               
              NSString * data=[NSString stringWithFormat:@"%@",placesDetail.name];
              //  NSString *data=[NSString stringWithFormat:@"%@,%@,%@,%@,%f,%@,%@,%@,%@",placesDetail.city,placesDetail.type,placesDetail.icon,placesDetail.name,placesDetail.rating,placesDetail.reference,placesDetail.address,placesDetail.phoneNo,placesDetail.website];
                [record addObject:data];
                [placesDetail release];
            }
        }
        
    }
    
    sqlite3_close(database);
    return record;
}

-(BOOL)deleteFromCityDetailDownloads:(NSString*)rowId
{
    BOOL isSuccess=NO;
    
    const char *dbpath=[databasePath UTF8String];    NSLog(@"DBPATH:%s",dbpath);
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:@"delete from cityDetailDownloads where city=\"%@\"",rowId];
        
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

@end
