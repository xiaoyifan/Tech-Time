//
//  SharedNetworking.m
//  Splitting Up is Easy To Do
//
//  Created by XiaoYifan on 2/11/15.
//  Copyright (c) 2015 XiaoYifan. All rights reserved.
//

#import "SharedNetworking.h"

@implementation SharedNetworking

+(id)sharedSharedWorking{
 
    static dispatch_once_t pred;
    static SharedNetworking *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[self alloc]init];
    });
    return shared;
}

+ (BOOL)isNetworkAvailable
{
    CFNetDiagnosticRef dReference;
    dReference = CFNetDiagnosticCreateWithURL (NULL, (__bridge CFURLRef)[NSURL URLWithString:@"www.apple.com"]);
    
    CFNetDiagnosticStatus status;
    status = CFNetDiagnosticCopyNetworkStatusPassively (dReference, NULL);
    
    CFRelease (dReference);
    
    if ( status == kCFNetDiagnosticConnectionUp ) {
        NSLog (@"Connection is fine");
        return YES;
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Unavailable" message:@"Please check you connection. Have no access to the network" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
}

-(void)getFeedForURL:(NSString*)url
             success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
             failure:(void (^)(void))failureCompletion{
    
    if (![SharedNetworking isNetworkAvailable]) {
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Google News API url
//    NSString *googleUrl = @"http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=30&q=http%3A%2F%2Fbeautifulpixels.com/feed/";
    
    NSString *googleUrl = @"http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=30&q=http%3A%2F%2Fengadget.com/rss.xml";
    
    // Create NSUrlSession
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Create data download task
    [[session dataTaskWithURL:[NSURL URLWithString:googleUrl]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                //NSLog(@"Response:%@", response);
                        
                NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                
                if (httpResp.statusCode == 200) {
                    NSError *jsonError;
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:NSJSONReadingAllowFragments
                                                                                 error:&jsonError];
                    //NSLog(@"Downloaded Data: %@", dictionary);
                    
                    successCompletion(dictionary, nil);
                    
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                }
                else{
                    
                    NSLog(@"Fail not 200");
                    
                    
                    // Use dispatch_async to update the table on the main thread
                    // Remember that NSURLSession is downloading in the background
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (failureCompletion) {
                            failureCompletion();
                            //handle the situation if the network connection is failed.
                            UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"network is not available right now, check it out later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            
                            [failure show];
                        }
                        //code to end the refreshing operation
                    });
                }
                
            }] resume];
    
    
}

@end
