//
//  Database.m
//  AppTrack
//
//  Created by CICtourGUNE on 10/04/13.
//  Copyright (c) 2013 CICtourGUNE. All rights reserved.
//

#import "Database.h"

@interface Database ()

@end

@implementation Database


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)createDatabaseTable{
    
    
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"apptrack.db"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
		const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &PointDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS POINTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, LONGITUD TEXT, LATITUD TEXT, FECHA TEXT)";
            
            
            
            if (sqlite3_exec(PointDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table points");
            }else{
                NSLog(@"created database table points");
            }
            
            const char *sql_stmt2 = "CREATE TABLE IF NOT EXISTS PARAMS (ID INTEGER PRIMARY KEY AUTOINCREMENT, IDPARAM TEXT, VALOR TEXT)";
            
            if (sqlite3_exec(PointDB, sql_stmt2, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table params");
            }else{
                NSLog(@"created database table params");
            }
            
            sqlite3_close(PointDB);
            
        } else {
            NSLog(@"Failed to open/create database");
        }
    }
    
    
}
- (void) savePointData: (NSString *)latitud :(NSString *)longitud
{
    sqlite3_stmt    *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &PointDB) == SQLITE_OK)
    {
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:locale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *fecha = [dateFormatter stringFromDate:date];
        
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO POINTS (LONGITUD, LATITUD, FECHA) VALUES (\"%@\", \"%@\", \"%@\")", longitud, latitud,fecha];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(PointDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"saved point data");
            
        } else {
            NSLog(@"Failed to add point");
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(PointDB);
    }
}



-(NSMutableArray*) findPoints
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    NSMutableArray *allRows = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &PointDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat: @"SELECT LATITUD, LONGITUD, FECHA FROM POINTS"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(PointDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                NSString *longitud = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                NSString *latitud = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                NSString *fecha = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                
                NSString *str = [NSString stringWithFormat:@"%@,%@,%@",longitud, latitud,fecha];
                
                [allRows addObject:str];
                
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(PointDB);
    }
    return allRows;
}
- (void) deletePoints{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &PointDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat: @"DELETE FROM POINTS"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(PointDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Delete points successful");
                
            }else{
                NSLog(@"Failed to delete points");
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(PointDB);
    }
    
}


- (void) saveParamsData: (NSMutableArray *)arrayp
{
    sqlite3_stmt    *statement;
    
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &PointDB) == SQLITE_OK)
    {
        
        int counter=[arrayp count];
        
        for(int i=0;i<counter;i++)
        {
            NSDictionary *currentObject=[arrayp objectAtIndex:i];
            NSString *idparam=[currentObject objectForKey:@"idparam"];
            NSString *valueparam=[currentObject objectForKey:@"valor"];

            
            NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO PARAMS (IDPARAM, VALOR) VALUES (\"%@\", \"%@\")", idparam, valueparam];

            const char *insert_stmt = [insertSQL UTF8String];

            sqlite3_prepare_v2(PointDB, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"saved params data: %@", @"saved");
                
            } else {
                NSLog(@"Failed to add param %d", sqlite3_step(statement));
                
            }
            sqlite3_finalize(statement);
            
        }
    }
    sqlite3_close(PointDB);
}

- (NSMutableArray*) findParams
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    NSMutableArray *allRows = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &PointDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat: @"SELECT IDPARAM, VALOR FROM PARAMS"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(PointDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                NSString *idp = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *value = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                
                NSString *str = [NSString stringWithFormat:@"%@,%@",idp,value];
                // textv.text=str; // I don't know why your are mixing your view controller stuff's in database function.
                // Add the string in the array.
                
                [allRows addObject:str];
                
            }
            
            sqlite3_finalize(statement);
        }else{
            NSLog(@"Failed to find params");
        }
        sqlite3_close(PointDB);
    }
    return allRows;
}
- (void) deleteIdParam: (NSString *) idparam{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &PointDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat: @"DELETE FROM PARAMS WHERE IDPARAM=%@",idparam];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(PointDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Delete idparam successful");
                
            }else{
                NSLog(@"Failed to delete idparam");
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(PointDB);
    }
    
}
- (void) deleteParams{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &PointDB) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat: @"DELETE FROM PARAMS"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(PointDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Delete params successful");
                
            }else{
                NSLog(@"Failed to delete Params");
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(PointDB);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
