//
//  findMatches.m
//  queryMaps2
//
//  Created by Shreya Nathan on 4/6/14.
//  Copyright (c) 2014 Shreya Nathan. All rights reserved.
//

#import "findMatches.h"

@implementation findMatches

CLLocationManager *locationManager;

//- (id) init {
//    // self = [super init];
//    queries = [[NSMutableArray alloc] init];
// 
//    XYZToDoItem *item1 = [[XYZToDoItem alloc] init];
//    item1.itemName = @"trader joes";
//    [queries addObject:item1];
//    
//    XYZToDoItem *item2 = [[XYZToDoItem alloc] init];
//    item1.itemName = @"starbucks";
//    [queries addObject:item2];
//    
////    locationManager = [[CLLocationManager alloc] init];
////    locationManager.distanceFilter = kCLDistanceFilterNone;
////    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
////    [locationManager startUpdatingLocation];
////    
////    MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
////    CLLocation *currentLoc = currentLocationMapItem.placemark.location;
//    
//    CLLocation *currentLoc = [[CLLocation alloc] initWithLatitude:37.7833 longitude:-122.4167];
//    
//    for (XYZToDoItem *item in queries) {
//        [findMatches find:item loc:currentLoc];
//    }
//    
//    return self;
//}

+ (void)find:(XYZToDoItem *)item loc:(CLLocation *)currentLoc {
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = item.itemName;
    
    // somehow deal with radius
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    request.region = MKCoordinateRegionMake(currentLoc.coordinate, span);
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        int i = 0;
        double minimum = INFINITY;
        MKMapItem *closest;
        
        for (MKMapItem *item in response.mapItems) {
            
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50 + 20*i, 300, 200)];
            myLabel.numberOfLines = 1;
            
            NSString *myString = [NSString stringWithFormat:@"%@ %@", item.name, item.phoneNumber];
            myLabel.text = myString;
            
            CLLocation *loc = item.placemark.location;
            CLLocationDistance dist = [currentLoc distanceFromLocation:loc];
            
            if (dist < minimum) {
                minimum = dist;
                closest = item;
            }
            
            //NSLog(@"%@", closest.name);
            //NSLog(@"dist %f", minimum);
            
        }
        
        if (minimum < item.radius) {
            NSLog(@"match %@", closest.name);
            item.closeMatch = closest;
            item.match = TRUE;
        }
        else {
            item.match = FALSE;
            item.closeMatch = nil;
        }
        
        // NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
        
        // [MKMapItem openMapsWithItems:@[currentLocationMapItem, closest] launchOptions:options];
        
    }];

}

@end


