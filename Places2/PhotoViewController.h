//
//  FlickrPhotoViewController.h
//  Places
//
//  Created by Gavin Hills on 11/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Photo.h"

@interface PhotoViewController : UIViewController <UIScrollViewDelegate>
{
    UIImageView *imageView;
    Photo * photo;
}

- (void)favoriteButtonPressed:(id)sender;
- (void)updateButtonStyle:(UIBarButtonItem *)button;

@property (retain) Photo * photo;

@end
