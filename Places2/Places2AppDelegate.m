//
//  Places2AppDelegate.m
//  Places2
//
//  Created by Gavin Hills on 1/2/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Places2AppDelegate.h"

#import "RootViewController.h"
#import "TopPlacesTableViewController.h"
#import "RecentPhotosTableViewController.h"
#import "FavoritePlacesTableViewController.h"

@implementation Places2AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    // create 2 table controllers for each tab
    TopPlacesTableViewController *tpc = [[TopPlacesTableViewController alloc] initInContext:self.managedObjectContext];
    tpc.tabBarItem.title = @"Popular Places";
    tpc.tabBarItem.image = [UIImage imageNamed:@"topflickrplaces.png"];
    UINavigationController *tpcNav = [[UINavigationController alloc] initWithRootViewController:tpc];
    [tpc release];
    
    RecentPhotosTableViewController *rpc = [[RecentPhotosTableViewController alloc] initInContext:self.managedObjectContext];
    rpc.title = @"Recent Photos";
    rpc.tabBarItem.title = @"Recent Photots";
    rpc.tabBarItem.image = [UIImage imageNamed:@"recentphotos.png"];
    UINavigationController *rpcNav = [[UINavigationController alloc] initWithRootViewController:rpc];
    [rpc release];
    
    FavoritePlacesTableViewController *fvc = [[FavoritePlacesTableViewController alloc] initInManagedObjectContext:self.managedObjectContext];
    fvc.title = @"Favorite Places";
    fvc.tabBarItem.title = @"Favorites";
    fvc.tabBarItem.image = [UIImage imageNamed:@"favorites.png"];
    UINavigationController *fvcNav = [[UINavigationController alloc] initWithRootViewController:fvc];
    [fvc release];
    
    /*
     RecentPicturesTableViewController *rpc = [[RecentPicturesTableViewController alloc] init];
     rpc.tabBarItem.title = @"Recent Pictures";
     rpc.tabBarItem.image = [UIImage imageNamed:@"MostViewed.jpg"];
     UINavigationController *rpcNav = [[UINavigationController alloc] initWithRootViewController:rpc];
     [rpc release];
     */
    
    /*
    PicturesTableViewController * pvc = [[PicturesTableViewController alloc] init];
    RecentPictureInfoSource * pis = [[RecentPictureInfoSource alloc] init];
    [pis autorelease];
    pvc.title = @"Recently Viewed";
    pvc.photoList = [RecentPhotoManager GetRecentlyViewedPhotos];
    pvc.tabBarItem.title = @"Recent Pictures";
    pvc.tabBarItem.image = [UIImage imageNamed:@"MostViewed.jpg"];
    pvc.photoListSource = pis;
    UINavigationController *rpcNav = [[UINavigationController alloc] initWithRootViewController:pvc];
    [pvc release];
    //[pis release];
    */
    
    // create array of views and add it to the tab controller
    //NSArray *tabsArray = [[NSArray alloc] initWithObjects:tpcNav, rpcNav, nil];
    NSArray *tabsArray = [[NSArray alloc] initWithObjects:tpcNav, rpcNav, fvcNav, nil];
    tabBarController.viewControllers = tabsArray;
    [tpcNav release];
    [rpcNav release];
    [fvcNav release];
    [tabsArray release];
    
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)dealloc
{
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [_navigationController release];
    [super dealloc];
}

- (void)awakeFromNib
{
    RootViewController *rootViewController = (RootViewController *)[self.navigationController topViewController];
    rootViewController.managedObjectContext = self.managedObjectContext;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Places2" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Places2.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
