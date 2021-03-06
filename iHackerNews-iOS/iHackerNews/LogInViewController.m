//
//  LogInViewController.m
//  iHackerNews
//
//  Created by Junyu Wang on 6/5/15.
//  Copyright (c) 2015 junyuwang. All rights reserved.
//

#import "LogInViewController.h"
#import <DKCircleButton/DKCircleButton.h>
#import <ChameleonFramework/Chameleon.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import <AFNetworking/AFNetworking.h>
#import "constants.h"
#import "MRProgress.h"


@interface LogInViewController ()

@property (weak, nonatomic) IBOutlet UILabel *signInLabel;
@property (weak, nonatomic) IBOutlet UIButton *SignUpButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet DKCircleButton *facebookLoginButton;
@property (weak, nonatomic) IBOutlet DKCircleButton *normalLoginButton;

@end

@implementation LogInViewController


#pragma mark - view controller lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:FlatOrange];
    [self setUpButton];
    [self setBackgroundImageAndLabel];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(facebookUserSignedUp)
                                                 name:FBSDKAccessTokenDidChangeNotification
                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(storeFacebookUserProfile)
//                                                 name:FBSDKProfileDidChangeNotification
//                                               object:nil];
    
    // make button larger using scaling -- can't set it up using size after adding auto-layout, dky
    self.facebookLoginButton.transform = CGAffineTransformMakeScale(1.2,1.2);
    self.normalLoginButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpButton {
    [self.facebookLoginButton setBackgroundImage:[UIImage imageNamed:@"facebook_login_button"] forState:UIControlStateNormal];
    [self.facebookLoginButton addTarget:self action:@selector(signUpWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    self.facebookLoginButton.animateTap = NO;
    
    
    [self.normalLoginButton setBackgroundImage:[UIImage imageNamed:@"normal_login_button"] forState:UIControlStateNormal];
    [self.normalLoginButton addTarget:self action:@selector(normalUserSignUp) forControlEvents:UIControlEventTouchUpInside];
    self.normalLoginButton.animateTap = NO;
    
}

- (void)setBackgroundImageAndLabel {
    self.backgroundImageView.layer.masksToBounds = YES;
    self.backgroundImageView.layer.cornerRadius = 20;
    [self.SignUpButton setTitleColor:ComplementaryFlatColorOf(self.view.backgroundColor) forState:UIControlStateNormal];
}

- (void)signUpWithFacebook {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            NSLog(@"error logging into facebook");
            UIAlertView *cancellNotice = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[error localizedDescription]
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
            [cancellNotice show];
        } else if (result.isCancelled) {
            NSLog(@"user cancelled login with facebook");
            UIAlertView *cancellNotice = [[UIAlertView alloc] initWithTitle:@"Cancelled"
                                                                    message:@"You just cancelled signing up with Facebook"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
            [cancellNotice show];
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            
            if ([result.grantedPermissions containsObject:@"email"]) {
                // TODO: Do something after facebook login
                
            }
        }
    }];
}

- (void)normalUserSignUp {
    [self performSegueWithIdentifier:@"show to sign up view" sender:self];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - sign up with facebook

- (void)facebookUserSignedUp {
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 [[NSUserDefaults standardUserDefaults] setValue:result[@"email"] forKey:@"email"];
                 [[NSUserDefaults standardUserDefaults] setValue:result[@"name"] forKey:@"username"];
                 [[NSUserDefaults standardUserDefaults] setValue:result[@"id"] forKey:@"facebook_id"];
                 [[NSUserDefaults standardUserDefaults] setValue:[[FBSDKAccessToken currentAccessToken] tokenString] forKey:@"facebook_auth_token"];
                 // register facebook user on server
                 NSDictionary *facebookUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:result[@"id"], @"facebook_id", [[FBSDKAccessToken currentAccessToken] tokenString], @"password", result[@"email"], @"user_email", result[@"name"], @"username", nil];
                 [MRProgressOverlayView showOverlayAddedTo:self.view animated:YES];
                 [self registerFacebookUserInServerWithInfo:facebookUserInfo];
             }
         }];
    }
}

- (void)registerFacebookUserInServerWithInfo:(NSDictionary *)info {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:createUserURL
       parameters:info
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              [self handleFacebookUserSignUpServerResponse:responseObject];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
              UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                   message:[error localizedDescription]
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil, nil];
              [errorAlert show];
          }];
}

- (void)handleFacebookUserSignUpServerResponse:(id)response {
    if (response[@"success"]) {
        [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
        [self performSegueWithIdentifier:@"facebook user signed up modal segue" sender:self];
        [[NSUserDefaults standardUserDefaults] setValue:response[@"user_info"][@"user_id"] forKey:@"user_id"];
    }else {
        [MRProgressOverlayView dismissOverlayForView:self.view animated:YES];
        [self clearOutFacebookUserInfo];
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:response[@"error"]
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
        [errorAlert show];
    }
}

- (void)clearOutFacebookUserInfo {
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"facebook_id"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"facebook_auth_token"];
}

@end
