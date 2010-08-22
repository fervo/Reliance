//
//  RLConvenienceConstructedServiceProvider.m
//  Reliance
//
//  Created by Magnus Nordlander on 2010-08-22.
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

#import "RLConvenienceConstructedServiceProvider.h"

#import "RLAbstractServiceProvider+PrivateAdditions.h"

@implementation RLConvenienceConstructedServiceProvider
@synthesize convenienceConstructor;

-(NSInvocation*)factoryInvocation
{
  NSMethodSignature* signature = [self.providerClass methodSignatureForSelector:self.convenienceConstructor];
  NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
  
  [invocation setSelector:self.convenienceConstructor];
  
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
  
  id providerInstance;
  
  NSInvocation* invocation = [self factoryInvocation];
  
  [self setArgs:resolvedDependencies onInvocation:invocation];
  
  [invocation setTarget:[providerClass class]];
  [invocation invoke];
  [invocation getReturnValue:&providerInstance];
  
  [instanceCache setObject:providerInstance forKey:resolvedDependencies];
  
  return providerInstance;
}
@end
