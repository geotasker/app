//
//  XYZToDoItem.h
//  toDoList
//
//  Created by Mitchell Vollger on 3/19/14.
//
//

#import <Foundation/Foundation.h>

@interface XYZToDoItem : NSObject

@property NSString *itemName;
@property NSString *itemRadius;
@property NSString *itemNotes;
@property BOOL completed;
@property (readonly) NSDate *creationDate;


@end
