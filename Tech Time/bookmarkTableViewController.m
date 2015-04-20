//
//  bookmarkTableViewController.m
//  Splitting Up is Easy To Do
//
//  Created by Alex Xiao on 2/13/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "bookmarkTableViewController.h"
#import "SharedNetworking.h"
#import "FileSession.h"

@interface bookmarkTableViewController ()<UIAlertViewDelegate>

@end

@implementation bookmarkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(stateChangedX)
                   name:NSUserDefaultsDidChangeNotification
                 object:nil];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_nightmode"]) {
        self.tableView.backgroundColor  = [UIColor colorWithWhite:0 alpha:0.7];
    }
    else{
        self.tableView.backgroundColor  = [UIColor colorWithWhite:1 alpha:0.7];

    }
    
    [self stateChangedX];
    
}

-(void)stateChangedX{
    
    UINavigationController *bookmarkNavigationController = (UINavigationController *)self.parentViewController;
    NSLog(@"BookmarkView state Changeed");
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_nightmode"]) {
        self.tableView.backgroundColor  = [UIColor colorWithWhite:0 alpha:0.7];
        [bookmarkNavigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [bookmarkNavigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
        [bookmarkNavigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                    [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0], NSFontAttributeName,nil]];
        [bookmarkNavigationController.navigationBar setNeedsDisplay];
        
        [bookmarkNavigationController.toolbar setBarStyle:UIBarStyleBlackTranslucent];
        [bookmarkNavigationController.toolbar setTintColor:[UIColor whiteColor]];
        [bookmarkNavigationController.toolbar setNeedsDisplay];
    }
    else{
        self.tableView.backgroundColor  = [UIColor colorWithWhite:1 alpha:0.7];
        [bookmarkNavigationController.navigationBar setTintColor:[UIColor blackColor]];
        [bookmarkNavigationController.navigationBar setBarStyle:UIBarStyleDefault];
        [bookmarkNavigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                            [UIColor blackColor], NSForegroundColorAttributeName,
                                                                            [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0], NSFontAttributeName,nil]];
        [bookmarkNavigationController.navigationBar setNeedsDisplay];
        
        [bookmarkNavigationController.toolbar setBarStyle:UIBarStyleDefault];
        [bookmarkNavigationController.toolbar setTintColor:[UIColor grayColor]];
        [bookmarkNavigationController.toolbar setNeedsDisplay];

    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-toolbar buttons

- (IBAction)EditTable:(UIBarButtonItem *)sender {
    
    if ([self.tableView isEditing]) {
        self.tableView.editing = NO;
        sender.title = @"Edit";
    }
    else{
        self.tableView.editing = YES;
        sender.title = @"Done";
    }
    
}

- (IBAction)clearBookMark:(UIBarButtonItem *)sender {
    
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"you are going to delete all bookmark records" delegate:self cancelButtonTitle:@"Sure" otherButtonTitles:@"Never mind", nil];
    [deleteAlert show];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.ItemArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookmarkCell" forIndexPath:indexPath];
    
    
    
    Article* article = [self.ItemArray objectAtIndex:indexPath.row];
    cell.textLabel.text = article.title;
    cell.detailTextLabel.text = article.contentSnippet;
    //load bookmark cell
    
    //Night Mode 
    BOOL nightMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"enabled_nightmode"];
    if (nightMode == true) {
        cell.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor blackColor];
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(![SharedNetworking isNetworkAvailable])
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    //Network checking, to make the app robust
    
    Article* article = [self.ItemArray objectAtIndex:indexPath.row];
    
    NSString* url = article.link;
    
    [self.delegate bookmark:self sendsURL:[NSURL URLWithString:url] andUpdateArticleItem:article];
    //segue items back
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.ItemArray removeObjectAtIndex:indexPath.row];
        
        NSURL *fileURL = [FileSession getListURL];
        [FileSession writeData:self.ItemArray ToList:fileURL];
        
        //bookmark Edit
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }
}

#pragma mark - UIAlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self.ItemArray removeAllObjects];
        NSURL *fileURL = [FileSession getListURL];
        [FileSession writeData:self.ItemArray ToList:fileURL];
        [self.tableView reloadData];
    }
}


@end
