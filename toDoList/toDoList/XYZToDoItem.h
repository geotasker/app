//
//  XYZToDoItem.h
//  toDoList
//
//  Created by Mitchell Vollger on 3/19/14.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface XYZToDoItem : NSObject
@property NSString *itemName;
@property NSString *itemRadius;
@property NSString *itemNotes;

// whether or not there is a search result.
@property BOOL match;

// map locations
@property MKMapItem *current;
@property MKMapItem *closeMatch;

// should not be needed
@property (readonly) NSDate *creationDate;
@property bool completed;

@property NSInteger radius;

@end
