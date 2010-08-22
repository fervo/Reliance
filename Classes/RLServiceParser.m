//
//  RLServiceParser.m
//  Reliance
//
//  Created by Magnus Nordlander on 2010-08-21.
//  Copyright 2010 Smiling Plants HB. All rights reserved.
//

#import "RLServiceParser.h"


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

-(void)parseIntoContainer:(RLContainer*)container
{
  // Parse services
  for (NSDictionary* serviceDict in [containerDescription objectForKey:@"services"])
  {
    RLServiceDescription* serviceDescription = [[RLServiceDescription alloc] init];
    serviceDescription.serviceName = [serviceDict objectForKey:@"serviceName"];
    serviceDescription.requiredProtocol = NSProtocolFromString([serviceDict objectForKey:@"requiredProtocol"]);
    
    [container addServiceWithDescription:serviceDescription];
    [serviceDescription release];
  }
  
  // Parse providers
  for (NSString* serviceName in [containerDescription objectForKey:@"providers"])
  {
    NSDictionary* providerDict = [[containerDescription objectForKey:@"providers"] objectForKey:serviceName];
    
    RLServiceProvider* provider = [[RLServiceProvider alloc] init];
    provider.providerClass = NSClassFromString([providerDict objectForKey:@"providerClass"]);
    provider.initializer = NSSelectorFromString([providerDict objectForKey:@"initializer"]);
    provider.dependencies = [providerDict objectForKey:@"dependencies"];
    
    [container setProvider:provider forService:serviceName];
    [provider release];
  }
}

@end
