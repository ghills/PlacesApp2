//
//  Picture.m
//  Places2
//
//  Created by Gavin Hills on 1/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Photo.h"

#import "FlickrFetcher.h"
#import "Place.h"

@interface Photo()
+ (NSData *)getPhotoDataFromFileSystemById:(NSNumber *)flickrId;
+ (NSData *)getPhotoDataFromWebAtUrl:(NSString *)url;
@end

@implementation Photo
@dynamic title;
@dynamic summary;
@dynamic url;
@dynamic flickrId;
@dynamic lastViewed;
@dynamic favorite;
@dynamic whereTook;

+ (Photo *)photoWithFlickrData:(NSDictionary *)flickrData inManagedObjectContext:(NSManagedObjectContext *)context atLocationNamed:(NSString *)place
{
    Photo *picture = nil;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request autorelease];
    request.entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"flickrId = %@", [flickrData objectForKey:@"id"]];
    NSError *error = nil;
    picture = [[context executeFetchRequest:request error:&error] lastObject];
    
    if( !error && !picture )
    {
        // Create a new one because it did not find one already existing
        // but query worked because there was no error
        picture = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        picture.flickrId = [flickrData objectForKey:@"id"];
        picture.title = [flickrData objectForKey:@"title"];
        picture.url = [FlickrFetcher urlStringForPhotoWithFlickrInfo:flickrData format:FlickrFetcherPhotoFormatLarge];
        picture.whereTook = [Place placeWithname:place inManagedObjectContext:context];
    }
    
    return picture;
}

- (void)toggleFavorite
{
    Place * place = (Place *)self.whereTook;
    
    NSFileManager * fm = [[[NSFileManager alloc] init] autorelease];
    NSString * filePath = [NSString pathWithComponents:[NSArray arrayWithObjects:NSTemporaryDirectory(), self.flickrId, nil]];
    
    if( [self.favorite boolValue] )
    {
        self.favorite = [NSNumber numberWithBool:NO];
        Boolean hasfav = NO;
        
        for(Photo * p in place.pictures )
        {
            hasfav = hasfav || [p.favorite boolValue];
        }
        place.hasFavorite = [NSNumber numberWithBool:hasfav];
        
        // no longer fav, delete from fs if file exists
        if( [fm fileExistsAtPath:filePath] )
        {
            NSError * error = nil;
            [fm removeItemAtPath:filePath error:&error];
            if( error )
            {
                NSLog( @"%@", [error localizedDescription] );
            }
        }
    }
    else
    {
        self.favorite = [NSNumber numberWithBool:YES];
        place.hasFavorite = [NSNumber numberWithBool:YES];
        
        BOOL success;
        success = [fm createFileAtPath:filePath contents:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.url]] attributes:nil];
        if(success == NO)
        {
            NSLog(@"ERROR: Failed to create image cache file");
        }
    }
}

+ (NSData *)getPhotoDataFromFileSystemById:(NSNumber *)flickrId
{
    NSData * imageData = nil;
    
    NSFileManager * fm = [[[NSFileManager alloc] init] autorelease];
    NSString * filePath = [NSString pathWithComponents:[NSArray arrayWithObjects:NSTemporaryDirectory(), flickrId, nil]];
    
    if( [fm fileExistsAtPath:filePath] )
    {
        imageData = [NSData dataWithContentsOfFile:filePath];
    }
    
    return imageData;
}

+ (NSData *)getPhotoDataFromWebAtUrl:(NSString *)url
{
    return [FlickrFetcher imageDataForPhotoWithURLString:url];
}

- (void)processImageDataWithBlock:(void (^)(NSData * imageData))processImage
{
    NSString * url = self.url;
    NSNumber * flickrID = self.flickrId;
    dispatch_queue_t callingQueue = dispatch_get_current_queue();
    dispatch_queue_t downloadQueue = dispatch_queue_create("Picture data downloader in Photo", NULL);
    dispatch_async(downloadQueue, ^{
        NSData * imageData = [Photo getPhotoDataFromFileSystemById:flickrID];
        if( !imageData )
        {
            //not found in cache, grab from flickr instead
            imageData = [Photo getPhotoDataFromWebAtUrl:url];
        }
        dispatch_async(callingQueue, ^{
            processImage(imageData);
        });
    });
    dispatch_release(downloadQueue);
}

@end
