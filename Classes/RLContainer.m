//
//  RLContainer.m
//  Reliance
//
//  Created by Magnus Nordlander on 2010-08-17.
//  Copyright (c) 2010 Smiling Plants HB
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "RLContainer.h"

@interface RLContainer (PrivateAdditions)
- (NSArray*)resolveDependencies:(NSArray*)dependencies;
@end

@implementation RLContainer

- (id) init
{
  self = [super init];
  if (self != nil) {
    serviceDescriptions = [[NSMutableDictionary alloc] init];
    serviceProviders = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void) dealloc
{
  [serviceDescriptions release];
  [serviceProviders release];
  [super dealloc];
}


-(BOOL)hasService:(NSString*)service
{
  return ([serviceDescriptions valueForKey:service] != nil);
}

-(void)addServiceWithDescription:(RLServiceDescription*)serviceDescription
{
  [serviceDescriptions setObject:serviceDescription forKey:[serviceDescription serviceName]];
}

-(void)setProviderDescription:(RLServiceProvider*)providerDescription forService:(NSString*)service
{
  [serviceProviders setObject:providerDescription forKey:service];
}

-(NSArray*)resolveDependencies:(NSArray *)dependencies
{
  NSMutableArray* resolvedDependencies = [NSMutableArray arrayWithCapacity:3];
  for (NSString* dependency in dependencies) 
  {
    [resolvedDependencies addObject:[self service:dependency]];
  }
  return resolvedDependencies;
}

-(id)service:(NSString*)service
{
  RLServiceProvider* providerDescription = [serviceProviders objectForKey:service];
  
  return [providerDescription instantiateProviderWithResolvedDependencies:[self resolveDependencies:providerDescription.dependencies]];
}

-(BOOL)hasProviderForService:(NSString *)service
{
  return ([serviceProviders objectForKey:service] != nil);
}

@end
