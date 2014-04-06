//
//  ViewController.m
//  queryMaps2
//
//  Created by Shreya Nathan on 4/5/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

CLLocationManager *locationManager;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // MKMapView *map = [[MKMapView alloc] initWithFrame:self.view.bounds];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
}

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    NSLog(@"%@", [self deviceLocation]);
}


//- (void) mapView:(MKMapView*)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//    
//    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
//    request.naturalLanguageQuery = self.myTextField.text;
//
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
//    request.region = MKCoordinateRegionMake(userLocation.location.coordinate, span);
//    
//    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
//    
//    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
//        
//        for (MKMapItem *item in response.mapItems) {
//            NSLog(@"%@", item.name);
//        }
//    }];
//
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"You entered %@",self.myTextField.text);
    // deviceLocation();
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.myTextField.text;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    request.region = MKCoordinateRegionMake(locationManager.location.coordinate, span);
    NSLog(@"location %@", locationManager.location.description);
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        int i = 0;
//        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50 + 20*i, 300, 200)];
//        [self.view addSubview:myLabel];
//        myLabel.text =[NSString stringWithFormat:@"%@ near you", self.myTextField.text];
        
        for (MKMapItem *item in response.mapItems) {
            
            UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50 + 20*i, 300, 200)];
            myLabel.numberOfLines = 1;
            [self.view addSubview:myLabel];
            
            NSString *myString = [NSString stringWithFormat:@"%@ %@", item.name, item.phoneNumber];
            myLabel.text = myString;
            
            NSLog(@"%@", item.name);
            NSLog(@"%@", item.phoneNumber);
            
            
            
            NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
            MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
            
            [MKMapItem openMapsWithItems:@[currentLocationMapItem, item] launchOptions:options];
            i = i+1;
        }
        
    }];
    
    [self.myTextField resignFirstResponder];
    return YES;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
