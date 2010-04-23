//
//  dicecupAppDelegate.h
//  dicecup
//
//  Created by stacie hibino and anna billstrom on 4/17/10.
//  Copyright stacie and anna 2010. MIT License
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <GameKit/GameKit.h>

@class dicecupViewController;

@interface dicecupAppDelegate : NSObject <UIApplicationDelegate, GKPeerPickerControllerDelegate, GKSessionDelegate, UIAlertViewDelegate, UIAccelerometerDelegate> {
    UIWindow		*window;
	UIViewController *viewController;
    GKSession		*myGkSession;
    NSMutableArray  *myPeers;
	NSString		*iPadPeerID;
	
	UIAccelerometer *accelerometer;
	BOOL shakeable;

	NSMutableArray	*diceValues;
	
	SystemSoundID mysound;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *viewController;
@property (nonatomic, retain) GKSession	 *myGkSession;
@property (nonatomic, retain) NSMutableArray *myPeers;
@property (nonatomic, retain) UIAccelerometer *accelerometer;
@property (nonatomic) BOOL	shakeable;
@property (nonatomic, retain) NSMutableArray *diceValues;
@property (nonatomic, retain) NSString *iPadPeerID;
@property (nonatomic) SystemSoundID mysound;

-(void)startPicker;
-(void)rollDice;
- (void) playSound;


@end

