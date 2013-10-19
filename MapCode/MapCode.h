//
//  MapCode.h
//  MapCode
//
//  Created by Andrea Carlevato on 10/19/13.
//  Copyright (c) 2013 TomTom Int. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EncodeResult.h"


@interface MapCode : NSObject

- (EncodeResult *)decodePositionWithX:(long)x andY:(long)y;

@end
