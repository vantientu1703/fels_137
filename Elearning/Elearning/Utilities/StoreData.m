//
//  StoreData.m
//  Elearning
//
//  Created by Nguyen Van Thieu B on 5/27/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

#import "StoreData.h"

@implementation StoreData

+ (UICKeyChainStore *)initTheKeyChain {
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:KEYCHAIN_KEY_SERVICE];
    return keychain;
}

+ (User *)getUser {
    UICKeyChainStore *chain = [StoreData initTheKeyChain];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    User *user = [[User alloc] init];
    user.name = [defaults objectForKey:@"name"];
    user.email = [defaults objectForKey:@"email"];
    user.avatar = [defaults objectForKey:@"avatar"];
    user.activities = [defaults objectForKey:@"activities"];
    user.userId = [defaults integerForKey:@"user_id"];
    user.learnedWords = [defaults integerForKey:@"learned_words"];
    user.authToken = chain[@"auth_token"];
    return user;
}

+ (void)setUser:(User *)user {
    UICKeyChainStore *chain = [StoreData initTheKeyChain];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user.name forKey:@"name"];
    [defaults setObject:user.email forKey:@"email"];
    [defaults setObject:user.avatar forKey:@"avatar"];
    [defaults setObject:user.activities forKey:@"activities"];
    [defaults setInteger:user.userId forKey:@"user_id"];
    [defaults setInteger:user.learnedWords forKey:@"learned_words"];
    [chain setString:user.authToken forKey:@"auth_token"];
}

+ (void)clearUser {
    UICKeyChainStore *chain = [StoreData initTheKeyChain];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"name"];
    [defaults removeObjectForKey:@"email"];
    [defaults removeObjectForKey:@"avatar"];
    [defaults removeObjectForKey:@"activities"];
    [defaults removeObjectForKey:@"user_id"];
    [defaults removeObjectForKey:@"learned_words"];
    [chain removeItemForKey:@"auth_token"];
}

+ (UserInput *)getInput {
    UICKeyChainStore *chain = [StoreData initTheKeyChain];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UserInput *input = [[UserInput alloc] init];
    input.rememberMe = [defaults boolForKey:@"remember_me"];
    input.emailInput = chain[@"email_input"];
    input.passwordInput = chain[@"password_input"];
    return input;
}

+ (void)setInput:(UserInput *)input {
    UICKeyChainStore *chain = [StoreData initTheKeyChain];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:input.rememberMe forKey:@"remember_me"];
    [chain setString:input.emailInput forKey:@"email_input"];
    [chain setString:input.passwordInput forKey:@"password_input"];
}

+ (void)clearInput {
    UICKeyChainStore *chain = [StoreData initTheKeyChain];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"remember_me"];
    [chain removeItemForKey:@"email_input"];
    [chain removeItemForKey:@"password_input"];
}

+ (BOOL)getLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"is_login"];
}

+ (void)setLogin:(BOOL)isLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isLogin forKey:@"is_login"];
}

+ (void)clearLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"is_login"];
}

+ (BOOL)getShowUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"is_show"];
}

+ (void)setShowUser:(BOOL)isShow {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isShow forKey:@"is_show"];
}

+ (void)clearShowUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"is_show"];
}

@end
