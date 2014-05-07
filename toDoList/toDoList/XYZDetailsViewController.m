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
#import "FUISwitch.h"

@interface XYZDetailsViewController ()

@end

@implementation XYZDetailsViewController

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@synthesize name1;
@synthesize locationSwitch;
@synthesize scrollView;
@synthesize notesBox;
@synthesize toDoItem;
@synthesize closeMatchFeild;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"init");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{   // Initialization

    //[super viewDidLoad];
    
    name1.delegate = self;
    [self.view addSubview:name1];
    
    notesBox.delegate = self;
    [self.view addSubview:notesBox];
      
      [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor darkGrey]];
      
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor headingColor]};
      
      [self.navigationController.navigationBar setTintColor:[UIColor headingColor]];
      
    locationSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [locationSwitch setOnTintColor:[UIColor accentColor]];
    [locationSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    // Do any additional setup after loading the view from its nib.
    self.name1.text = toDoItem.itemName;
    self.locationSwitch.on = toDoItem.hasLocation;
    self.notesBox.text = toDoItem.itemNotes;
    
    self.name1.clipsToBounds = YES;
    self.name1.layer.cornerRadius = 5.0f;
    self.name1.layer.borderColor = [[UIColor midnightBlueColor] CGColor];
    self.name1.layer.borderWidth = 0.1;
    
    self.notesBox.clipsToBounds = YES;
    self.notesBox.layer.cornerRadius = 5.0f;
    self.notesBox.layer.borderColor = [[UIColor midnightBlueColor] CGColor];
    self.notesBox.layer.borderWidth = 0.1;
    
   // [self.notesBox setTextContainerInset:UIEdgeInsetsMake(4,4,4,4)];
    
    CGSize sizeThatFitsTextView = [notesBox sizeThatFits:CGSizeMake(notesBox.frame.size.width, MAXFLOAT)];
    _TextViewHeightConstraint.constant = ceilf(sizeThatFitsTextView.height);
  
    
    if(toDoItem.closeMatch != nil){
       //   NSString *str = [NSString stringWithFormat: @"Closest match found at: %@", toDoItem.closeMatch.name];
        //_closeMatchFeild.text = toDoItem.closeMatch.name;
          
          // Getting the address
          CLPlacemark *placemark = toDoItem.closeMatch.placemark;
          closeMatchFeild.text = [NSString stringWithFormat:@"%@\n%@ %@\n%@, %@",
                                   placemark.name, placemark.subThoroughfare, placemark.thoroughfare,
                                   placemark.locality, placemark.administrativeArea];
    }
      
      
    else {
        NSString *str = [NSString stringWithFormat: @"None found."];
        closeMatchFeild.text = str;
    }
      
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// dismiss keyboard
-(void)dismissKeyboard {
    NSLog(@"dismissKeyboard");
    [name1 resignFirstResponder];
    [notesBox resignFirstResponder];
}


// UITextField Stuff
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
   textField.backgroundColor = [UIColor cloudsColor];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    textField.backgroundColor = [UIColor clearColor];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");
    textField.backgroundColor = [UIColor clearColor];
      
      [textField resignFirstResponder];
    
    if(![toDoItem.itemName isEqualToString:self.name1.text]){
        [findMatches find];
    }
    
    toDoItem.itemName = self.name1.text;
}

// make notes part fixed view with scrolling

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    [textField resignFirstResponder];
    return YES;
}

// UITextView stuff

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"textFieldShouldBeginEditing");
    textView.backgroundColor = [UIColor cloudsColor];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"textFieldDidBeginEditing");
    
    textView.backgroundColor = [UIColor cloudsColor];
    
    CGRect textFieldRect = [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0){
        
        heightFraction = 0.0;
        
    }else if(heightFraction > 1.0){
        
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        
    }else{
        
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction * 1.9);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}

//- (void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated
//{
//    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
//    rect.size.height += textView.textContainerInset.bottom;
//    [textView scrollRectToVisible:rect animated:animated];
//}


- (void)textViewDidChange:(UITextView *) textView {
    
    NSLog(@"viewDidChange");
    
//    CGRect frame = notesBox.frame;
//    frame.size.height = notesBox.contentSize.height+14;
//    notesBox.frame = frame;

    CGRect line = [notesBox caretRectForPosition:
                   notesBox.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
    - ( notesBox.contentOffset.y + notesBox.bounds.size.height
       - notesBox.contentInset.bottom - notesBox.contentInset.top );
    if ( overflow > 0 ) {
        NSLog(@"got to overflow");
        // Scroll caret to visible area
        CGPoint offset = notesBox.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [notesBox setContentOffset:offset];
        }];
    }
    
    //[notesBox sizeToFit];
    
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"textFieldShouldEndEditing");
    textView.backgroundColor = [UIColor clearColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"textFieldDidEndEditing");
    toDoItem.itemNotes = self.notesBox.text;
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

// Location switch stuff
-(IBAction)switchAction:(id)sender{
    NSLog(@"locationSwitch");
    
    if(locationSwitch.on) {
        toDoItem.hasLocation = true;
        [findMatches find];
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
