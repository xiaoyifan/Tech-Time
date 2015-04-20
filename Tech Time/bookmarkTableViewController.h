//
//  bookmarkTableViewController.h
//  Splitting Up is Easy To Do
//
//  Created by Alex Xiao on 2/13/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@protocol bookmarkToWebviewDelegate <NSObject>

-(void)bookmark:(id)sender sendsURL:(NSURL*)url andUpdateArticleItem:(Article*)article;

@end



@interface bookmarkTableViewController : UITableViewController

@property (weak, nonatomic) id<bookmarkToWebviewDelegate> delegate;

//item array is the array of favorite items
@property (strong, nonatomic) NSMutableArray *ItemArray;

@end
