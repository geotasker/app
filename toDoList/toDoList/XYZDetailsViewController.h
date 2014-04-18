//
//  XYZDetailsViewController.h
//  toDoList
//
//  Created by Mitchell Vollger on 3/20/14.
//
//

#import <UIKit/UIKit.h>
#import "XYZToDoItem.h"

@interface XYZDetailsViewController : UIViewController <UITextFieldDelegate>
// Alerts **
{
    IBOutlet UIAlertView *alert;
}
- (IBAction)alertbutton;

- (IBAction)localalertbutton:(id)sender;
// end allerta**

@property (weak, nonatomic) IBOutlet UITextField *name1;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;

- (IBAction)switchAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *notesBox;

// not in use
@property (weak, nonatomic) IBOutlet UITextView *radius;
@property (weak, nonatomic) IBOutlet UILabel *notes;
@property XYZToDoItem *toDoItem;





@end
