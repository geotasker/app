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
BOOL show;

@implementation findMatches

+ (int)find:(CLLocation *)currentLoc {
    
    NSLog(@"find matches start");
    
    [findMatches setRadius];
    
    __block dispatch_queue_t queue;
    queue = dispatch_queue_create("com.example.myQueueForMaps", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{ 
        
        __block int pos = 0;
        __block NSUInteger counts = [toDoItems count];
        
        for(XYZToDoItem* item in toDoItems){
            
            if (item.hasLocation==true) {
                
                
                MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
                
                if (item.itemLocation != nil){
                    request.naturalLanguageQuery = item.itemLocation;
                }
                else{
                    request.naturalLanguageQuery = item.itemName;
                }
                
                // somehow deal with radius
                MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
                request.region = MKCoordinateRegionMake(currentLoc.coordinate, span);
                MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
                
                [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
                    
                    double minimum = INFINITY;
                    MKMapItem *closest;
                    for (MKMapItem *mapitem in response.mapItems) {
                        
                        CLLocation *loc = mapitem.placemark.location;
                        CLLocationDistance dist = [currentLoc distanceFromLocation:loc];
                        
                        if (dist < minimum) {
                            minimum = dist;
                            closest = mapitem;
                        }
                        if(dist <= item.radius){
                            [item.matches addObject:mapitem];
                            NSLog(@"%lu", (unsigned long)[item.matches count]);
                        }
                       // NSLog(@"%d", item.radius);
                    }
                    
                    if (minimum <= item.radius) {
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
        [alert dismissWithClickedButtonIndex:0 animated:false];

        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground && alertsOn)
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
        
        UINavigationController *topController = (UINavigationController *)[XYZAppDelegate topMostController];
        
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive && alertsOn && [topController.visibleViewController class] != [XYZToDoListViewController class])
        {
               
            if(x > 1){
                alert = [[UIAlertView alloc] initWithTitle:@"GeoTasker" message:str delegate:self
                                         cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
            }
            if (x == 1){
                NSString *name = [NSString stringWithFormat: @"Do \"%@\" at %@", oneAlert.itemName, oneAlert.closeMatch.name];
                
                alert = [[UIAlertView alloc] initWithTitle:@"GeoTasker" message:name delegate:self
                                         cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
                
            }
            
            /*show = YES;
            
            for (UIWindow* window in [UIApplication sharedApplication].windows) {
                NSArray* subviews = window.subviews;
                if ([subviews count] > 0) {
                    
                    BOOL alert = [[subviews objectAtIndex:0] isKindOfClass:[UIAlertView class]];
                    BOOL action = [[subviews objectAtIndex:0] isKindOfClass:[UIActionSheet class]];
                    
                    if (alert || action)
                        show = NO;
                }
            }*/
            
            //if (show)
                //{
                    [alert show];
                  //  show = NO;
               // }
        }
        
    }
}


+ (void) setRadius{
    
    NSLog(@"start of set radius");
    
    
    for(XYZToDoItem *item in toDoItems){
        
        [item.matches removeAllObjects];
        item.closeMatch = nil;
    
        if(driving){
            item.radius = 800;
        }
        else{
            item.radius = 500;
        }
        
    }
    NSLog(@"end of set radius");
    
}



/*+(void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    show = YES;
}*/


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


