//
//  Place.m
//  Places2
//
//  Created by Gavin Hills on 1/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Place.h"
#import "Photo.h"


@implementation Place
@dynamic name;
@dynamic pictures;
@dynamic hasFavorite;

+ (Place *)placeWithname:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Place *place = nil;
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    request.entity = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSError *error = nil;
    place = [[context executeFetchRequest:request error:&error] lastObject];
    
    if( !error && !place )
    {
        // Create a new one because it did not find one already existing
        // but query worked because there was no error
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        place.name = name;
    }
    
    return place;
}

@end
