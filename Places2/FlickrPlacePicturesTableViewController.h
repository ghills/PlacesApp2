//
//  FlickrPlacePicturesTableViewController.h
//  Places
//
//  Created by Gavin Hills on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPlacePicturesTableViewController : UITableViewController
{
    NSArray * photoList;
    NSString * placeName;
}

- (id)initInContext:(NSManagedObjectContext *)context;

@property (retain) NSArray * photoList;
@property (retain) NSString * placeName;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
