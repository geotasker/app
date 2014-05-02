//
//  XYZAddToDoItemViewController.m
//  toDoList
//
//  Created by Mitchell Vollger on 3/19/14.


#import "XYZAddToDoItemViewController.h"
#import "findMatches.h"
@interface XYZAddToDoItemViewController ()


@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UITextView *notesField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UISwitch *locationOn;
@property (weak, nonatomic) IBOutlet UITextField *locationField;

@property (weak, nonatomic) IBOutlet UITextView *notesBox;

@end


@implementation XYZAddToDoItemViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.doneButton) return;
    
    if (self.textField.text.length > 0) {
        
        self.toDoItem = [[XYZToDoItem alloc] init];
        self.toDoItem.itemName = self.textField.text;
        self.toDoItem.completed = NO;
        self.toDoItem.hasLocation = self.locationOn.isOn;

        self.toDoItem.matches = [[NSMutableArray alloc] init];

        if (self.notesBox.text.length > 0) {
            self.toDoItem.itemNotes = self.notesBox.text;
        }
        else {
            self.toDoItem.itemNotes = @"";
        }
        if (self.locationField.text.length > 0){
            self.toDoItem.itemLocation = self.locationField.text;
        }
        else {
            (self.toDoItem.itemLocation = nil);
        }
        
    }
}


// the following methods are for the scroll wheel
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return 6;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"textFieldShouldEndEditing");
    textView.backgroundColor = [UIColor clearColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"textFieldDidEndEditing");
    self.toDoItem.itemNotes = self.notesBox.text;
    
}

- (void)textViewDidChange:(UITextView *) textView {
    
    NSLog(@"viewDidChange");
    
    CGRect line = [self.notesBox caretRectForPosition:
                   self.notesBox.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
    - ( self.notesBox.contentOffset.y + self.notesBox.bounds.size.height
       - self.notesBox.contentInset.bottom - self.notesBox.contentInset.top );
    if ( overflow > 0 ) {
        NSLog(@"got to overflow");
        // Scroll caret to visible area
        CGPoint offset = self.notesBox.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [self.notesBox setContentOffset:offset];
        }];
    }
    
    [self.notesBox sizeToFit];
    
}

-(void)dismissKeyboard {
    NSLog(@"dismissKeyboard");
    [self.textField resignFirstResponder];
    [self.notesBox resignFirstResponder];
}


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
    
    self.notesBox.clipsToBounds = YES;
    self.notesBox.layer.cornerRadius = 5.0f;
    
    self.locationOn.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [self.locationOn setOnTintColor:[UIColor midnightBlueColor]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
