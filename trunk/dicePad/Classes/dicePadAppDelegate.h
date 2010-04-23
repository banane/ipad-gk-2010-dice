//
//  dice1AppDelegate.h
//  dice1
//
//  Created by stacie on 4/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@class dicePadViewController;

@interface dicePadAppDelegate : NSObject <UIApplicationDelegate, GKSessionDelegate> {
    UIWindow *window;
    dicePadViewController *viewController;
    int peerCount;     // # of peers connected
    UILabel *peerLabel; // see info on peerLabel
    NSString *currentPeerID;
    NSMutableArray *thePeers;
    GKSession *myGkSession;
	UIImageView *diceImageView;
	UIImageView *diceImageView2;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet dicePadViewController *viewController;
@property (nonatomic, retain) IBOutlet UILabel *peerLabel;
@property (nonatomic, retain) NSMutableArray *thePeers;
@property (nonatomic, retain) NSString *currentPeerID;
@property (nonatomic) int peerCount;
@property (nonatomic, retain) GKSession *myGkSession;
@property (nonatomic, retain) IBOutlet UIImageView *diceImageView;

-(void)animateDice:(int)di1 secondDi:(int)di2;

@end

