//
//  LocMapCodeSet.h
//  MapCode
//
//  Created by Andrea Carlevato on 10/19/13.
//  Copyright (c) 2013 TomTom Int. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapCodeItem.h"

@interface LocMapCodeSet : NSObject

@property (nonatomic, strong) NSArray *localMapCodes;
@property (nonatomic, strong) NSString *worldMapCode;
@property (nonatomic, strong) NSString *coutryName;

@end
