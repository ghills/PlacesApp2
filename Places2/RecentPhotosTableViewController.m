//
//  RecentPhotosTableViewController.m
//  Places2
//
//  Created by Gavin Hills on 1/27/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "RecentPhotosTableViewController.h"
#import "PhotoViewController.h"

@implementation RecentPhotosTableViewController

- (id)initInContext:(NSManagedObjectContext *)context
{
#define SECONDS_PER_HOUR (3600)
#define VIEWED_SINCE_INTERVAL ( -48 * SECONDS_PER_HOUR )
    
    if( self = [super initWithStyle:UITableViewStylePlain] )
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext: context];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"lastViewed" ascending:NO]];
        
        // only show recently viewed photos
        NSDate * viewedSince = [[NSDate date] dateByAddingTimeInterval:VIEWED_SINCE_INTERVAL];
        request.predicate = [NSPredicate predicateWithFormat:@"lastViewed >= %@", viewedSince];
        
        request.fetchBatchSize = 20;
        
        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        
        [request release];
        self.fetchedResultsController = frc;
        [frc release];
        
        self.titleKey = @"title";
        
        self.searchKey = @"title";
        
    }
    return self;
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject
{
    Photo * photo = (Photo *)managedObject;
    PhotoViewController *fvc = [[PhotoViewController alloc] initWithPhoto:photo];
    photo.lastViewed = [NSDate date];
    [self.navigationController pushViewController:fvc animated:YES];
    [fvc release];
    
    NSError *error = nil;
    [managedObject.managedObjectContext save:&error];
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
    photo.lastViewed = nil;
    
    NSError *error = nil;
    [managedObject.managedObjectContext save:&error];
    if(error)
    {
        NSLog(@"%@",[error localizedDescription]);
    }
}

@end
