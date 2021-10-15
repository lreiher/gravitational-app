//
//  GravitationalViewController.m
//  Gravitational
//
//  Created by Lennart Reiher on 20.02.14.
//  Copyright (c) 2014 Lennart Reiher. All rights reserved.
//

#import "GravitationalViewController.h"

#import "MyGADBannerView.h"

#import "MyIADBannerView.h"

#import "GADAdMobExtras.h"

#import "GCHelper.h"

#import "MKStoreManager.h"

#import "Reachability.h"

#import "CustomActivityItems.h"

#import "iRate.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation GravitationalViewController {
    SKView* skView;
    MyIADBannerView* iADBanner;
    MyGADBannerView* GADBanner;
    BOOL isInitialLaunch;
    BOOL iAdEnabled;
}

#pragma mark Setup

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // Configure the view.
    skView = (SKView*)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    skView.showsDrawCount = NO;
    skView.showsPhysics = NO;
    skView.window.rootViewController = self;
    
    // Setup App-Transition Observer
    [self registerAppTransitionObservers];
    
    // Setup Game Area
    [Global globals].BANNER_AREA = CGSizeFromGADAdSize(kGADAdSizeBanner);
    if ([Global globals].ADS) {
        [Global globals].GAME_AREA = CGSizeMake(skView.frame.size.width, skView.frame.size.height - [Global globals].BANNER_AREA.height);
    } else {
        [Global globals].GAME_AREA = skView.frame.size;
    }
    
    // Remove iAd for iPhone 4
    if ([Global globals].isPhone && ![Global globals].isWidescreen) {
        iAdEnabled = false;
    } else {
        iAdEnabled = true;
    }
    
    // Setup gesture recognizer
    UIPanGestureRecognizer* panDownGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanDown:)];
    [self.view addGestureRecognizer:panDownGesture];
    
    // Setup NSUserDefaults
    [Global globals].USERDEFAULTS = [NSUserDefaults standardUserDefaults];
    
    // Setup Music Player
    [Global globals].MUSICPLAYER = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"backgroundInGame" withExtension:@"mp3"] error:nil];
    
    // First Launch only
    if (![[Global globals].USERDEFAULTS boolForKey:@"notFirstLaunch"]) {
        [[Global globals].USERDEFAULTS setBool:true forKey:@"music"];
        [[Global globals].USERDEFAULTS setBool:true forKey:@"sounds"];
        [[Global globals].USERDEFAULTS setBool:true forKey:@"notFirstLaunch"];
        [[Global globals].USERDEFAULTS synchronize];
    }
    
    // Present Scene
    [self presentMenu];
    
    // Setup Game Center
    [[GCHelper defaultHelper] authenticateLocalUserOnViewController:self setCallbackObject:self withPauseSelector:@selector(authenticationRequired)];
}

#pragma mark Scene presentation delegate methods

-(void)presentMenu {
    SKTransition* trans = [SKTransition doorsCloseHorizontalWithDuration:0.75 / [Global globals].SPEED];
    MenuScene* scene = [MenuScene sceneWithSize:skView.bounds.size];
    scene.delegate = self;
    [skView presentScene:scene transition:trans];
}

-(void)presentGameWithDirection:(int)dir {
    SKTransition* trans = [SKTransition pushWithDirection:dir duration:1.0 / [Global globals].SPEED];
    GameScene* scene = [GameScene sceneWithSize:skView.bounds.size];
    scene.delegate = self;
    [skView presentScene:scene transition:trans];
}

-(void)presentGameOver {
    GameOverScene* scene = [GameOverScene sceneWithSize:skView.bounds.size];
    scene.delegate = self;
    [skView presentScene:scene];
}

-(void)presentSettings {
    SKTransition* trans = [SKTransition pushWithDirection:SKTransitionDirectionUp duration:0.75 / [Global globals].SPEED];
    SettingsScene* scene = [SettingsScene sceneWithSize:skView.bounds.size];
    scene.delegate = self;
    [skView presentScene:scene transition:trans];
}

-(void)presentTutorial {
    SKTransition* trans = [SKTransition crossFadeWithDuration:1.0 / [Global globals].SPEED];
    TutorialScene* scene = [TutorialScene sceneWithSize:skView.bounds.size];
    scene.delegate = self;
    [skView presentScene:scene transition:trans];
}



#pragma mark Gesture Recognizer selector

-(void)handlePanDown:(UIPanGestureRecognizer*)recognizer {
    MyScene* currentScene = (MyScene*)(skView.scene);
    [currentScene handlePan:recognizer];
}



#pragma mark Advertisement Setup

-(void)showAdsAtTop:(BOOL)top {
    
    CGPoint origin;
    
    if (top) {
        origin.x = 0.0;
        origin.y = -CGSizeFromGADAdSize(kGADAdSizeBanner).height;
    } else {
        origin.x = -CGSizeFromGADAdSize(kGADAdSizeBanner).width;
        if ([[Global globals] isPhone]) {
            if ([[Global globals] isWidescreen]) {
                origin.y = 295.5;
            } else {
                origin.y = 207.5;
            }
        } else {
            origin.y = 295.5;
        }
    }
    
    if ([Global globals].ADS && GADBanner == nil) {
        
        if (iAdEnabled) {
            iADBanner = [[MyIADBannerView alloc] initWithAdType:ADAdTypeBanner origin:origin];
            iADBanner.delegate = self;
            [iADBanner moveToOrigin];
            [self.view addSubview:iADBanner];
        }
        
        GADBanner = [[MyGADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
        GADBanner.rootViewController = self;
        GADBanner.delegate = self;
        [GADBanner moveToOrigin];
        GADRequest* request = [GADRequest request];
        request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, @"f9513eaead2847e3fe327a4518de542f", @"66fd495999cc29b9700af5bdae4a8237", nil];
        GADAdMobExtras* extras = [[GADAdMobExtras alloc] init];
        extras.additionalParameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"BD1A03", @"color_bg",
                                       @"BD1A03", @"color_bg_top",
                                       @"BD1A03", @"color_border",
                                       @"#FFD600", @"color_link",
                                       @"FFD600", @"color_text",
                                       @"FFD600", @"color_url",
                                       nil];
        
        [request registerAdNetworkExtras:extras];
        [GADBanner loadRequest:request];
        [self.view addSubview:GADBanner];
    }
}

-(void)hideAds {
    if (iAdEnabled) {
        [iADBanner removeFromSuperview];
        iADBanner.delegate = nil;
        iADBanner = nil;
    }
        
    [GADBanner removeFromSuperview];
    GADBanner.rootViewController = nil;
    GADBanner.delegate = nil;
    GADBanner = nil;
}



#pragma mark Advertisement delegate methods

-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    NSLog(@"Ad received from iAd");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [iADBanner moveToDestination];
    [GADBanner moveToOrigin];
    [UIView commitAnimations];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Ad did fail with error: %@", [error localizedDescription]);
    [iADBanner moveToOrigin];
    
    if (GADBanner.isLoaded) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [GADBanner moveToDestination];
        [UIView commitAnimations];
    }
}

-(void)adViewDidReceiveAd:(GADBannerView *)view {
    NSLog(@"Ad received from %@",view.adNetworkClassName);
    GADBanner.isLoaded = true;
    if (!iADBanner.bannerLoaded || !iAdEnabled) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [GADBanner moveToDestination];
        [UIView commitAnimations];
    }
}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"Ad did fail with error: %@", [error localizedDescription]);
    GADBanner.isLoaded = false;
    [GADBanner moveToOrigin];
}



#pragma mark In-App Purchasing

-(void)removeAdsForever {

    if ([self connectedToInternet]) {
        [[MKStoreManager sharedManager] buyFeature:REMOVEADSID
                                        onComplete:^(NSString* purchasedFeature, NSData* purchasedReceipt, NSArray* availableDownloads) {
                                            [Global globals].ADS = ![MKStoreManager isFeaturePurchased:REMOVEADSID];
                                            NSLog(@"ADS is now set to: %d",[Global globals].ADS);
                                            if ([skView.scene isKindOfClass:[SettingsScene class]]) {
                                                
                                                [(SettingsScene*)(skView.scene) reactToSuccessfulPurchase];
                                            }
                                            [self hideAds];
                                        }
                                       onCancelled:^{
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                           message:@"Could not purchase advertisement-free version."
                                                                                          delegate:nil
                                                                                 cancelButtonTitle:@"OK"
                                                                                 otherButtonTitles:nil];
                                           [alert show];
                                       }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Internet connection not available."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)restorePreviousPurchases {
    
    if ([self connectedToInternet]) {
        [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                             message:@"All previously made purchases have been restored."
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
             [Global globals].ADS = ![MKStoreManager isFeaturePurchased:REMOVEADSID];
             NSLog(@"ADS is now set to: %d",[Global globals].ADS);
             if ([skView.scene isKindOfClass:[SettingsScene class]]) {
                 
                 [(SettingsScene*)(skView.scene) reactToSuccessfulPurchase];
             }
             [self hideAds];
         }
                                                                      onError:^(NSError* error)
         {
             NSLog(@"%@",error.localizedDescription);
         }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Internet connection not available."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)resetAllPurchases {
    [[MKStoreManager sharedManager] removeAllKeychainData];
    [Global globals].ADS = ![MKStoreManager isFeaturePurchased:REMOVEADSID];
    NSLog(@"ADS is now set to: %d",[Global globals].ADS);
}


#pragma mark Game Center

-(void)authenticationRequired {
    
    if ([skView.scene isKindOfClass:[GameScene class]]) {
        
        [(GameScene*)(skView.scene) reactToInterruption];
    }
}

-(void)showLeaderboard {
    
    if ([self connectedToInternet]) {
        [[GCHelper defaultHelper] showLeaderboardOnViewController:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Internet connection not available."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}



#pragma mark Google Analytics

-(void)sendGAIScreen:(NSString *)name {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}



#pragma mark Tutorial Prompt

-(void)showTutorialPrompt {
    
    if(NSClassFromString(@"UIAlertController")) {
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle: @"Need help?"
                                                                                 message: @"It seems that you should practice a little, do you want to take a look at the tutorial again?"
                                                                          preferredStyle: UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Show Tutorial" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
            [[Global globals].MUSICPLAYER stop];
            [[Global globals].USERDEFAULTS setInteger:0 forKey:@"consecutiveGamesBelow140"];
            [self presentTutorial];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Never try to help me again" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action) {
            [[Global globals].USERDEFAULTS setBool:true forKey:@"tutorialPromptDisabled"];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"No, I can do this!" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"It seems that you should practice a little, do you want to take a look at the tutorial again?" delegate:self cancelButtonTitle:@"No, I can do this!" destructiveButtonTitle:@"Never try to help me again" otherButtonTitles:(@"Show Tutorial"), nil];
        [actionSheet showInView:self.view];
    }
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [[Global globals].USERDEFAULTS setBool:true forKey:@"tutorialPromptDisabled"];
    } else if (buttonIndex == 1) {
        [[Global globals].MUSICPLAYER stop];
        [[Global globals].USERDEFAULTS setInteger:0 forKey:@"consecutiveGamesBelow140"];
        [self presentTutorial];
    }
}


#pragma mark Share View Controller

-(void)showShareViewController {
    CustomActivityItems* customItems = [[CustomActivityItems alloc] init];
    
    UIActivityViewController* share = [[UIActivityViewController alloc] initWithActivityItems:@[customItems] applicationActivities:nil];
    
    share.excludedActivityTypes = @[UIActivityTypeAirDrop,UIActivityTypePostToWeibo,UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    
    [self presentViewController:share animated:YES completion:nil];
}



#pragma mark Rate Application

-(void)switchToAppStore {
    [[iRate sharedInstance] openRatingsPageInAppStore];
}



#pragma mark Send Mail

-(void)sendMail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                    message:@"I would really like any kind of feedback from you! Do not hesitate to contact me in order to report bugs, give me suggestions on improving Gravitational or just say 'hi'!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self showMailInterface];
}

-(void)showMailInterface {
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:@"Contact Inquiry"];
    [mc setMessageBody:nil isHTML:NO];
    [mc setToRecipients:[NSArray arrayWithObject:@"contact@gravitational-app.com"]];
    
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:{
            NSLog(@"Mail cancelled");
            break;}
        case MFMailComposeResultSaved:{
            NSLog(@"Mail saved");
            break;}
        case MFMailComposeResultSent:{
            NSLog(@"Mail sent");
            break;}
        case MFMailComposeResultFailed:{
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"Your mail did not send properly.\n\n%@",[error localizedDescription]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            break;}
        default:{
            break;}
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark Internet check

-(BOOL)connectedToInternet
{
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}



#pragma mark App-Transition Delegate Methods

-(void)registerAppTransitionObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidFinishLaunching)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:NULL];
    
}

-(void)applicationDidFinishLaunching {
    NSLog(@"did finish launching");
    
    isInitialLaunch = true;
}

-(void)applicationWillResignActive {
    NSLog(@"will resign active");
    
    isInitialLaunch = false;
    
    if ([skView.scene isKindOfClass:[GameScene class]]) {
        
        [(GameScene*)(skView.scene) reactToInterruption];
    }
    
    if ([[Global globals].USERDEFAULTS boolForKey:@"music"]) {
        if ([Global globals].MUSICPLAYER.url != nil) {
            [[Global globals].MUSICPLAYER pause];
        }
    }
    
    [self sendGAIScreen:nil];
}

-(void)applicationDidEnterBackground {
    NSLog(@"did enter background");
}

-(void)applicationDidBecomeActive {
    NSLog(@"did become active");
    
    if ([[Global globals].USERDEFAULTS boolForKey:@"music"]) {
        if (!isInitialLaunch) {
            if ([Global globals].MUSICPLAYER.url != nil) {
                [[Global globals].MUSICPLAYER play];
            }
        }
    }
    
    if ([skView.scene isKindOfClass:[GameScene class]]) {
        [self sendGAIScreen:@"Game Scene"];
    } else if ([skView.scene isKindOfClass:[GameOverScene class]]) {
        [self sendGAIScreen:@"GameOver Scene"];
    } else if ([skView.scene isKindOfClass:[SettingsScene class]]) {
        [self sendGAIScreen:@"Settings Scene"];
    } else if ([skView.scene isKindOfClass:[TutorialScene class]]) {
        [self sendGAIScreen:@"Tutorial Scene"];
    } else {
        [self sendGAIScreen:@"Menu Scene"];
    }
}


#pragma mark Additional ViewController Stuff

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"MEMORY WARNING");
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
