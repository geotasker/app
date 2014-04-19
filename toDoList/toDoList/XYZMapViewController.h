//
//  XYZMapViewController.h
//  toDoList
//
//  Created by Mitchell Vollger on 4/11/14.
//
//

#import <UIKit/UIKit.h>
#import "XYZToDoItem.h"

@interface XYZMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *getDirections;

@property XYZToDoItem *toDoItem;

@property (weak, nonatomic) IBOutlet MKMapView *map;

@end
