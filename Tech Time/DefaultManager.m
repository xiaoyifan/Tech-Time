//
//  DefaultManager.m
//  Tech Time
//
//  Created by Yifan Xiao on 5/23/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "DefaultManager.h"
#import "Article.h"


@implementation DefaultManager

static NSString *appGroup = @"group.mobi.xiaoyifan.techtime";
NSUserDefaults *shareDefault;

+(id)defaultInstance{
    
    static dispatch_once_t pred;
    static DefaultManager *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
       shareDefault = [[NSUserDefaults alloc] initWithSuiteName:appGroup];
    }
    return self;
}

-(NSMutableArray*)getList{
    
    NSData *arrayData = [shareDefault objectForKey:@"defaultArray"];
    NSMutableArray *muArray;
    if (arrayData != nil)
    {
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:arrayData];
        if (array != nil)
          muArray = [[NSMutableArray alloc] initWithArray:array];
        else
          muArray = [[NSMutableArray alloc] init];
    }
    
    return muArray;
    
}


-(void)addObject:(Article*)article{
    
    
    NSMutableArray *array = self.getList;
    
    [array addObject:article];
    
    [shareDefault setObject: [NSKeyedArchiver archivedDataWithRootObject:array] forKey:@"defaultArray"];
    
    [shareDefault synchronize];
}


@end
