//
//  DefaultManager.h
//  Tech Time
//
//  Created by Yifan Xiao on 5/23/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"
#import <UIKit/UIKit.h>

@interface DefaultManager : NSObject

+(id)defaultInstance;

-(NSMutableArray*)getList;

-(void)addObject:(Article*)article;

@end
