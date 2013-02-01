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
    if( self = [super initWithStyle:UITableViewStylePlain] )
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext: context];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"lastViewed" ascending:NO]];
        request.fetchLimit = 20;
        request.fetchBatchSize = 20; // how many to do?
        
        NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        
        [request release];
        self.fetchedResultsController = frc;
        [frc release];
        
        self.titleKey = @"title";
        
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

@end
