//
//  pageController.m
//  Tech Time
//
//  Created by Yifan Xiao on 5/22/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "pageController.h"
#import "Article.h"

@interface pageController ()


@property (weak, nonatomic) IBOutlet WKInterfaceLabel *pageLabel;

@end

@implementation pageController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    Article *article = context;

    [self.pageLabel setText:[NSString stringWithFormat:@"%@", article.title]];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



