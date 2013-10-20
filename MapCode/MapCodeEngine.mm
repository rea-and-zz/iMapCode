//
//  MapCode.mm
//  MapCode
//
//  Created by Andrea Carlevato on 10/19/13.
//  Copyright (c) 2013 TomTom Int. All rights reserved.
//

#import "MapCodeEngine.h"

@interface MapCodeEngine ()

@property (strong, nonatomic)  UIWebView *webView;
@property (assign, nonatomic)  bool ready;

@end

@implementation MapCodeEngine

- (id)init
{
    self = [super init];
    if (self) {
        // load required JS
        self.webView = [UIWebView new];
        self.webView.delegate = self;
        [self.webView loadHTMLString:@"<script src=\"mapcode.js\"></script>"
                             baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
        self.ready = NO;
    }
    return self;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // handle error here
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // JS has been loaded and ready to use
    self.ready = YES;
}

- (LocMapCodeSet *)decodePositionWithLat:(NSString *)lat andLon:(NSString *)lon
{
    NSString *function = [[NSString alloc] initWithFormat: @"find_bestiso(%@,%@, 0)", lat, lon];
    NSString *isoCode = [self.webView stringByEvaluatingJavaScriptFromString:function];
    
    function = [[NSString alloc] initWithFormat: @"ccode2iso(%@, false)", isoCode];
    NSString *countryCode = [self.webView stringByEvaluatingJavaScriptFromString:function];
    
    function = [[NSString alloc] initWithFormat: @"fullname(%@)", isoCode];
    NSString *fullCountryName = [self.webView stringByEvaluatingJavaScriptFromString:function];
    
    function = [[NSString alloc] initWithFormat: @"master_encode( %@, %@, %@).toString()", lat, lon, isoCode];
    NSString *resultsMapCodes = [self.webView stringByEvaluatingJavaScriptFromString:function];
    
    function = [[NSString alloc] initWithFormat: @"master_encode( %@, %@, 540).toString()", lat, lon];
    NSString *worldResult = [self.webView stringByEvaluatingJavaScriptFromString:function];
    
    
    NSArray *items = [resultsMapCodes componentsSeparatedByString: @","];
    NSMutableArray *ma = [NSMutableArray new];
    for (int i =0; i < items.count; i+=2)
    {
        MapCodeItem *mapCode = [MapCodeItem new];
        if ([((NSString *)items[i+1]) isEqualToString:isoCode])
        {
            mapCode.countryCode = countryCode;
        }
        else
        {
            function = [[NSString alloc] initWithFormat: @"ccode2iso(%@, false)", items[i+1]];
            mapCode.countryCode = [self.webView stringByEvaluatingJavaScriptFromString:function];
        }
        mapCode.mapCode = items[i];
        [ma addObject:mapCode];
    }
    
    LocMapCodeSet *encodeResult = [LocMapCodeSet new];
    encodeResult.localMapCodes = [[NSArray alloc] initWithArray:ma];
    encodeResult.coutryName = fullCountryName;
    
    items = [worldResult componentsSeparatedByString: @","];
    encodeResult.worldMapCode = items[0];

    return encodeResult;
    
    /*
    
    
    char worldResult[16] = "";
    char localResult[16] = "";
    const char *worldIso = "AAA";
    char iso_found[16];
    
    int areaCode = findAreaFor(x, y, -1);
    */
    
    
    // Fills the "parent" map code, if applicable (US, RUSSIA, etc...)
    /*
    int parentCountry = stateparent(areaCode);
    if (parentCountry >= 0)
    {
        char parentResult[16];
        const char *isoParent = entity_iso3(parentCountry);
        disambiguate(parentCountry);
        mapcode_encode(parentResult, y, x, isoParent, iso_found);
        
        result.parentCountryCode = [NSString stringWithUTF8String:isoParent];
        result.parentMapCode = [NSString stringWithUTF8String:parentResult];
    }
    else
    {
        result.parentCountryCode = @"";
        result.parentMapCode = @"";
    }
    
    // Fill the local map code
    const char *iso3 = entity_iso3(areaCode);
    result.localCountryCode = [NSString stringWithUTF8String:iso3];
    if (parentCountry >= 0)
    {
        // cleanup the country name when there is a country parent
        result.localCountryCode = [result.localCountryCode substringFromIndex:1];
    }
    mapcode_encode(localResult, y, x, iso3, iso_found);
    result.localMapCode = [NSString stringWithUTF8String:localResult];
    
    // Fill the worldwide map code
    mapcode_encode(worldResult, y, x, worldIso, iso_found);
    result.worldMapCode = [NSString stringWithUTF8String:worldResult];
    
    return result;
     
     */
}

@end
