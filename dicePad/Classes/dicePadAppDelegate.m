//
//  dice1AppDelegate.m
//  dice1
//
//  Created by stacie on 4/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "dicePadAppDelegate.h"
#import "dicePadViewController.h"

@implementation dicePadAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize myGkSession;
@synthesize peerCount;
@synthesize peerLabel;
@synthesize currentPeerID;
@synthesize thePeers;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    peerCount = 0;
    
    CGRect frame = CGRectMake(150,200, 450,450);
    peerLabel = [[UILabel alloc] initWithFrame:frame];
	[peerLabel setFont:[UIFont fontWithName:@"Arial" size:36]];
	[peerLabel setBackgroundColor:[UIColor greenColor]];
    peerLabel.text = [NSString stringWithFormat:@"The peer count is: %d",peerCount];
    [viewController.view addSubview:peerLabel];
    
    
    // Override point for customization after app launch  
    [viewController.view setBackgroundColor:[UIColor greenColor]];
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

    myGkSession = [[GKSession alloc] initWithSessionID:@"DicePad" displayName:nil sessionMode:GKSessionModeServer];
    myGkSession.available = YES;
    NSLog(@"in session beginning");
//	return [myGkSession retain]; // peer picker retains a reference, so autorelease ours so we don't leak.
    return YES;
}


- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
    NSError *error = nil;
    [session acceptConnectionFromPeer:peerID error:&error];
    NSLog(@"in did receive conn from peer, %@", peerID);
}

- (BOOL)acceptConnectionFromPeer:(NSString *)peerID error:(NSError **)error{	// errors: cancelled, or timeout
    //peerCount++;
    //peerLabel.text = [NSString stringWithFormat:@"The peercount is: %d, peerID is %@",peerCount, peerID];
    NSLog(@"accept connection. peer count: %d", peerCount);
    NSLog(@"error if any: %@", error);
    return YES;
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    switch (state)
    {
        case GKPeerStateConnected:
            NSLog(@"didChangeState State CONNECTED");
            peerCount++;
            peerLabel.text = [NSString stringWithFormat:@"The peercount is: %d, peerID is %@",peerCount, peerID];
            // Record the peerID of the other peer.
            // Inform your game that a peer has connected.
            break;
        case GKPeerStateDisconnected:
            NSLog(@"didChangeState State DISCONNECTED");
            peerCount--;
            peerLabel.text = [NSString stringWithFormat:@"The peercount is: %d, peerID is %@",peerCount, peerID];
            // Inform your game that a peer has left.
            break;
    }
}


- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context { 
	unsigned char *incomingPacket = (unsigned char *)[data bytes];
	int *pIntData = (int *)&incomingPacket[0];
	//
	// developer  check the network time and make sure packers are in order
	//
//	int packetTime = pIntData[0];
	int packetID = pIntData[1];
    NSLog(@"In the receivedata window");
    peerLabel.text = [NSString stringWithFormat:@"The connecting peer: %d", packetID];
}    


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
