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




+(NSURL *)getListURL
{
    NSError* err = nil;
    NSURL *docs = [[NSFileManager new] URLForDirectory:NSDocumentDirectory
                                              inDomain:NSUserDomainMask appropriateForURL:nil
                                                create:YES error:&err];
    NSURL* file = [docs URLByAppendingPathComponent:@"articles.plist"];
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
