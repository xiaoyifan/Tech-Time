//
//  InterfaceController.m
//  Tech Time WatchKit Extension
//
//  Created by Yifan Xiao on 5/22/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

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
    
    NSArray *contexts  = @[@"1",
                           @"2",
                           @"3",
                           @"4",
                           @"5",
                           @"6",
                           @"7",
                           @"8",
                           @"9",
                           @"10",];
    //get from the main app
    
    [self presentControllerWithNames:controllerNames contexts:contexts];
    
}

- (IBAction)favoriteButtonPressed {
    
    NSArray *controllerNames = @[
                                 @"pageController",
                                 @"pageController",
                                 @"pageController",
                                 @"pageController",
                                 @"pageController"
                                 ];
    
    NSArray *contexts  = @[@"1",
                           @"2",
                           @"3",
                           @"4",
                           @"5"];
    //get from the main app
    
    [self presentControllerWithNames:controllerNames contexts:contexts];
    
}




@end



