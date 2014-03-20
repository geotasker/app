//
//  XYZDetailsViewController.h
//  toDoList
//
//  Created by Mitchell Vollger on 3/20/14.
//
//

#import <UIKit/UIKit.h>
#import "XYZToDoItem.h"

@interface XYZDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *radius;
@property (weak, nonatomic) IBOutlet UILabel *notes;

@property XYZToDoItem *toDoItem;


@end
