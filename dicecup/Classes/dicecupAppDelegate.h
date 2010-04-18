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

@interface dicecupAppDelegate : NSObject <UIApplicationDelegate, GKPeerPickerControllerDelegate, GKSessionDelegate, UIAlertViewDelegate> {
    UIWindow *window;
    dicecupViewController *viewController;
    GKSession		*myGkSession;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet dicecupViewController *viewController;
@property(nonatomic, retain) GKSession	 *myGkSession;

-(void)startPicker;

@end
