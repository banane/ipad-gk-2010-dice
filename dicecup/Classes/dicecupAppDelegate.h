//
//  dicecupAppDelegate.h
//  dicecup
//
//  Created by stacie hibino and anna billstrom on 4/17/10.
//  Copyright stacie and anna 2010. MIT License
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@class dicecupViewController;

@interface dicecupAppDelegate : NSObject <UIApplicationDelegate, GKPeerPickerControllerDelegate, GKSessionDelegate, UIAlertViewDelegate, UIAccelerometerDelegate> {
    UIWindow *window;
    GKSession		*myGkSession;
    NSMutableArray  *myPeers;
	
	UIAccelerometer *accelerometer;
	UIView *shakeView;
	BOOL shakeable;

	NSArray *diceValues;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) GKSession	 *myGkSession;
@property (nonatomic, retain) NSMutableArray *myPeers;
@property (nonatomic, retain) UIAccelerometer *accelerometer;
@property (nonatomic, retain) UIView *shakeView;
@property (nonatomic) BOOL shakeable;
@property (nonatomic, retain) NSArray *diceValues;

-(void)startPicker;
-(void)rollDice;


@end

