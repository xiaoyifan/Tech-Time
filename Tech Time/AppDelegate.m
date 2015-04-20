//
//  AppDelegate.m
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/10/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MasterViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@property (nonatomic, strong) UIViewController *vc;
@property (strong, nonatomic) DetailViewController *detailViewController;

@property (nonatomic, strong) UIView *splash;


@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    
    NSObject *night_obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"enabled_nightmode"];
    //Check if the key is settle in UserDefaults

    if (!night_obj) {
        [self registerSettingBundle];
    }
    else{
        NSLog(@"night mode: %@", night_obj.description);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_nightmode"]) {
    
            [self setBlackAttribute];
            
        }
        else{
            [self setWhiteAttribute];
        }
        //Set relative attributes for the night/day mode
    }
    

    //MasterViewController *master = (MasterViewController *)[[splitViewController.viewControllers firstObject] topViewController];
    //Assign the splashSceen to AppDelegate
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(removeSplashView) name:@"tableViewdidLoad" object:nil];
    
    
    self.splash = [[UIImageView alloc]initWithFrame:self.window.bounds];
    UIImageView *chicago = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Chicago.jpg"]];
    [self.splash addSubview:chicago];
    [self.window.rootViewController.view addSubview:self.splash];
    
    self.splash.alpha = 0;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.splash.alpha = 1;
                     }];
    

    return YES;
}

-(void)removeSplashView{
    
    [UIView animateWithDuration:2.5
                     animations:^{self.splash.alpha = 0.0;}
                     completion:^(BOOL finished){
                         [self.splash performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];

                     }];
}




#pragma mark - Night/Day mode attributes settings
-(void)setBlackAttribute
{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarStyle: UIBarStyleBlackTranslucent];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0], NSFontAttributeName,nil]];
    [[UIToolbar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    [[UIToolbar appearance] setTintColor:[UIColor whiteColor]];
}

-(void)setWhiteAttribute
{
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor blackColor], NSForegroundColorAttributeName,
                                                          [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0], NSFontAttributeName,nil]];
    
}


-(void)registerSettingBundle{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaultsMode = [NSDictionary dictionaryWithObject:@"NO"
                                                                forKey:@"enabled_nightmode"];
    [defaults registerDefaults:appDefaultsMode];
    
    [defaults synchronize];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
            // animate = NO because we don't want to see the mainVC's view
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]]) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}


@end
