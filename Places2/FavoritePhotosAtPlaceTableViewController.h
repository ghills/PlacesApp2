//
//  FavoritePhotosAtPlaceTableViewController.h
//  Places2
//
//  Created by Gavin Hills on 1/31/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoreDataTableViewController.h"
#import "Place.h"

@interface FavoritePhotosAtPlaceTableViewController : CoreDataTableViewController

- initWithPlace:(Place *)place;

@end
