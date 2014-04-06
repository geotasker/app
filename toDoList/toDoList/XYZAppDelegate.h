//
//  XYZAppDelegate.h
//  toDoList
//
//  Created by Mitchell Vollger on 3/19/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface XYZAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end