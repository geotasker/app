//
//  XYZToDoListViewController.h
//  toDoList
//
//  Created by Mitchell Vollger on 3/19/14.
//
//
#import "XYZDetailsViewController.h"
#import <UIKit/UIKit.h>

extern NSMutableArray *toDoItems;

@interface XYZToDoListViewController : UITableViewController


- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
