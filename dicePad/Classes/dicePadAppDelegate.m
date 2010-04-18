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
@synthesize diceImageView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    peerCount = 0;
    
    CGRect frame = CGRectMake(150,200, 450,450);
    peerLabel = [[UILabel alloc] initWithFrame:frame];
	[peerLabel setFont:[UIFont fontWithName:@"Arial" size:36]];
	[peerLabel setBackgroundColor:[UIColor greenColor]];
    peerLabel.text = [NSString stringWithFormat:@"%d player(s) so far",peerCount];
    [viewController.view addSubview:peerLabel];

	CGRect frame2 = CGRectMake(200,200, 57,57);
    diceImageView = [[UIImageView alloc] initWithFrame:frame2];
	[diceImageView setImage:[UIImage imageNamed:@"1.png"]];
	[viewController.view addSubview:diceImageView];

    
    [viewController.view setBackgroundColor:[UIColor greenColor]];
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

    myGkSession = [[GKSession alloc] initWithSessionID:@"DicePad" displayName:nil sessionMode:GKSessionModeServer];
    myGkSession.available = YES;
    myGkSession.delegate = self;
    NSLog(@"in session beginning");
	
	[self animateDice];
		
//	return [myGkSession retain]; // peer picker retains a reference, so autorelease ours so we don't leak.
    return YES;
}


- (void)animateDice {
	
	UIImage *img1 = [UIImage imageNamed:@"1.png"]; 
	UIImage *img2 = [UIImage imageNamed:@"2.png"];
	UIImage *img3 = [UIImage imageNamed:@"3.png"];
	UIImage *img4 = [UIImage imageNamed:@"4.png"];
	UIImage *img5 = [UIImage imageNamed:@"5.png"];
	UIImage *img6 = [UIImage imageNamed:@"6.png"];

	
	
	NSArray *iArray = [[NSArray alloc] initWithObjects:img2, img3, img1, img5, img6, img3, img4, img5, nil];
	
	diceImageView.animationImages = iArray;
	diceImageView.animationDuration = 2;
	diceImageView.animationRepeatCount = 3;
	
	[diceImageView startAnimating ];
	[viewController.view addSubview:diceImageView];
	
	
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
    NSLog(@"in did receive conn from peer, %@", peerID);
    NSError *error = nil;
    [session acceptConnectionFromPeer:peerID error:&error];
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
            peerLabel.text = [NSString stringWithFormat:@"%d player(s) so far",peerCount, peerID];
            // Record the peerID of the other peer.
            // Inform your game that a peer has connected.
			[self animateDice];
            break;
        case GKPeerStateDisconnected:
            NSLog(@"didChangeState State DISCONNECTED");
            peerCount--;
            peerLabel.text = [NSString stringWithFormat:@"%d player(s) so far",peerCount, peerID];
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
