//
//  Place.h
//  Places2
//
//  Created by Gavin Hills on 1/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Place : NSManagedObject {
@private
}

+ (Place *)placeWithname:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *pictures;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addPicturesObject:(Photo *)value;
- (void)removePicturesObject:(Photo *)value;
- (void)addPictures:(NSSet *)values;
- (void)removePictures:(NSSet *)values;

@end
