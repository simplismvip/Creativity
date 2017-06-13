//
//  UserDefaultTools.m
//  PageShare
//
//  Created by JM Zhao on 16/8/29.
//  Copyright © 2016年 Oneplus Smartware. All rights reserved.
//

#import "UserDefaultTools.h"

@implementation UserDefaultTools

+ (void)removeObjectByKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
}

#pragma mark -- 存储和读取 NSNumber 值
+ (BOOL)setUrl:(NSURL *)url forKey:(NSString *)defaultName
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setURL:url forKey:defaultName];
    return [defaults synchronize];
}

+ (NSURL *)readUrlByKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults URLForKey:key];
}

#pragma mark -- 存储和读取 NSNumber 值
+ (BOOL)setValue:(NSNumber *)value forKey:(NSString *)defaultKey
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:defaultKey];
    return [defaults synchronize];
}

+ (NSInteger)getValueByKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSNumber *n = [defaults valueForKey:key];
    return [n integerValue];
}

#pragma mark -- 存储和读取 NSString 值
+ (BOOL)setString:(NSString *)string forKey:(NSString *)defaultName
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:string forKey:defaultName];
    return [defaults synchronize];
}

+ (NSString *)readStringByKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

#pragma mark -- 存储和读取 BOOL 值
+ (BOOL)setBool:(BOOL)Bool forKey:(NSString *)defaultName
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:Bool forKey:defaultName];
    return [defaults synchronize];
}

+ (BOOL)readBoolByKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}

#pragma mark -- 存储和读取 NSInteger 值
+ (BOOL)setInteger:(NSInteger)integer forKey:(NSString *)defaultName
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setInteger:integer forKey:defaultName];
    return [defaults synchronize];
}

+ (NSInteger)readIntegerByKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:key];
}

#pragma mark -- 存储和读取 float 值
+ (BOOL)setFloat:(float)Float forKey:(NSString *)defaultName
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setFloat:Float forKey:defaultName];
    return [defaults synchronize];
}

+ (float)readFloatByKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults floatForKey:key];
}

@end
