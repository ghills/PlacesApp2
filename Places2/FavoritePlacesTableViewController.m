//
//  FavoritePlacesTableViewController.m
//  Places2
//
//  Created by Gavin Hills on 1/31/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "FavoritePlacesTableViewController.h"
#import "FavoritePhotosAtPlaceTableViewController.h"
#import "Photo.h"

@implementation FavoritePlacesTableViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- initInManagedObjectContext:(NSManagedObjectContext *)context
{
    if( self = [super initWithStyle:UITableViewStylePlain])
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:context];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"hasFavorite == YES"];
        request.fetchBatchSize = 20;
        
        [NSFetchedResultsController deleteCacheWithName:@"FavoritePlaces"];
        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:@"FavoritePlaces"];
        
        [request release];
        self.fetchedResultsController = frc;
        [frc release];
        
        self.titleKey = @"name";
        
        self.searchKey = @"name";
        
        self.title = @"Favorite Places";
    }
    return self;
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject
{
    FavoritePhotosAtPlaceTableViewController *tvc = [[FavoritePhotosAtPlaceTableViewController alloc] initWithPlace:(Place *)managedObject];
    [self.navigationController pushViewController:tvc animated:YES];
    [tvc release];
}

- (BOOL)canDeleteManagedObject:(NSManagedObject *)managedObject
{
    return YES;
}

- (void)deleteManagedObject:(NSManagedObject *)managedObject
{
    Place * place = (Place *)managedObject;
    for (Photo * photo in place.pictures) {
        photo.favorite = [NSNumber numberWithBool:NO];
    }
    place.hasFavorite = [NSNumber numberWithBool:NO];
    
    NSError *error = nil;
    [managedObject.managedObjectContext save:&error];
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
    }
}

@end
