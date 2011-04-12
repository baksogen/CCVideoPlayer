//
//  VideoPlayerImpliOS.m
//  iTraceur for Mac
//
//  Created by Stepan Generalov on 04.01.11.
//  Copyright 2011 Parkour Games. All rights reserved.
//

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

#import "VideoPlayerImpliOS.h"
#import "GameDirector.h"
#import "MediaPlayer/MediaPlayer.h"
#import "videoOverlayView.h"



@implementation VideoPlayerImpliOS

@synthesize isPlaying = _playing;

- (id) init
{
    if ( self = [super init] )
    {
        _theMovie = nil;
    }
    return self;
}

//----- playMovieAtURL: ------
-(void)playMovieAtURL:(NSURL*)theURL
{
	_playing = YES;
	
    [ [GameDirector sharedGameDirector] movieStartsPlaying]; //< was pause here
	
    MPMoviePlayerController* theMovie = [[MPMoviePlayerController alloc] initWithContentURL:theURL];
    if (! theMovie)
		_playing = NO;
	
    _theMovie = theMovie;    	
	
	if ([theMovie respondsToSelector:@selector(setControlStyle:)])
	{
		[ theMovie setControlStyle: MPMovieControlStyleNone ];
	}
#ifdef __IPHONE_OS_VERSION_MIN_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 30200
	else if ( [theMovie respondsToSelector:@selector(setMovieControlMode:)] )
	{
		
		[theMovie setMovieControlMode: MPMovieControlModeHidden]; 
	}
#endif
#endif
	
	
    // Register for the playback finished notification.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:theMovie];
	
	
	
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];	
	
	// iOS 4.0 video player
	if ([theMovie respondsToSelector: @selector(view)])
	{		
		[keyWindow addSubview: [theMovie view]];				
		[ [theMovie view] setHidden:  NO];		
		[ [theMovie view] setFrame: CGRectMake( 0, 0, keyWindow.frame.size.height, keyWindow.frame.size.width)];				
		[ [theMovie view] setCenter: keyWindow.center ];
        
		[self updateOrientationWithOrientation: [[UIApplication sharedApplication] statusBarOrientation]];
		
		// Movie playback is asynchronous, so this method returns immediately.
		[theMovie play];
		
		
		CGSize winSize = [ [CCDirector sharedDirector] winSize];
		
		_videoOverlayView = [ [VideoOverlayView alloc] initWithFrame:CGRectMake(0, 0, winSize.height, winSize.width)];
		
		[keyWindow addSubview: _videoOverlayView ];
	}
	else // iPhone OS 2.2.1 video player
	{
		[theMovie play];		
		
		// add videoOVerlayView
		NSArray *windows = [[UIApplication sharedApplication] windows];
		if ([windows count] > 1)
		{
			// Locate the movie player window
			UIWindow *moviePlayerWindow = [[UIApplication sharedApplication] keyWindow];
			// Add our overlay view to the movie player's subviews so it is 
			// displayed above it.
			
			CGSize winSize = [ [CCDirector sharedDirector] winSize];
			_videoOverlayView = [ [VideoOverlayView alloc] initWithFrame:CGRectMake(0, 0, winSize.height, winSize.width)];			
			[moviePlayerWindow addSubview: _videoOverlayView ];
		}
	}
}


//----- movieFinishedCallback -----
-(void)movieFinishedCallback:(NSNotification*)aNotification
{
    MPMoviePlayerController* theMovie = [aNotification object];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    
    
	
    // Release the movie instance created in playMovieAtURL:
    if ([theMovie respondsToSelector:@selector(view)])
    {
        [[theMovie view] removeFromSuperview];
    }
    [theMovie release];    
    _theMovie = nil;
	_playing = NO;
    
	[_videoOverlayView removeFromSuperview];
    [_videoOverlayView release];
	
	[ [GameDirector sharedGameDirector] movieWatchedTillTheEnd ]; 
	//<BUG: здесь должна быть проверка на _cancelled, но ее нет
	// в любом случае просмотр видео будет засчитан как полный просмотр до конца,
	// так даже лучше - будет меньше бесить игрока 
    [ [GameDirector sharedGameDirector] moviePlaybackFinished]; //< was resume here
}

- (void) cancelPlaying
{
    if (_theMovie)
        [_theMovie stop];
    
    if ( _theMovie )
    {
		
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:_theMovie];
        
        // Release the movie instance created in playMovieAtURL:
        if ([_theMovie respondsToSelector:@selector(view)])
        {
            [[_theMovie view] removeFromSuperview];
        }
        [_theMovie release];   
        _theMovie = nil;
        
		[_videoOverlayView removeFromSuperview];
        [_videoOverlayView release];
        
        [ [GameDirector sharedGameDirector] moviePlaybackFinished]; //< was resume here
    }
}

- (void) updateOrientationWithOrientation: (UIDeviceOrientation) newOrientation
{
	if (!_theMovie)
		return;
	
	if (![_theMovie respondsToSelector:@selector(view)])
		return;
	
	UIDeviceOrientation orientation = newOrientation;
	
	if (orientation == UIDeviceOrientationLandscapeRight)		
		[ [_theMovie view] setTransform: CGAffineTransformMakeRotation(-M_PI_2) ];
	
	if (orientation == UIDeviceOrientationLandscapeLeft)
		[ [_theMovie view] setTransform: CGAffineTransformMakeRotation(M_PI_2) ];
}


@end

#endif

