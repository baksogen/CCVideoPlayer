//
//  HelloWorldLayer.m
//  CCVideoPlayer
//
//  Created by Stepan Generalov on 12.04.11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "VideoPlayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// Add button
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Play video" fontName:@"Marker Felt" fontSize:64];
		CCMenuItemLabel *labelItem = [CCMenuItemLabel itemWithLabel:label 
															 target: self 
														   selector: @selector(testVideoPlayer)];
		
		CCMenu *menu = [CCMenu menuWithItems: labelItem, nil];
		[menu alignItemsHorizontally];
		[self addChild: menu];
	
		
		// Init Video Player
		[VideoPlayer setDelegate: self];
	}
	return self;
}

- (void) testVideoPlayer
{
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
	[  self performSelectorOnMainThread: @selector(playMovieWithFile:) 
							 withObject: @"bait.mp4" 
						  waitUntilDone: NO  ];
#elif defined(__IPHONE_OS_VERSION_MAX_ALLOWED)
	[VideoPlayer playMovieWithFile: @"bait.mp4"];
#endif
}

- (void) playMovieWithFile: (NSString *) filename
{
	[VideoPlayer playMovieWithFile: filename];
}

- (void) moviePlaybackFinished
{
	[[CCDirector sharedDirector] startAnimation];
}

- (void) movieStartsPlaying
{
	[[CCDirector sharedDirector] stopAnimation];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
