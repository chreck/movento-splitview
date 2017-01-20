//
//  TiUIiOSSplitWindow+Extend.m
//  movento-splitwindow
//
//  Created by Christoph Eck on 17.11.16.
//
//

#import "TiUIiOSSplitWindow+Extend.h"
#import "TiUtils.h"
#import <objc/runtime.h>

@implementation TiUIiOSSplitWindow (Extend)

-(void)initWrappers
{
    if (!viewsInitialized) {
        masterViewWrapper = [[UIView alloc] initWithFrame:[self bounds]];
        detailViewWrapper = [[UIView alloc] initWithFrame:[self bounds]];
        [self addSubview:detailViewWrapper];
        [self addSubview:masterViewWrapper];
        [self setClipsToBounds:YES];
        if (masterProxy != nil) {
            [self initProxy:masterProxy withWrapper:masterViewWrapper];
        }
        if (detailProxy != nil) {
            [self initProxy:detailProxy withWrapper:detailViewWrapper];
        }
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if ([TiUtils isIOS8OrGreater] && UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
            screenSize = CGSizeMake(screenSize.height, screenSize.width);
        }
        
        CGFloat masterWidth = screenSize.height - screenSize.width;
        if(splitRatioPortrait == 0) {
            splitRatioPortrait = masterWidth / screenSize.width;
            if (splitRatioPortrait <= 0) {
                splitRatioPortrait = 0.0;
            } else if (splitRatioPortrait > 1.0) {
                splitRatioPortrait = 1.0;
            }
            [self.proxy replaceValue:NUMFLOAT(splitRatioPortrait) forKey:@"portraitSplit" notification:NO];
        }
        
        if (splitRatioLandscape == 0) {
            splitRatioLandscape = masterWidth / screenSize.height;
            
            if (splitRatioLandscape <= 0) {
                splitRatioLandscape = 0.0;
            } else if (splitRatioLandscape > 1.0) {
                splitRatioLandscape = 1.0;
            }
            [self.proxy replaceValue:NUMFLOAT(splitRatioLandscape) forKey:@"landscapeSplit" notification:NO];
        }
        viewsInitialized = YES;
    }
}

-(void)setPortraitSplit_:(id)args
{
    ENSURE_SINGLE_ARG(args, NSNumber);
    CGFloat newValue = [TiUtils floatValue:args def:-1];
    
    if ( (newValue >= 0.0) && (newValue <=1.0) && newValue != splitRatioPortrait) {
        splitRatioPortrait = newValue;
        UIInterfaceOrientation curOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (viewsInitialized && UIInterfaceOrientationIsPortrait(curOrientation)) {
            [self layoutSubviewsForOrientation:curOrientation];
        }
    } else {
        [self.proxy replaceValue:NUMFLOAT(splitRatioPortrait) forKey:@"portraitSplit" notification:NO];
    }
}

-(void)setLandscapeSplit_:(id)args
{
    ENSURE_SINGLE_ARG(args, NSNumber);
    CGFloat newValue = [TiUtils floatValue:args def:-1];
    
    if ( (newValue >= 0.0) && (newValue <=1.0) && newValue != splitRatioLandscape) {
        splitRatioLandscape = newValue;
        UIInterfaceOrientation curOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (viewsInitialized && UIInterfaceOrientationIsLandscape(curOrientation)) {
            [self layoutSubviewsForOrientation:curOrientation];
        }
    } else {
        [self.proxy replaceValue:NUMFLOAT(splitRatioLandscape) forKey:@"landscapeSplit" notification:NO];
    }
}

@end
