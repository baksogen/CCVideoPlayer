//
//  HelloWorldLayer.h
//  CCVideoPlayer
//
//  Created by Stepan Generalov on 12.04.11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "VideoPlayer.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <VideoPlayerDelegate>
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
