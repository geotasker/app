//
//  XYZSettingsViewController.m
//  toDoList
//
//  Created by Dean Makino on 5/2/14.
//
//

#import "XYZSettingsViewController.h"
#import "XYZAppDelegate.h"
#import "findMatches.h"

@interface XYZSettingsViewController ()

@end



@implementation XYZSettingsViewController

@synthesize locationSwitch; // THIS IS REALLY THE TURN OFF ALL ALERTS SWITCH
@synthesize radiusSlider;
@synthesize website;

float initialSliderValue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)sliderAction:(id)sender {
    
    radiusScale = radiusSlider.value;
}

-(IBAction)switchAction:(id)sender
{
    NSLog(@"%d", alertsOn);

    if (locationSwitch.on)
    {
        alertsOn = true;
    }
    else {
        alertsOn = false;
    }
}


-(void)toWebsite
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://sites.google.com/site/geotasker333/home"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor darkGrey]];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor headingColor]};
    
    [self.navigationController.navigationBar setTintColor:[UIColor headingColor]];
    
    [website addTarget:self action:@selector(toWebsite) forControlEvents:UIControlEventTouchUpInside];
    
    locationSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [locationSwitch setOnTintColor:[UIColor accentColor]];
    
    [locationSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    if(alertsOn){
        [locationSwitch setOn:YES];
    }
    else{
        [locationSwitch setOn:NO];
    }
    
    initialSliderValue = radiusSlider.value;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (radiusSlider.value != initialSliderValue) {
        [findMatches find];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
