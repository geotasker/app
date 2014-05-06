//
//  XYZSettingsViewController.m
//  toDoList
//
//  Created by Dean Makino on 5/2/14.
//
//

#import "XYZSettingsViewController.h"
#import "XYZAppDelegate.h"

@interface XYZSettingsViewController ()

@end



@implementation XYZSettingsViewController

@synthesize locationSwitch;
@synthesize website;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor myTurquoiseColor2]];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor midnightBlueColor]};
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [website addTarget:self action:@selector(toWebsite) forControlEvents:UIControlEventTouchUpInside];
    
    locationSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [locationSwitch setOnTintColor:[UIColor midnightBlueColor]];
    [locationSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    if(alertsOn){
        [locationSwitch setOn:YES];
    }
    else{
        [locationSwitch setOn:NO];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
