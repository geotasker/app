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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // NSLog(@"%@", toDoItem.itemName);
    
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor myNavyColor]];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor cloudsColor]};

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
