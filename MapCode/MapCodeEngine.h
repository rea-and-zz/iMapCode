//
//  MapCodeEngine.h
//  MapCodeEngine
//
//  Created by Andrea Carlevato on 10/19/13.
//  Copyright (c) 2013 TomTom Int. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocMapCodeSet.h"


@interface MapCodeEngine : NSObject <UIWebViewDelegate>


//- (void) initJS:(UIWebView *)webView;
- (LocMapCodeSet *)decodePositionWithLat:(NSString *)lat andLon:(NSString *)lon;

@end
