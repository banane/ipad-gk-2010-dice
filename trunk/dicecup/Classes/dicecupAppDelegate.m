//
//  dicecupAppDelegate.m
//  dicecup
//
//  Created by stacie on 4/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "dicecupAppDelegate.h"

@implementation dicecupAppDelegate

@synthesize window;
@synthesize myGkSession;
@synthesize myPeers;
@synthesize shakeView;
@synthesize accelerometer;

- (void) testingDice{
//		we'll put this in the senddata (or similar method), but until then testing the array.

	int d1 = [self randDiceInt];
	int d2 = [self randDiceInt];
	NSArray *diceValues = [[NSArray alloc] initWithObjects: [NSNumber numberWithInt:d1], [NSNumber numberWithInt:d2], nil];
	NSLog(@"these are the dice values: %@", diceValues);
	
}

- (int)randDiceInt{
	// put in more secure randomizer if you want
	int diceInt = random() % 7;
	NSLog(@"the random #: %d", diceInt);
	return diceInt;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    	
	[self testingDice];
	
	UIImageView *dicecupImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dicecup.png"]];
	[window addSubview:dicecupImageView];
    [window makeKeyAndVisible];
	
	//Configure and start accelerometer
	self.accelerometer = [UIAccelerometer sharedAccelerometer];
	self.accelerometer.updateInterval = .1;
	self.accelerometer.delegate = self;
	
	[dicecupImageView release];	
    
    [self startPicker];
	return YES;
}
- (void)applicationWillTerminate:(UIApplication *)application {
	if (myGkSession) {
		[myGkSession disconnectFromAllPeers];
		myGkSession.available = NO;
		[myGkSession setDataReceiveHandler: nil withContext: nil];
		myGkSession.delegate = nil;
		[myGkSession release];
	}
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
//	if ((acceleration.x > 1) || (acceleration.y > 1) || (acceleration.z > 1)){
		//this was sent with some force- a dice throw
//		[self startPicker];		
	//}
}

-(void)startPicker {
	GKPeerPickerController *picker = [[GKPeerPickerController alloc] init]; // note: picker is released in various picker delegate methods when picker use is done.
    //picker.GKPeerPickerConnectionType = GKPeerPickerConnectionTypeOnline;
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

    // peer picker retains a reference, so autorelease ours so we don't leak.
	//GKSession *sess = [[[GKSession alloc] initWithSessionID:@"DicePad" displayName:nil sessionMode:GKSessionModePeer] autorelease]; 
	GKSession *sess = [[GKSession alloc] initWithSessionID:@"DicePad" displayName:nil sessionMode:GKSessionModePeer]; 
    sess.delegate = self;
    [sess setDataReceiveHandler:self withContext:nil];
	return sess; 
}

// do we need this?
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
	// why are we creating a peer Array in the client? thought this would be a server thing.
//	[myPeers addObject:peerID];
    
	// Done with the Peer Picker so dismiss it.
	[picker dismiss];
	picker.delegate = nil;
	[picker autorelease];

	// Make sure we have a reference to the game session and it is set up
    NSLog(@"in peerPickerController didConnectPeer");
	//myGkSession = sess; // retain
    //myGkSession.delegate = self;

    
    //NSError *error = nil;
	// try sending a packet on connection:
    //NSLog(@"TRYING TO SEND DATA.....");
	//static unsigned char networkPacket[1024];
	//const unsigned int packetHeaderSize = 2 * sizeof(int); // we have two "ints" for our header	
    //int *pIntData = (int *)&networkPacket[0];
    //int length = sizeof(int);
    //int data = 5;
    //// header info
    //pIntData[0] = 1;    // packet #
    //pIntData[1] = 1;    //packetID;
    //// copy data in after the header
    //memcpy( &networkPacket[packetHeaderSize], &data, length ); 
    //NSData *packet = [NSData dataWithBytes: networkPacket length: (length+8)];
  	//[myGkSession sendData:packet toPeers:myPeers withDataMode:GKSendDataReliable error:&error];
        
    
	//self.session.delegate = self; 
	//[self.session setDataReceiveHandler:self withContext:NULL];
	
	
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


- (void)connectToPeer:(NSString *)peerID withTimeout:(NSTimeInterval)timeout{
}


- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
    NSLog(@"in conn request");
}

/* Indicates a connection error occurred with a peer, which includes connection request failures, or disconnects due to timeouts.
 */
- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
	UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"session connectionWithPeerFailed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[a show];
	[a release];
}

/* Indicates an error occurred with the session such as failing to make available.
 */
- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
	UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"session connectionWithPeerFailed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[a show];
	[a release];
}


/* Asynchronous delivery of data to one or more peers.  Returns YES if delivery started, NO if unable to start sending, and error will be set.  Delivery will be reliable or unreliable as set by mode.
 */
- (BOOL)sendData:(NSData *) data toPeers:(NSArray *)peers withDataMode:(GKSendDataMode)mode error:(NSError **)error{
    NSLog(@"INSIDE: sendData to peers");
	
	// now we can pass dicevalues to server!
	
    return YES;
}


    
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
    NSLog(@"in didChangeState");
	switch (state) { 
		case GKPeerStateAvailable:
            NSLog(@"GKPeerStateAvailable: %@", session);
            [myGkSession connectToPeer:peerID withTimeout:100.0];
            // A peer became available by starting app, exiting settings, or ending a call.
			break;
		case GKPeerStateUnavailable:
            NSLog(@"GKPeerStateUnavailable: %@", session);
            // Peer unavailable due leaving app, or entering settings.
            //[peerList removeObject:peerID]; 
            //[lobbyDelegate peerListDidChange:self]; 
			break;
		case GKPeerStateConnected:
            NSLog(@"GKPeerStateConnected: %@", session);
            // Connection was accepted
            myGkSession = session;
            myGkSession.delegate = self;
			break;				
		case GKPeerStateDisconnected:
            NSLog(@"GKPeerStateDisconnected: %@", session);
            myGkSession = nil;
            //[peerList removeObject:peerID]; 
            //[lobbyDelegate peerListDidChange:self];
			break;
        case GKPeerStateConnecting:
            NSLog(@"GKPeerStateConnecting: %@", session);
            // Peer is attempting to connect to the session.
            break;
		default:
			break;
	}
}

-(void) receiveData:(NSData *)data fromPeer:(NSString *)peerId inSession:(GKSession *)session context:(id)context {
    
    NSString *command = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSArray *argv = [command componentsSeparatedByString:@"|"];
	
	if ([command isEqualToString:@"YourTurn"]) {
		//[controlsViewController playerDidTakeDamage];
	}
	
	NSLog(@"command: %@",[argv objectAtIndex:0]);
	
	SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:",[argv objectAtIndex:0]]);
	if ([self respondsToSelector:selector]) {
		if (argv.count == 1) {
			[self performSelector:selector];
		}
		if (argv.count == 2) {
			NSLog(@"args: %@",[argv objectAtIndex:1]);
			[self performSelector:selector withObject:[argv objectAtIndex:1]];
		}
		
	}
	else {
		NSLog(@"PROTOCAL ERROR");
	}
	NSLog(@"%@",command);
}


- (void)dealloc {
//    [viewController release];
    [window release];
    [super dealloc];
}


@end
