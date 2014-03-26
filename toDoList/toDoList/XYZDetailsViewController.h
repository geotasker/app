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

@property (weak, nonatomic) IBOutlet UITextView *name;
@property (weak, nonatomic) IBOutlet UITextView *radius;
@property (weak, nonatomic) IBOutlet UILabel *notes;
@property (weak, nonatomic) IBOutlet UITextView *scrollNotes;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property XYZToDoItem *toDoItem;


@end
