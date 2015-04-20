//
//  DetailViewController.m
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/10/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "SharedNetworking.h"
#import "DetailViewController.h"
#import "bookmarkTableViewController.h"
#import "FileSession.h"


@interface DetailViewController ()<UIWebViewDelegate, UIActionSheetDelegate, NSCoding, UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *myWebVIew;
//the main webview of displaying web page

@property (strong, nonatomic) NSMutableArray *favoriteArray;
//items in the array will be loaded to BookmarkViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoriteButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *twitterButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *facebookButton;
//UIBarButtons' outlets

@property (weak, nonatomic) IBOutlet UIView *loadingView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *networkIndicator;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"The url is %@", self.url);
    
    if ([self.url isEqualToString:@"http://google.com"]) {
        self.favoriteButton.enabled = NO;
        self.twitterButton.enabled = NO;
        self.facebookButton.enabled = NO;
        //when the view is loaded at the first time, we choose google.com as the default page
        //and the default page can't be liked or shared
    }

    NSURL* nsUrl = [NSURL URLWithString:self.url];
    //get the url from segue
    
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    
     self.myWebView.delegate = self;
    self.myWebView.scalesPageToFit = YES;
    self.myWebView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.myWebView loadRequest:request];
    //load the URL request to WebView
    
    
    NSURL *fileURL= [FileSession getListURL];
    
    self.favoriteArray = [NSMutableArray arrayWithArray:[FileSession readDataFromList:fileURL]];
    //save favorite items to array, and things will be loaded to bookmarkViewController
    
    //test if the article is favorited
    self.favoriteStar.hidden = YES;
    for (int i=0; i<self.favoriteArray.count; i++) {
        NSString *title = [[self.favoriteArray objectAtIndex:i] title];
        if ([title isEqualToString:self.item.title]) {
            self.favoriteStar.hidden = NO;
            NSLog(@"It's a favorite article");
            //use loop to detect is the page is already liked before
            break;
        }
    }
    
    //load the default page
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (self.item!=nil) {
        NSData *serialized = [NSKeyedArchiver archivedDataWithRootObject:self.item];
        
        [defaults setObject:serialized forKey:@"lastItem"];
        
        
    }
    
    [defaults setObject:self.url forKey:@"lastUrl"];
    [defaults synchronize];
    
    
    //set the loading view to a round rect
    self.loadingView.layer.cornerRadius = 10;
    self.loadingView.layer.masksToBounds = YES;
    
    [self stateChanged];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(stateChanged)
                   name:UIContentSizeCategoryDidChangeNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(stateChanged)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];
    
    
}


//Settings changed
-(void)stateChanged{
    NSLog(@"the state is changed");
    
    BOOL nightMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_nightmode"];
    UINavigationController *detailNavigationController = (UINavigationController *)self.parentViewController;
    if (nightMode == true) {
        [detailNavigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
        [detailNavigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [detailNavigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                          [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0], NSFontAttributeName,nil]];
        [detailNavigationController.navigationBar setNeedsDisplay];
        
        [detailNavigationController.toolbar setBarStyle:UIBarStyleBlackTranslucent];
        [detailNavigationController.toolbar setTintColor:[UIColor whiteColor]];
        [detailNavigationController.toolbar setNeedsDisplay];
        
    }
    else{
//        [detailNavigationController.navigationBar setTintColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0]];
        
        [detailNavigationController.navigationBar setBarStyle:UIBarStyleDefault];
        [detailNavigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                          [UIColor blackColor], NSForegroundColorAttributeName,
                                                                          [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0], NSFontAttributeName,nil]];
        [detailNavigationController.navigationBar setNeedsDisplay];
        
        [detailNavigationController.toolbar setBarStyle:UIBarStyleDefault];
        [detailNavigationController.toolbar setTintColor:[UIColor grayColor]];
        [detailNavigationController.toolbar setNeedsDisplay];
        

    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addFavorite:(UIBarButtonItem *)sender {
    
    if(![SharedNetworking isNetworkAvailable])
    {
        return;
    }
    
    NSInteger flag = 0;
    //flag is 0: the page is not in the bookmark list
    //flag is 1: the page is in the bookmark list
    
    for (int i=0; i<self.favoriteArray.count; i++) {
        NSString *title = [[self.favoriteArray objectAtIndex:i] title];
        if ([title isEqualToString:self.item.title]) {
            flag =1;
            //use loop to detect is the page is already liked before
            break;
        }
    }
    
    if (flag == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Favorite" message:@"this page is already favorited, and you can check it out in bookmark" delegate:self cancelButtonTitle:@"got it" otherButtonTitles:nil, nil];
        
        [alert show];
        //UIAlertView to inform users that the page can't be liked again
    }
    else{
     
        [self.favoriteArray addObject:self.item];
        
        NSURL *fileURL = [FileSession getListURL];
        [FileSession writeData:self.favoriteArray ToList:fileURL];
        
        //add the page info into bookmark
        //and sync to standardUserDefault
        self.favoriteStar.hidden = NO;
        
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Liked it" message:@"you can check this page out from bookmark" delegate:self cancelButtonTitle:@"sure" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    
    NSLog(@"favorite item is added");
    
}

#pragma mark-social network implementation

- (IBAction)TweetAboutIt:(UIBarButtonItem *)sender {
    
    if(![SharedNetworking isNetworkAvailable])
    {
        return;
    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitterPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSString *text = [NSString stringWithFormat:@"great page: %@ ,check it out: %@",self.item.title,self.item.link];
        [twitterPost setInitialText:text];
        [self presentViewController:twitterPost animated:YES completion:nil];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}

- (IBAction)facebookSharing:(UIBarButtonItem *)sender {
    
    if(![SharedNetworking isNetworkAvailable])
    {
        return;
    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebookPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        NSString *text = [NSString stringWithFormat:@"great page: %@ ,check it out: %@",self.item.title, self.item.link];
        [facebookPost setInitialText:text];
        [self presentViewController:facebookPost animated:YES completion:nil];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a Facebook post right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}


#pragma mark - webView delegate implementation

//network indicator specification
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.networkIndicator startAnimating];
    self.loadingView.hidden = NO;

}



-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.loadingView.hidden = YES;
    [self.networkIndicator stopAnimating];
    
    
//    
//    CGSize contentSize = webView.scrollView.contentSize;
//    CGSize viewSize = self.view.bounds.size;
//    
//    float rw = viewSize.width / contentSize.width;
//    
//    webView.scrollView.minimumZoomScale = rw;
//    webView.scrollView.maximumZoomScale = rw;
//    webView.scrollView.zoomScale = rw;
    
}



#pragma mark - bookmark Delegate implementation

-(void)bookmark:(id)sender sendsURL:(NSURL *)url andUpdateArticleItem:(Article *)article{
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:url]];
    self.item = article;
    self.favoriteStar.hidden = YES;
    
    for (int i=0; i<self.favoriteArray.count; i++) {
        NSString *title = [[self.favoriteArray objectAtIndex:i] title];
        if ([title isEqualToString:self.item.title]) {
            self.favoriteStar.hidden = NO;
            NSLog(@"It's a favorite article");
            //use loop to detect is the page is already liked before
            break;
        }
    }
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showBookMark"])
    {
        UINavigationController *destination = [segue destinationViewController];
        
        bookmarkTableViewController *bookmarkVC = (bookmarkTableViewController *)[destination topViewController];
        
        UIPopoverPresentationController *popPC = destination.popoverPresentationController;
        popPC.delegate = self;
        bookmarkVC.delegate = self;
        
        //segue the favorite Array to bookmarkViewController
        [bookmarkVC setItemArray:self.favoriteArray];
    
    }
    
    
}





- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}


@end
