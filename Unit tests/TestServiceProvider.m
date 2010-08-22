//
//  TestServiceProvider.h
//  Reliance
//
//  Created by Magnus Nordlander on 2010-08-18.
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

#import <SenTestingKit/SenTestingKit.h>
#import <Reliance/RLInitializedServiceProvider.h>
#import <Reliance/RLConvenienceConstructedServiceProvider.h>
#import "TestProvider.h"

@interface TestServiceProvider : SenTestCase {
  
}

@end

@implementation TestServiceProvider
-(void)testInstantiate
{
  RLInitializedServiceProvider* providerDescription = [[RLInitializedServiceProvider alloc] init];
  providerDescription.providerClass = [TestProvider class];
  providerDescription.initializer = @selector(initWithFoo:);
  providerDescription.dependencies = [NSArray arrayWithObject:@"fooService"];
  
  NSObject* fooService = [[[NSObject alloc] init] autorelease];
  
  STAssertThrows([providerDescription instantiateProviderWithResolvedDependencies:[NSArray array]], @"Didn't throw on invalid dependency count");
  
  //  STAssertThrows([providerDescription instantiateProviderWithResolvedDependencies:[NSArray arrayWithObjects:fooService, @"Dummy", nil]], @"Didn't throw on invalid dependency count");
  
  id provider = [providerDescription instantiateProviderWithResolvedDependencies:[NSArray arrayWithObject:fooService]];
  STAssertTrue([provider isMemberOfClass:[TestProvider class]], @"Instantiated object is of wrong class");
  STAssertFalse([provider isMemberOfClass:[NSArray class]], @"Instantiated object is of wrong class");
  
  [providerDescription release];
}

-(void)testInstantiateFromConvenienceConstructor
{
  RLConvenienceConstructedServiceProvider* providerDescription = [[RLConvenienceConstructedServiceProvider alloc] init];
  providerDescription.providerClass = [TestProvider class];
  providerDescription.convenienceConstructor = @selector(providerWithFoo:);
  providerDescription.dependencies = [NSArray arrayWithObject:@"fooService"];
  
  NSObject* fooService = [[[NSObject alloc] init] autorelease];
  
  STAssertThrows([providerDescription instantiateProviderWithResolvedDependencies:[NSArray array]], @"Didn't throw on invalid dependency count");
  
  id provider = [providerDescription instantiateProviderWithResolvedDependencies:[NSArray arrayWithObject:fooService]];
  STAssertTrue([provider isMemberOfClass:[TestProvider class]], @"Instantiated object is of wrong class");
  STAssertFalse([provider isMemberOfClass:[NSArray class]], @"Instantiated object is of wrong class");
  
  [providerDescription release];
}

-(void)testInstanceCache
{ 
  RLInitializedServiceProvider* providerDescription = [[RLInitializedServiceProvider alloc] init];
  providerDescription.providerClass = [TestProvider class];
  providerDescription.initializer = @selector(initWithFoo:);
  providerDescription.dependencies = [NSArray arrayWithObject:@"fooService"];
  
  NSObject* fooService = [[[NSObject alloc] init] autorelease];
  
  id firstProvider = [providerDescription instantiateProviderWithResolvedDependencies:[NSArray arrayWithObject:fooService]];
  id secondProvider = [providerDescription instantiateProviderWithResolvedDependencies:[NSArray arrayWithObject:fooService]];
  
  STAssertEqualObjects(firstProvider, secondProvider, @"Different instances returned on separate calls with same args");
}

@end
