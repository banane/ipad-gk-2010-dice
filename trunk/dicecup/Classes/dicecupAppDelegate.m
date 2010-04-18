//
//  dicecupAppDelegate.m
//  dicecup
//
//  Created by stacie on 4/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "dicecupAppDelegate.h"
#import "dicecupViewController.h"

@implementation dicecupAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize myGkSession;
//@synthesize gameState, peerStatus, gameSession, gamePeerId, lastHeartbeatDate, connectionAlert;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
        
//	[viewController.view setBackgroundImage:[UIImage imageNamed:@"dicecup.png"]];
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
    [self startPicker];
    
	return YES;
}
-(void)startPicker {
	GKPeerPickerController*		picker;
		
	picker = [[GKPeerPickerController alloc] init]; // note: picker is released in various picker delegate methods when picker use is done.
	picker.delegate = self;
	[picker show]; // show the Peer Picker
}

//- (void)session:(GKSession *) peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type { 
//    NSLog(@"in peerPickerController");
//	GKSession*sess = [[GKSession alloc] initWithSessionID:@"DicePad" displayName:nil sessionMode:GKSessionModePeer]; 
//    sess.available = YES;
	//[sess setDataReceiveHandler:self withContext:NULL];
//}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type { 
    if (type == GKPeerPickerConnectionTypeOnline)
        NSLog(@"in peerPickerController sessionForConnectionType: ONLINE");
    else
        NSLog(@"in peerPickerController sessionForConnectionType: NEARBY");
	myGkSession = [[GKSession alloc] initWithSessionID:@"DicePad" displayName:nil sessionMode:GKSessionModePeer]; 
    //myGkSession.available = YES;
	return [myGkSession retain]; // peer picker retains a reference, so autorelease ours so we don't leak.
}

- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type {
    if(type == GKPeerPickerConnectionTypeOnline) {
        [picker dismiss];
        [picker autorelease];
        // Display your own user interface here.
    } else if (type == GKPeerPickerConnectionTypeNearby) {
        [picker dismiss];
        [picker autorelease];
    }
}


- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)sess { 
	// Remember the current peer.
	//self.gamePeerId = peerID;  // copy
	
	// Make sure we have a reference to the game session and it is set up
    NSLog(@"in peerPickerController didConnectPeer");
	myGkSession = sess; // retain
	//self.session.delegate = self; 
	//[self.session setDataReceiveHandler:self withContext:NULL];
	
	// Done with the Peer Picker so dismiss it.
	[picker dismiss];
	picker.delegate = nil;
	[picker autorelease];
	
	// Start Multiplayer game by entering a cointoss state to determine who is server/client.
	//self.gameState = kStateMultiplayerCointoss;
} 
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker { 
	// Peer Picker automatically dismisses on user cancel. No need to programmatically dismiss.
    
	// autorelease the picker. 
	picker.delegate = nil;
    [picker autorelease]; 
	
	// invalidate and release game session if one is around.
	if(myGkSession != nil)	{
		//[self invalidateSession:myGkSession];
		myGkSession = nil;
	}
	
	// go back to start mode
	//self.gameState = kStateStartGame;
} 


//- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID;

- (void)connectToPeer:(NSString *)peerID withTimeout:(NSTimeInterval)timeout{
}


- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
    NSLog(@"in conn request");
}
    
    
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
    NSLog(@"in didChangeState");
	switch (state) { 
		case GKPeerStateAvailable:
            [myGkSession connectToPeer:peerID withTimeout:10.0];
            // A peer became available by starting app, exiting settings, or ending a call.
			//if (![peerList containsObject:peerID]) {
			//	[peerList addObject:peerID]; 
			//}
 			//[lobbyDelegate peerListDidChange:self]; 
			break;
		case GKPeerStateUnavailable:
            // Peer unavailable due leaving app, or entering settings.
            //[peerList removeObject:peerID]; 
            //[lobbyDelegate peerListDidChange:self]; 
			break;
		case GKPeerStateConnected:
            // Connection was accepted
            //currentConfPeerID = [peerID retain];
            session.available = NO;
            //sessionState = ConnectionStateConnected;
			break;				
		case GKPeerStateDisconnected:
            //[peerList removeObject:peerID]; 
            //[lobbyDelegate peerListDidChange:self];
			break;
        case GKPeerStateConnecting:
            // Peer is attempting to connect to the session.
            break;
		default:
			break;
	}
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
