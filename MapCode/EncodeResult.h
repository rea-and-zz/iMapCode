//
//  EncodeResult.h
//  MapCode
//
//  Created by Andrea Carlevato on 10/19/13.
//  Copyright (c) 2013 TomTom Int. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncodeResult : NSObject

@property (nonatomic, strong) NSString *localMapCode;
@property (nonatomic, strong) NSString *localCountryCode;

@property (nonatomic, strong) NSString *parentMapCode;
@property (nonatomic, strong) NSString *parentCountryCode;

@property (nonatomic, strong) NSString *worldMapCode;

@end
