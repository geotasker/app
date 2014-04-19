//
//  XYZMapViewController.m
//  toDoList
//
//  Created by Mitchell Vollger on 4/11/14.
//
//

#import "XYZMapViewController.h"
#import "XYZToDoItem.h"
#import "XYZDetailsViewController.h"
#import "XYZAppDelegate.h"
#import <MapKit/MapKit.h>

@interface XYZMapViewController ()

@end

@implementation XYZMapViewController

@synthesize toDoItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)getDirections:(id)sender
{
    
    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking};
    MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
    
            NSLog(@"%@", currentLocationMapItem.description);
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, toDoItem.closeMatch] launchOptions:options];
        NSLog(@"apple maps opened");
    
    NSLog(@"%@", currentLocationMapItem.description);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%@", toDoItem.itemName);
    
    self.map.mapType = MKMapTypeStandard;
    self.map.zoomEnabled = YES;
    self.map.showsUserLocation = YES;
    
    // note make the view size dynamic
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(
    CLLocationCoordinate2DMake(currentLoc.coordinate.latitude, currentLoc.coordinate.longitude), 3100, 3100);
    
    [self.map setRegion:region animated:YES];
    
    CLLocationCoordinate2D close = CLLocationCoordinate2DMake(toDoItem.closeMatch.placemark.coordinate.latitude, toDoItem.closeMatch.placemark.coordinate.longitude);
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
    point.coordinate = close;
    point.title = toDoItem.closeMatch.name;
    
    [self.map addAnnotation:point];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
