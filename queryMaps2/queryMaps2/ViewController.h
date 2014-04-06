//
//  ViewController.h
//  queryMaps2
//
//  Created by Shreya Nathan on 4/5/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (nonatomic, strong) NSArray *locResults;
@property (weak, nonatomic) IBOutlet UIButton *myButton;

@end
