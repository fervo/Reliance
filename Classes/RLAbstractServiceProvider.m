//
//  RLAbstractServiceProvider.m
//  Reliance
//
//  Created by Magnus Nordlander on 2010-08-22.
//  Copyright 2010 Smiling Plants HB. All rights reserved.
//

#import "RLAbstractServiceProvider.h"

#import "RLAbstractServiceProvider+PrivateAdditions.h"

@implementation RLAbstractServiceProvider

@synthesize providerClass, dependencies;

- (id) init
{
  self = [super init];
  if (self != nil) {
    instanceCache = [[NSMutableDictionary alloc] initWithCapacity:5];
  }
  return self;
}

- (void) dealloc
{
  [instanceCache release];
  [super dealloc];
}

-(id)cachedInstanceForResolvedDependencies:(NSArray*)resolvedDependencies
{
  return [instanceCache objectForKey:resolvedDependencies];
}

-(void)sanityCheckResolvedDependencies:(NSArray*)resolvedDependencies
{
  if ([resolvedDependencies count] != [self.dependencies count])
  {
    @throw [NSException exceptionWithName:@"Invalid resolution" reason:@"The supplied resolved dependencies do not fulfill the dependencies of the service provider." userInfo:nil];
  }
}

-(void)setArgs:(NSArray*)args onInvocation:(NSInvocation*)invocation
{
  NSInteger argumentIndex = 2;
  for (id service in args) {
    [invocation setArgument:&service atIndex:argumentIndex++];
  }
}

-(id)instantiateProviderWithResolvedDependencies:(NSArray*)resolvedDependencies
{
  [NSException raise:NSInternalInconsistencyException 
              format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
  return nil;
}

@end
