//
//  SignInFormViewController.m
//  iHackerNews
//
//  Created by Junyu Wang on 6/6/15.
//  Copyright (c) 2015 junyuwang. All rights reserved.
//

#import "SignInFormViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import <PBFlatUI/PBFlatTextField.h>
#import <PBFlatUI/PBFlatButton.h>
#import <PBFlatUI/PBFlatRoundedImageView.h>
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import <AFNetWorking/AFNetWorking.h>
#import "Utils.h"
#import "constants.h"

@interface SignInFormViewController ()
@property (weak, nonatomic) IBOutlet PBFlatTextfield *usernameInputField;
@property (weak, nonatomic) IBOutlet PBFlatTextfield *passwordInputField;
@property (weak, nonatomic) IBOutlet PBFlatButton *signInButton;


@end

@implementation SignInFormViewController

#pragma mark - view controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor alloc] initWithRed:236 green:240 blue:241 alpha:1.0]; //the cloud color
    [self setUpButtons];
}

/**
 *  Set up basic UI components
 */
- (void)setUpButtons {
    self.usernameInputField.placeholder = @"Enter your username or email here";
    self.passwordInputField.placeholder = @"Enter your password here";
    self.passwordInputField.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backButtonOnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"user dismissed sign in view controller");
    }];
}

#pragma mark - sign in process

- (IBAction)signInButtonOnClick:(id)sender {
    if ([self authenticateInputFields]) {
        NSDictionary *userInput;
        NSString *getUserEndpoint;
        if ([self signInUsingEmail]) {
            //TODO: Do email sign in
            NSLog(@"user chooses to sign in with email");
            userInput = [[NSDictionary alloc] initWithObjectsAndKeys:self.usernameInputField.text, @"user_email", self.passwordInputField.text, @"password", nil];
            getUserEndpoint = [Utils appendEncodedDictionary:userInput
                                                       ToURL:getUserURL];
        }else {
            //TODO: Do username sign in
            NSLog(@"user chooses to sign in with username");
            userInput = [[NSDictionary alloc] initWithObjectsAndKeys:self.usernameInputField.text, @"username", self.passwordInputField.text, @"password", nil];
            getUserEndpoint = [Utils appendEncodedDictionary:userInput
                                                       ToURL:getUserURL];
        }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:getUserEndpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

/**
 *  check to see if user choose to sign in using email or username
 *
 *  @return YES or NO
 */
- (BOOL)signInUsingEmail {
    if ([Utils NSStringIsValidEmail:self.usernameInputField.text]) {
        return YES;
    }else {
        return NO;
    }
}

/**
 *  Check if all input fields have been filled
 *
 *  @return YES or NO
 */
- (BOOL)authenticateInputFields {
    if (self.usernameInputField.text.length == 0 || self.passwordInputField.text.length == 0) {
        SCLAlertView *inputFieldsEmptyAlert = [[SCLAlertView alloc] init];
        [inputFieldsEmptyAlert showWarning:self
                                     title:@"Error"
                                  subTitle:@"Username or password cannot be emtpy"
                          closeButtonTitle:@"OK"
                                  duration:0.0f];
        return NO;
    }else {
        return YES;
    }
}

@end
