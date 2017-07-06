//
//  JMUserDefault.m
//  Creativity
//
//  Created by JM Zhao on 2017/7/6.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMUserDefault.h"

@implementation JMUserDefault
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

+ (void)removeObjectByKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
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
    NSString *anser = [defaults objectForKey:key];
    return anser;
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

#pragma mark -- 存储和读取 integer 值
+ (BOOL)setInteger:(NSInteger)integer forKey:(NSString *)defaultName
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setInteger:integer forKey:defaultName];
    return [defaults synchronize];
}

+ (BOOL)readIntegerByKey:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:key];
}

@end
