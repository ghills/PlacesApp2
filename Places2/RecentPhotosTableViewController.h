//
//  RecentPhotosTableViewController.h
//  Places2
//
//  Created by Gavin Hills on 1/27/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoreDataTableViewController.h"

@interface RecentPhotosTableViewController : CoreDataTableViewController

- (id)initInContext:(NSManagedObjectContext *)context;

@end
