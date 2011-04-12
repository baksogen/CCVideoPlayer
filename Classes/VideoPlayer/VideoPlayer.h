//
//  VideoPlayer.h
//  simple video player singleton
//  iTraceur iPhone 2D Game based on Cocos2D Game Engine
//
//  Created by Stepan Generalov on 3/11/09.
//  Copyright 2010 Stepan Generalov All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VideoPlayer : NSObject
{
}

+ (void) playMovieWithFile: (NSString *) file;

//+ (BOOL) isPlaying;

+ (void) cancelPlaying;

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
// update only if landscape left or landscape right
+ (void) updateOrientationWithOrientation: (UIDeviceOrientation) newOrientation;
#endif

@end
