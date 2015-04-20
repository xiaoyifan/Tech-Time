//
//  Article.h
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/20/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject<NSCoding>


@property (strong,nonatomic) NSString *publishedDate;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *contentSnippet;
@property (strong,nonatomic) NSString *link;

@end
