//
//  FileSession.m
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/21/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//
#import "Article.h"
#import "FileSession.h"

@implementation FileSession

static NSString *appGroup = @"group.mobi.xiaoyifan.techtime";


+(NSURL *)getListURL
{
    
    NSURL *docsURL = [[NSFileManager defaultManager]
                       containerURLForSecurityApplicationGroupIdentifier:
                       appGroup];
    
    
    NSURL* file = [docsURL URLByAppendingPathComponent:@"articles.plist"];
    
    NSLog(@"FILE: %@",file);
    return file;
}

+(NSURL *)getTableURL
{
    
    NSURL *docsURL = [[NSFileManager defaultManager]
                      containerURLForSecurityApplicationGroupIdentifier:
                      appGroup];
    
    
    NSURL* file = [docsURL URLByAppendingPathComponent:@"table.plist"];
    
    NSLog(@"FILE: %@",file);
    return file;
}

+(void)writeData:(id)object ToList:(NSURL*)url{
    NSData* sessionData = [NSKeyedArchiver archivedDataWithRootObject:object];
    [sessionData writeToURL:url atomically:NO];
}

+(NSArray *)readDataFromList:(NSURL*)url{
    // Read
    NSData* data = [[NSData alloc] initWithContentsOfURL:url];
    NSArray *dataRetrived = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    //DLog(@"Retrieved:%@ %@",sessionRetrieved.startTime,sessionRetrieved.uuid);
    return dataRetrived;
}


@end
