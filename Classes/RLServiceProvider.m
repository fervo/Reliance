//
//  RLServiceProvider.m
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

#import "RLServiceProvider.h"

@interface RLServiceProvider (PrivateAdditions)
-(id)cachedInstanceForResolvedDependencies:(NSArray*)resolvedDependencies;
-(void)sanityCheckResolvedDependencies:(NSArray*)resolvedDependencies;
-(NSInvocation*)initializerInvocationWithArgs:(NSArray*)args;
@end

@implementation RLServiceProvider
@synthesize providerClass, initializer, dependencies;

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

-(NSInvocation*)initializerInvocationWithArgs:(NSArray*)args
{
  NSMethodSignature* signature = [self.providerClass instanceMethodSignatureForSelector:self.initializer];
  NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
  
  [invocation setSelector:self.initializer];
  
  NSInteger argumentIndex = 2;
  for (id service in args) {
    [invocation setArgument:&service atIndex:argumentIndex++];
  }
  
  return invocation;
}

-(id)instantiateProviderWithResolvedDependencies:(NSArray*)resolvedDependencies
{
  id cachedProvider;
  
  if ((cachedProvider = [self cachedInstanceForResolvedDependencies:resolvedDependencies]) != nil)
  {
    return cachedProvider;
  }
  
  [self sanityCheckResolvedDependencies:resolvedDependencies];
  
  id providerInstance = [providerClass alloc];
  
  NSInvocation* invocation = [self initializerInvocationWithArgs:resolvedDependencies];

  [invocation setTarget:providerInstance];
  [invocation invoke];
  [invocation getReturnValue:&providerInstance];

  [instanceCache setObject:providerInstance forKey:resolvedDependencies];
  
  return [providerInstance autorelease];
}
@end
