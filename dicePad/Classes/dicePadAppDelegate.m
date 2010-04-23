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
    
    CGRect frame = CGRectMake(150,50, 450,50);
    peerLabel = [[UILabel alloc] initWithFrame:frame];
	[peerLabel setFont:[UIFont fontWithName:@"Arial" size:36]];
	[peerLabel setBackgroundColor:[UIColor greenColor]];
    peerLabel.text = [NSString stringWithFormat:@"%d player(s) so far",peerCount];
    [viewController.view addSubview:peerLabel];

	CGRect frame2 = CGRectMake(200,200, 100,100);
    diceImageView = [[UIImageView alloc] initWithFrame:frame2];
//	[diceImageView setImage:[UIImage imageNamed:@"2.png"]];
	diceImageView.hidden = YES;
	[viewController.view addSubview:diceImageView];

 	CGRect frame3 = CGRectMake(350,200, 100,100);
    diceImageView2 = [[UIImageView alloc] initWithFrame:frame3];
//	[diceImageView2 setImage:[UIImage imageNamed:@"5.png"]];
	diceImageView2.hidden = YES;
	[viewController.view addSubview:diceImageView2];
    
    [viewController.view setBackgroundColor:[UIColor greenColor]];
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

    myGkSession = [[GKSession alloc] initWithSessionID:@"DicePad" displayName:nil sessionMode:GKSessionModeServer];
    myGkSession.available = YES;
    myGkSession.delegate = self;
			
//	[self animateDice:2 secondDi:5];
    
	return YES;
}

# pragma mark animation

- (void)animateDice:(int)di1 secondDi:(int)di2 {
	
	UIImage *img1 = [UIImage imageNamed:@"1.png"]; 
	UIImage *img2 = [UIImage imageNamed:@"2.png"];
	UIImage *img3 = [UIImage imageNamed:@"3.png"];
	UIImage *img4 = [UIImage imageNamed:@"4.png"];
	UIImage *img5 = [UIImage imageNamed:@"5.png"];
	UIImage *img6 = [UIImage imageNamed:@"6.png"];

	NSArray *diceMaster = [[NSArray alloc] initWithObjects: img1, img2, img3, img4, img5, img6, nil];

	// index positions start at 0 whereas dice start at 1
	di1--;
	di2--;
	
	NSLog(@"d1:%d and d2:%d after lowering",di1, di2);
	
	// assign incoming peer's di
	UIImage *lastImage1 = [diceMaster objectAtIndex:di1];
	UIImage *lastImage2 = [diceMaster objectAtIndex:di2];
	
	NSArray *iArray = [[NSArray alloc] initWithObjects:lastImage1, img2, img3, img1, img5, img6, img3, img4, img5, nil];
	NSArray *iArray2 = [[NSArray alloc] initWithObjects:lastImage2, img5, img1, img2, img6, img1, img3, img2, img4, nil];
	
	diceImageView.hidden = NO;
	diceImageView.animationImages = iArray;
	diceImageView.animationDuration = 2;
	diceImageView.animationRepeatCount = 1;
	[diceImageView startAnimating ];
	[diceImageView setImage:[diceMaster objectAtIndex:di1]];
	
	diceImageView2.hidden = NO;
    diceImageView2.animationImages = iArray2;
	diceImageView2.animationDuration = 2;
	diceImageView2.animationRepeatCount = 1;
	[diceImageView2 startAnimating ];
	[diceImageView2 setImage:[diceMaster objectAtIndex:di2]];
    
	
}

#pragma mark session

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
			[self.myGkSession setDataReceiveHandler:self withContext:nil];

            // Record the peerID of the other peer.
            // Inform your game that a peer has connected.
//			[self animateDice:2 secondDi:5];			
            break;
        case GKPeerStateDisconnected:
            NSLog(@"didChangeState State DISCONNECTED");
            peerCount--;
            peerLabel.text = [NSString stringWithFormat:@"%d player(s) so far",peerCount, peerID];
            // Inform your game that a peer has left.
            break;
    }
}

# pragma mark data methods

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
	NSLog(@"RECEIVING DATA *********************************");
	
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	NSArray * rolledDice = (NSArray *)[NSPropertyListSerialization
										  propertyListFromData:data
										  mutabilityOption:NSPropertyListMutableContainersAndLeaves
										  format:&format
										  errorDescription:&errorDesc];
	NSLog(@"rolledDice: %@ ", rolledDice);
		
	int di1 = [[rolledDice objectAtIndex:0] intValue];
	int di2 = [[rolledDice objectAtIndex:1] intValue];
	
	NSLog(@"di1 %d and di2 %d end of receive method", di1, di2);
	
	[self animateDice:di1 secondDi:di2];

}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
