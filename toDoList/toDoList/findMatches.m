//
//  findMatches.m
//  queryMaps2
//
//  Created by Shreya Nathan on 4/6/14.
//  Copyright (c) 2014 Shreya Nathan. All rights reserved.
//

#import "findMatches.h"
#import "XYZToDoListViewController.h"
#import "XYZToDoItem.h"
#import <UIKit/UIKit.h>
#import "XYZAppDelegate.h"

XYZToDoItem *oneAlert = nil;

@implementation findMatches

CLLocationManager *locationManager;

+ (int)find:(CLLocation *)currentLoc {
    
    __block dispatch_queue_t queue;
    queue = dispatch_queue_create("com.example.myQueueForMaps", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        
        __block int pos = 0;
        __block NSUInteger counts = [toDoItems count];
        
        for(XYZToDoItem* item in toDoItems){
            
            if (item.hasLocation==true) {
                
                MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
                request.naturalLanguageQuery = item.itemName;
                // somehow deal with radius
                MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
                request.region = MKCoordinateRegionMake(currentLoc.coordinate, span);
                MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
                
                [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
                    
                    double minimum = INFINITY;
                    MKMapItem *closest;
                    for (MKMapItem *item in response.mapItems) {
                        
                        CLLocation *loc = item.placemark.location;
                        CLLocationDistance dist = [currentLoc distanceFromLocation:loc];
                        
                        if (dist < minimum) {
                            minimum = dist;
                            closest = item;
                        }
                    }
                    
                    if (minimum < item.radius) {
                        item.closeMatch = closest;
                        item.match = true;
                        pos++;
                    }
                    else {
                        item.match = false;
                        NSLog(@"No item match");
                        item.closeMatch = nil;
                        pos++;
                    }
                    
                    if( counts == pos){
                        [findMatches notifyNearbyTasks];
                    }
                    
                }];
            }
            else{
                counts--;
            }
        }
    });
    
    return 1;
    
}




+ (void)notifyNearbyTasks
{
    int x = 0;
    for (XYZToDoItem *task in toDoItems) {
        if (task.match == true) {
            oneAlert = task;
            x = x+1;
        }
    }
    NSString *str = [NSString stringWithFormat: @"You have %d new tasks", x];
    NSLog(@"%@", str);
    
    UIViewController *root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [root viewDidAppear:true];
    
    if(x>1){
        oneAlert = nil;
    }
    
    if (x>0) {
        
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
        {
            //NSLog(@"\n A Wild Alert Window Appears!\n");
            
            if (x==1)
            {
                str = [NSString stringWithFormat: @"Do \"%@\" at %@", oneAlert.itemName, oneAlert.closeMatch.name];
            }
            
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
            localNotification.alertBody = str;
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
        
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
            if( x >1 ){
                alert = [[UIAlertView alloc] initWithTitle:@"GeoTasker" message:str delegate:self
                                         cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Accept", nil];
            }
            if (x == 1){
                NSString *name = [NSString stringWithFormat: @"Do \"%@\" at %@", oneAlert.itemName, oneAlert.closeMatch.name];
                
                alert = [[UIAlertView alloc] initWithTitle:@"GeoTasker" message:name delegate:self
                                         cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Directions", nil];
                
            }
            [alert show];
        }
    }
}



+(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSLog(@"going to apple maps");
    if (buttonIndex == 1) {
        UINavigationController *top = [XYZAppDelegate topMostController];
                
        NSLog(@"%@", top.parentViewController.navigationController);
        
        [top.parentViewController.navigationController popToRootViewControllerAnimated:YES];
        
        if (oneAlert != nil)
        {
            [top.visibleViewController performSegueWithIdentifier:@"showDetailfromDelegate" sender:self];
            //[top.visibleViewController performSegueWithIdentifier:@"showMapfromDelegate" sender:self];
        }
        
    }
}


+ (void) localDirections{
    //bring up apple maps directions
    
    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking};
    MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
    
    __block dispatch_queue_t queue;
    queue = dispatch_queue_create("com.example.localDirections", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"%@", currentLocationMapItem.description);
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, oneAlert.closeMatch] launchOptions:options];
        NSLog(@"apple maps opened");
        
    });
    
    NSLog(@"%@", currentLocationMapItem.description);
    
    
}


@end


