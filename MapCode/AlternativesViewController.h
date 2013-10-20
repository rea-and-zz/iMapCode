//
//  AlternativesViewController.h
//  MapCode
//
//  Created by Andrea Carlevato on 10/20/13.
//  Copyright (c) 2013 TomTom Int. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocMapCodeSet.h"

@interface AlternativesViewController : UIViewController

@property (strong, nonatomic) LocMapCodeSet *encodeResults;
@property (assign, nonatomic) BOOL showWorldWide;

@end
