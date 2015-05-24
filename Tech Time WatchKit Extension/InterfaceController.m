//
//  InterfaceController.m
//  Tech Time WatchKit Extension
//
//  Created by Yifan Xiao on 5/22/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "InterfaceController.h"
#import "DefaultManager.h"
#import "Article.h"
#import "NewsKit.h"
#import "FileSession.h"

@interface InterfaceController()


@end


@implementation InterfaceController

static NSString *appGroup = @"group.mobi.xiaoyifan.techtime";

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

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

- (IBAction)newsButtonPressed {
    
    NSArray *controllerNames = @[
                                 @"pageController",
                                 @"pageController",
                                 @"pageController",
                                 @"pageController",
                                 @"pageController",
                                 @"pageController",
                                 @"pageController",
                                 @"pageController",
                                 @"pageController",
                                 @"pageController"
                                 ];
    

    //get from the main app
    
    NSURL *tableURL = [FileSession getTableURL];
    NSArray *array = [FileSession readDataFromList:tableURL];
    
    [self presentControllerWithNames:controllerNames contexts:array];
    
}

- (IBAction)favoriteButtonPressed {
    
    NSURL *listURL = [FileSession getListURL];
    NSArray *array = [FileSession readDataFromList:listURL];
    
    NSMutableArray *controllerNames = [[NSMutableArray alloc] initWithObjects:nil, nil];
    
    for (int i=0; i<array.count; i++) {
        [controllerNames addObject:@"pageController"];
    }

    
    [self presentControllerWithNames:controllerNames contexts:array];
    
}


-(void)handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)remoteNotification{
    if ([identifier isEqualToString:@"firstButtonAction"]) {
        NSLog(@"first button in Notification is pressed.");
    }
}



@end



