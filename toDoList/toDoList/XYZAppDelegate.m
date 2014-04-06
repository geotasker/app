//
//  XYZAppDelegate.m
//  toDoList
//
//  Created by Mitchell Vollger on 3/19/14.
//
//

#import "XYZAppDelegate.h"
#import "XYZToDoListViewController.h"
#import "XYZToDoItem.h"

@implementation XYZAppDelegate

@synthesize window = _window;
@synthesize locationManager=_locationManager;


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        //Location timestamp is within the last 15.0 seconds, let's use it
        if(newLocation.horizontalAccuracy < 35.0){
            //Location is accurate enough, let's use it
            
            CLLocation *currentLocation = newLocation;
            
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"New task available"
                                                                  message:@""
                                                                 delegate:nil
                                                                cancelButtonTitle:@"Not now"
                                                                otherButtonTitles:@"show task"];
                [message show];
            }
            
            else if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground){
                
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
                localNotification.alertBody = @"You have moved somewhere else!";
                localNotification.timeZone = [NSTimeZone defaultTimeZone];
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            }
            
            
            if (currentLocation != nil) {
                NSLog(@"%.8f", currentLocation.coordinate.longitude);
                NSLog(@"%.8f", currentLocation.coordinate.latitude);
                
            }
            //
            //    // Reverse Geocoding
            //    NSLog(@"Resolving the Address");
            //    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            //        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
            //        if (error == nil && [placemarks count] > 0) {
            //            placemark = [placemarks lastObject];
            //            _addressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
            //                                  placemark.subThoroughfare, placemark.thoroughfare,
            //                                  placemark.postalCode, placemark.locality,
            //                                  placemark.administrativeArea,
            //                                  placemark.country];
            //        } else {
            //            NSLog(@"%@", error.debugDescription);
            //        }
            //    } ];
            
        }
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    CLGeocoder *geocoder;
//    CLPlacemark *placemark;
    
    if(self.locationManager==nil){
        NSLog(@"locationManager not nil\n");
        _locationManager=[[CLLocationManager alloc] init];
        //I'm using ARC with this project so no need to release
        
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=500; //min dist in m before update event is generated
        self.locationManager=_locationManager;
    }
    
    if([CLLocationManager locationServicesEnabled]){
        [self.locationManager startUpdatingLocation];
    }
    
    return YES;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(NSDictionary *)userInfo {
    //bring up notification view
    UIViewController *vc = (UIViewController *)self.window.rootViewController;
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * pvc = [storyboard instantiateViewControllerWithIdentifier:@"NotificationView"];
    [vc presentViewController:pvc animated:YES completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


@end
