//
//  RLServiceParser.m
//  Reliance
//
//  Created by Magnus Nordlander on 2010-08-21.
//  Copyright 2010 Smiling Plants HB. All rights reserved.
//

#import "RLServiceParser.h"

@interface RLServiceParser (PrivateAdditions)
-(void)parseServicesIntoContainer:(RLContainer*)container;
-(void)parseInitializedProvidersIntoContainer:(RLContainer*)container;
-(void)parseConvenienceConstructedProvidersIntoContainer:(RLContainer*)container;
@end

@implementation RLServiceParser

-(id)initWithContentsOfFile:(NSString*)filepath
{
  self = [super init];
  if (self != nil) {
    containerDescription = [[NSDictionary dictionaryWithContentsOfFile:filepath] retain];
  }
  return self;
}

- (void)dealloc {
  [containerDescription release];
  [super dealloc];
}

-(void)parseServicesIntoContainer:(RLContainer*)container
{
  for (NSDictionary* serviceDict in [containerDescription objectForKey:@"services"])
  {
    RLServiceDescription* serviceDescription = [[RLServiceDescription alloc] init];
    serviceDescription.serviceName = [serviceDict objectForKey:@"serviceName"];
    serviceDescription.requiredProtocol = NSProtocolFromString([serviceDict objectForKey:@"requiredProtocol"]);
    
    [container addServiceWithDescription:serviceDescription];
    [serviceDescription release];
  }
}

-(void)parseInitializedProvidersIntoContainer:(RLContainer*)container
{
  for (NSString* serviceName in [containerDescription objectForKey:@"providers"])
  {
    NSDictionary* providerDict = [[containerDescription objectForKey:@"providers"] objectForKey:serviceName];
    
    if ([providerDict objectForKey:@"initializer"] != nil)
    {
      RLInitializedServiceProvider* provider = [[RLInitializedServiceProvider alloc] init];
      provider.providerClass = NSClassFromString([providerDict objectForKey:@"providerClass"]);
      provider.initializer = NSSelectorFromString([providerDict objectForKey:@"initializer"]);
      provider.dependencies = [providerDict objectForKey:@"dependencies"];
      
      [container setProvider:provider forService:serviceName];
      [provider release];
    }
  }
}

-(void)parseConvenienceConstructedProvidersIntoContainer:(RLContainer*)container
{
  for (NSString* serviceName in [containerDescription objectForKey:@"providers"])
  {
    NSDictionary* providerDict = [[containerDescription objectForKey:@"providers"] objectForKey:serviceName];
    
    NSLog(@"%@", providerDict);
    
    if ([providerDict objectForKey:@"convenienceConstructor"] != nil)
    {
      RLConvenienceConstructedServiceProvider* provider = [[RLConvenienceConstructedServiceProvider alloc] init];
      provider.providerClass = NSClassFromString([providerDict objectForKey:@"providerClass"]);
      provider.convenienceConstructor = NSSelectorFromString([providerDict objectForKey:@"convenienceConstructor"]);
      provider.dependencies = [providerDict objectForKey:@"dependencies"];
      
      [container setProvider:provider forService:serviceName];
      [provider release];
    }
  }
}

-(void)parseIntoContainer:(RLContainer*)container
{
  [self parseServicesIntoContainer:container];
  
  [self parseInitializedProvidersIntoContainer:container];
  
  [self parseConvenienceConstructedProvidersIntoContainer:container];
}

@end
