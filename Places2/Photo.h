//
//  Picture.h
//  Places2
//
//  Created by Gavin Hills on 1/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject {
@private
}

+ (Photo *)photoWithFlickrData:(NSDictionary *)flickrData inManagedObjectContext:(NSManagedObjectContext *)context atLocationNamed:(NSString *)place;

- (void)toggleFavorite;

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * flickrId;
@property (nonatomic, retain) NSDate * lastViewed;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSManagedObject *whereTook;

@end
