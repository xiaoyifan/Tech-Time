//
//  GlanceController.m
//  Tech Time WatchKit Extension
//
//  Created by Yifan Xiao on 5/22/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "GlanceController.h"
#import "FileSession.h"
#import "Article.h"


@interface GlanceController()

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *contentSnippetLabel;

@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    
    NSURL *tableURL = [FileSession getTableURL];
    NSArray *array = [FileSession readDataFromList:tableURL];
    
    Article *article = array[0];
    self.contentSnippetLabel.text  =article.title;
    
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



