//
//  ResultViewController.h
//  MapCode
//
//  Created by Andrea Carlevato on 10/19/13.
//  Copyright (c) 2013 TomTom Int. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ResultViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation *inputLocation;

@end
