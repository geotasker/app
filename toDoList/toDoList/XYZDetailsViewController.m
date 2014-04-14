//
//  XYZDetailsViewController.m
//  toDoList
//
//  Created by Mitchell Vollger on 3/20/14.
//
//

#import "XYZDetailsViewController.h"
#import "XYZToDoItem.h"
#import "XYZMapViewController.h"


@interface XYZDetailsViewController ()


@end

@implementation XYZDetailsViewController

@synthesize name;
@synthesize radius;
@synthesize notes;
@synthesize scrollNotes;
@synthesize scrollView;
@synthesize locationBool;

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
{
    [super viewDidLoad];
    
    self.scrollView.contentSize =CGSizeMake(320, 758);
    
    scrollView.contentInset=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
    scrollView.scrollIndicatorInsets=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);


    // Do any additional setup after loading the view from its nib.
    self.name.text = toDoItem.itemName;
    self.radius.text = toDoItem.itemRadius;
    self.scrollNotes.text = toDoItem.itemNotes;
  
    self.scrollNotes.layer.borderColor = [[UIColor blackColor] CGColor];
    self.scrollNotes.layer.borderWidth = 1.0;
    self.scrollNotes.layer.cornerRadius = 5.0;
    self.scrollNotes.clipsToBounds = YES;

    self.name.layer.borderColor = [[UIColor blackColor] CGColor];
    self.name.layer.borderWidth = 1.0;
    self.name.layer.cornerRadius = 5.0;
    self.name.clipsToBounds = YES;
    
    self.radius.layer.borderColor = [[UIColor blackColor] CGColor];
    self.radius.layer.borderWidth = 1.0;
    self.radius.layer.cornerRadius = 5.0;
    self.radius.clipsToBounds = YES;
    
    //eventually all this should be editable
    locationBool.text = (toDoItem.hasLocation ? @"Yes" : @"No");
    
// not using this line or item anymore
    self.notes.text = toDoItem.itemNotes;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ( [segue.identifier isEqualToString:@"mapSegue"] ) {
        XYZToDoItem *item = self.toDoItem;
        XYZMapViewController *destViewController = segue.destinationViewController;
        destViewController.toDoItem = item;
        
        
        //bring up apple maps directions
        NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking};
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, item.closeMatch] launchOptions:options];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
