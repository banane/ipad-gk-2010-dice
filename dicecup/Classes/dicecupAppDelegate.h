//
//  dicecupAppDelegate.h
//  dicecup
//
//  Created by stacie on 4/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
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

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) GKSession	 *myGkSession;
@property (nonatomic, retain) NSMutableArray *myPeers;
@property (nonatomic, retain) UIAccelerometer *accelerometer;
@property (nonatomic, retain) UIView *shakeView;

-(void)startPicker;

@end

