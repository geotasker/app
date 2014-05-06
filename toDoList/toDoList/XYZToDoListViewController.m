//
//  XYZToDoListViewController.m
//  toDoList
//
//  Created by Mitchell Vollger on 3/19/14.
//
//

#import "XYZToDoListViewController.h"
#import "XYZToDoItem.h"
#import "XYZAddToDoItemViewController.h"
#import "XYZDetailsViewController.h"
#import "XYZAppDelegate.h"
#import "findMatches.h"

@interface XYZToDoListViewController ()

@end

NSMutableArray *toDoItems = nil;

@implementation XYZToDoListViewController

+(void)rtnToDoItems{
    NSLog(@"%@", toDoItems.description);
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    XYZAddToDoItemViewController *source = [segue sourceViewController];
    XYZToDoItem *item = source.toDoItem;
    // Make query after item is added
    if (item != nil) {
        [toDoItems addObject:item];
        [self.tableView reloadData];
        [findMatches find:currentLoc];
    }
    //NSLog(@"%@", item.itemLocation);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"List";
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor darkGrey]];
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor headingColor]};
    [self.navigationController.navigationBar setTintColor:[UIColor headingColor]];
    
    //set the separator color
    self.tableView.separatorColor = [UIColor headingColor];
    
    //Set the background color
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = nil;
    
    toDoItems = [[NSMutableArray alloc] init];
    
    //[self loadInitialData];
    
    //cancel outstanding notifications when the user sees all the to do items
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

}

/*- (void)loadInitialData {
    
    XYZToDoItem *item1 = [[XYZToDoItem alloc] init];
    item1.matches = [[NSMutableArray alloc] init];
    item1.itemName = @"starbucks";
    item1.itemNotes = @"This is a preloaded item to show that it is possible, this may or may not be a final feature.";
    item1.hasLocation = true;
    [toDoItems addObject:item1];
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [toDoItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ListPrototypeCell";
    // UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UITableViewCell *cell = [UITableViewCell configureFlatCellWithColor:[UIColor concreteColor] selectedColor:[UIColor blackColor] reuseIdentifier:CellIdentifier inTableView:(UITableView *)tableView];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.cornerRadius = 5.f; //Optional
        if (self.tableView.style == UITableViewStyleGrouped) {
            cell.separatorHeight = 2.f; //Optional
        }
        else {
            cell.separatorHeight = 0.5;
        }
    }
    
    XYZToDoItem *toDoItem = [toDoItems objectAtIndex:indexPath.row];
    cell.textLabel.text = toDoItem.itemName;
    
    /*
    cell.accessoryType = UITableViewCellAccessoryDetailButton;

    if (toDoItem.completed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    */
    return cell;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYZToDoItem * current = [toDoItems objectAtIndex:indexPath.row];
    if(current.match) {
        [cell configureFlatCellWithColor:[UIColor accentColor] selectedColor:[UIColor whiteColor]];
    }
    else {
        [cell configureFlatCellWithColor:[UIColor deselectedColor] selectedColor:[UIColor darkGrey]];
    }

}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [toDoItems removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue.identifier isEqualToString:@"showDetail"] ) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        XYZDetailsViewController *destViewController = segue.destinationViewController;
        destViewController.toDoItem = [toDoItems objectAtIndex:indexPath.row];
    }
    
    if ( [segue.identifier isEqualToString:@"oneAlertShow"] ) {
        XYZDetailsViewController *destViewController = segue.destinationViewController;
        destViewController.toDoItem = oneAlert;
    }

}

+ (void) alertSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [segue.identifier isEqualToString:@"oneAlertShow"] ) {
        XYZDetailsViewController *destViewController = segue.destinationViewController;
        destViewController.toDoItem = oneAlert;
    }
}



@end
