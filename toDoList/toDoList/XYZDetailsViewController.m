//
//  XYZDetailsViewController.m
//  toDoList
//
//  Created by Mitchell Vollger on 3/20/14.
//
//

#import "XYZDetailsViewController.h"
#import "XYZToDoItem.h"
#import "findMatches.h"
#import "XYZToDoListViewController.h"

@interface XYZDetailsViewController ()

- (IBAction)localalertbutton:(id)sender;

@end

@implementation XYZDetailsViewController

@synthesize name1;
@synthesize locationSwitch;
@synthesize scrollView;
@synthesize radius;
@synthesize notes;
@synthesize notesBox;

@synthesize toDoItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{   // Initialization
    [super viewDidLoad];
    
    name1.delegate = self;
    [self.view addSubview:name1];
    
    notesBox.delegate = self;
    [self.view addSubview:notesBox];
    
    [locationSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    self.scrollView.contentSize =CGSizeMake(320, 758);
    
    scrollView.contentInset=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
    scrollView.scrollIndicatorInsets=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);


    // Do any additional setup after loading the view from its nib.
    self.name1.text = toDoItem.itemName;
    self.locationSwitch.on = toDoItem.hasLocation;
    self.notesBox.text = toDoItem.itemNotes;


//    self.scrollNotes.text = toDoItem.itemNotes;
//    self.scrollNotes.layer.borderColor = [[UIColor blackColor] CGColor];
//    self.scrollNotes.layer.borderWidth = 1.0;
//    self.scrollNotes.layer.cornerRadius = 5.0;
//    self.scrollNotes.clipsToBounds = YES;

    self.radius.text = toDoItem.itemRadius;
    self.radius.layer.borderColor = [[UIColor blackColor] CGColor];
    self.radius.layer.borderWidth = 1.0;
    self.radius.layer.cornerRadius = 5.0;
    self.radius.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)localalertbutton:(id)sender {
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    localNotification.alertBody = @"New Task Available";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    
}


// Alerts ************
-(IBAction)alertbutton{
    alert = [[UIAlertView alloc] initWithTitle:@"GeoTasker" message:@"Press Accept Directions" delegate:self
                             cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Accept", nil];
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"NotificationView"];
        [self presentViewController:vc animated:YES completion:nil];
    }
}
// end alerts ******


// UITextField Stuff
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    textField.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
    if (textField.tag == 1) {
        toDoItem.itemName = self.name1.text;
    }
    if (textField.tag == 2) {
        toDoItem.itemNotes = self.notesBox.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    [textField resignFirstResponder];
    return YES;
}

// Location switch stuff
-(IBAction)switchAction:(id)sender{
    NSLog(@"locationSwitch");
    if(locationSwitch.on) {
        toDoItem.hasLocation = true;
        [findMatches find:currentLoc];
    }
    else {
        toDoItem.hasLocation = false;
        toDoItem.match = false;
        toDoItem.closeMatch = nil;
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue.identifier isEqualToString:@"mapView"] ) {
        XYZDetailsViewController *destViewController = segue.destinationViewController;
        destViewController.toDoItem = toDoItem;
    }
}


@end
