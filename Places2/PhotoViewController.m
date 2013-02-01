//
//  FlickrPhotoViewController.m
//  Places
//
//  Created by Gavin Hills on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@implementation PhotoViewController

@synthesize photo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPhoto:(Photo *)photo
{
    self = [super init];
    if (self) {
        self.photo = photo;
        
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    NSFileManager * fm = [[NSFileManager alloc] init];
    NSLog(@"flickrId: %@",self.photo.flickrId);

    NSString * filePath = [NSString pathWithComponents:[NSArray arrayWithObjects:NSTemporaryDirectory(), self.photo.flickrId, nil]];
    
    NSData * photoData = nil;
    if( [fm fileExistsAtPath:filePath] )
    {
        // use data cached in fs
        photoData = [NSData dataWithContentsOfFile:filePath];
        
        NSLog(@"Using cached data");
        
        if( !self.photo.favorite )
        {
            NSLog(@"WARNING: a non-favorited photo is cached in the filesystem.");
        }
    }
    else
    {
        // pull data down from url
        photoData = [FlickrFetcher imageDataForPhotoWithURLString:self.photo.url];
        
        NSLog(@"Getting new data");
    }
    
    UIImage *image = [UIImage imageWithData:photoData];
    UIImageView *iView = [[UIImageView alloc] initWithImage:image];
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame]; /* foo? */
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:applicationFrame];
    scrollView.contentSize = image.size;
    scrollView.minimumZoomScale = 0.3;
    scrollView.maximumZoomScale = 5.0;
    scrollView.delegate = self;
    
    [scrollView addSubview:iView];
    self.view = scrollView;
    [scrollView release];
    imageView = iView;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.title = self.photo.title;
    if( self.title.length == 0 )
    {
        self.title = @"Unknown";
    }
    
    
    //UIBarButtonItem *favoriteButton = [[UIBarButtonItem alloc] initWithTitle:@"Favorite" style:UIBarButtonItemStylePlain target:self action:@selector(favoriteButtonPressed:)];
    UIImage *btnImage = [UIImage imageNamed:@"unselected.png"];
    UIBarButtonItem *favoriteButton = [[UIBarButtonItem alloc] initWithImage:btnImage style:UIBarButtonItemStylePlain target:self action:@selector(favoriteButtonPressed:)];
    [self updateButtonStyle:favoriteButton];
    self.navigationItem.rightBarButtonItem = favoriteButton;
    [favoriteButton release];
}

- (void)favoriteButtonPressed:(id)sender
{
    [self.photo toggleFavorite];
    
    NSError * error = nil;
    [self.photo.managedObjectContext save:&error];
    if( error )
    {
        NSLog(@"%@",[error localizedDescription]);
    }
    
    [self updateButtonStyle:self.navigationItem.rightBarButtonItem];
}

- (void)updateButtonStyle:(UIBarButtonItem *)button
{
    UIImage *btnImage = nil;
    if( [self.photo.favorite boolValue] )
    {
        //button.style = UIBarButtonItemStyleDone;
        //button.title = @"Unfavorite";
        btnImage = [UIImage imageNamed:@"selected.png"];
    }
    else
    {
        //button.style = UIBarButtonItemStyleBordered;
        //button.title = @"Favorite";
        btnImage = [UIImage imageNamed:@"unselected.png"];
    }
    button.image = btnImage;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    
    CGRect bounds = self.view.bounds;
    CGSize imageSize = imageView.image.size;
    
    CGFloat xRatio = ( bounds.size.width / imageSize.width );
    CGFloat yRatio = ( bounds.size.height / imageSize.height );
    CGFloat zoomScale = MAX(xRatio, yRatio);
    
    UIScrollView * scrollView = (UIScrollView *)self.view;
    [scrollView setZoomScale:zoomScale animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)dealloc
{
    [photo release];
    [imageView release];
    [super dealloc];
}

@end
