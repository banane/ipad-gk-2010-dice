//
//  dice1AppDelegate.h
//  dice1
//
//  Created by stacie hibino & anna billstrom on 4/17/10.
//  Copyright stacie & anna 2010. MIT License
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface dicePadAppDelegate : NSObject <UIApplicationDelegate, GKSessionDelegate> {
    UIWindow *window;
    UIViewController *dicePadViewController;
    int peerCount;     // # of peers connected
    UITextView *peerLabel; // see info on peerLabel
    NSString *currentPeerID;
    NSMutableArray *thePeers;
    GKSession *myGkSession;
//	UIImageView *diceImageView;
//	UIImageView *diceImageView2;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *dicePadViewController;
@property (nonatomic, retain) IBOutlet UITextView *peerLabel;
@property (nonatomic, retain) NSMutableArray *thePeers;
@property (nonatomic, retain) NSString *currentPeerID;
@property (nonatomic) int peerCount;
@property (nonatomic, retain) GKSession *myGkSession;
//@property (nonatomic, retain) IBOutlet UIImageView *diceImageView;
//@property (nonatomic, retain) IBOutlet UIImageView *diceImageView2;

-(void)animateDice:(int)di1 secondDi:(int)di2;

@end

