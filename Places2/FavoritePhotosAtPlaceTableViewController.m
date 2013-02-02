//
//  FavoritePhotosAtPlaceTableViewController.m
//  Places2
//
//  Created by Gavin Hills on 1/31/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "FavoritePhotosAtPlaceTableViewController.h"
#import "PhotoViewController.h"
#import "Photo.h"

@implementation FavoritePhotosAtPlaceTableViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- initWithPlace:(Place *)place
{
    if( self = [super initWithStyle:UITableViewStylePlain])
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:place.managedObjectContext];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"favorite == YES && whereTook == %@", place];
        request.fetchBatchSize = 20;
        
        [NSFetchedResultsController deleteCacheWithName:@"FavoritePhotos"];
        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:place.managedObjectContext sectionNameKeyPath:nil cacheName:@"FavoritePhotos"];
        
        [request release];
        self.fetchedResultsController = frc;
        [frc release];
        
        self.titleKey = @"title";
        
        self.searchKey = @"title";
        
        self.title = [NSString stringWithFormat:@"Favorites at %@", place.name];
    }
    return self;
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject
{
    Photo * photo = (Photo *)managedObject;
    PhotoViewController *fvc = [[PhotoViewController alloc] initWithPhoto:photo];
    photo.lastViewed = [NSDate date];
    NSLog(@"%@",photo.lastViewed);
    [self.navigationController pushViewController:fvc animated:YES];
    [fvc release];
    
    NSError *error = nil;
    [photo.managedObjectContext save:&error];
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
    }
}

- (BOOL)canDeleteManagedObject:(NSManagedObject *)managedObject
{
    return YES;
}

- (void)deleteManagedObject:(NSManagedObject *)managedObject
{
    Photo * photo = (Photo *)managedObject;
    [photo toggleFavorite];
    
    NSError *error = nil;
    [managedObject.managedObjectContext save:&error];
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
    }
}

@end
