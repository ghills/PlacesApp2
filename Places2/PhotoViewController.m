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
    UIImageView *iView = [[UIImageView alloc] init];
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame]; /* foo? */
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:applicationFrame];
    scrollView.minimumZoomScale = 0.3;
    scrollView.maximumZoomScale = 5.0;
    scrollView.delegate = self;
    
    [scrollView addSubview:iView];
    self.view = scrollView;
    [scrollView release];
    imageView = iView;
    
    [self.photo processImageDataWithBlock:^(NSData *imageData) {
        UIImage *image = [UIImage imageWithData:imageData];
        imageView.image = image;
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        scrollView.contentSize = image.size;
    }];
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
