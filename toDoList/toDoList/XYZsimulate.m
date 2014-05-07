//
//  XYZsimulate.m
//  toDoList
//
//  Created by Mitchell Vollger on 5/6/14.
//
//

#import "XYZsimulate.h"
#include <unistd.h>

bool driving = nil;

@implementation XYZsimulate


+(void)change: (NSMutableArray*) items
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(queue, ^{
        
        for(CLLocation* item in items){
            currentLoc = item;
            [findMatches find:item];
            //NSLog(@"%@", item.description);
            sleep(8);
        }
        
    });
}


+(void) changeLocations{
    
    driving = false;
    
    NSLog(@"changing location");
    NSMutableArray *x = [[NSMutableArray alloc] init];
    
    [x addObject:([[CLLocation alloc] initWithLatitude:40.75921100 longitude:-73.98463800])];
    [x addObject:([[CLLocation alloc] initWithLatitude:40.7570676 longitude:-73.9808909])];
    [x addObject:([[CLLocation alloc] initWithLatitude:40.7534991 longitude:-73.983076])];
    [x addObject:([[CLLocation alloc] initWithLatitude:40.750422 longitude:-73.983076])];
    [x addObject:([[CLLocation alloc] initWithLatitude:40.7521125 longitude:-73.9875821])];
    [x addObject:([[CLLocation alloc] initWithLatitude:40.7541281 longitude:-73.9921741])];
    [x addObject:([[CLLocation alloc] initWithLatitude:40.7597376 longitude:-73.9879297])];
    [x addObject:([[CLLocation alloc] initWithLatitude:40.7636057 longitude:-73.9853548])];
    [x addObject:([[CLLocation alloc] initWithLatitude:40.7676854 longitude:-73.9822029])];
    //XYZAppDelegate *appDelegate = (XYZAppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSLog(@"%@", x.description);
    
    [XYZsimulate change:x];

}









@end
