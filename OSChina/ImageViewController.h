//
//  ImageViewController.h
//  OSChina
//
//  Created by sky on 15/7/1.
//  Copyright (c) 2015年 bluesky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

- (instancetype)initWithImageURL:(NSURL *)imageURL;

- (instancetype)initWithImageURL:(NSURL *)imageURL thumbnail:(UIImageView *)thumbnail;

@end
