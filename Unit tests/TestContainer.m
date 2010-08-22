//
//  TestContainer.m
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

#import "TestContainer.h"


@implementation TestContainer

-(void)testAddService
{
  RLContainer* container = [[RLContainer alloc] init];
      
  id serviceDescription = [OCMockObject mockForClass:[RLServiceDescription class]];
  
  [[[serviceDescription stub] andReturn:@"addedService"] serviceName];  
  
  [container addServiceWithDescription:serviceDescription];
  
  STAssertTrue([container hasService:@"addedService"], @"Expected service 'addedService' does not exist");
  STAssertFalse([container hasService:@"otherService"], @"Unexpected service 'otherService' exists");
  
  [serviceDescription verify];
  
  [container release];
}

-(void)testAddProvider
{
  RLContainer* container = [[RLContainer alloc] init];
  
  [container addServiceWithDescription:[self fooService]];
  
  id serviceDescription = [OCMockObject mockForClass:[RLServiceDescription class]];
  
  [[[serviceDescription stub] andReturn:@"testService"] serviceName];
  [[[serviceDescription stub] andReturn:@protocol(TestProtocol)] requiredProtocol];
  
  [container addServiceWithDescription:serviceDescription];
  
  id unconformingProvider = [OCMockObject mockForClass:[RLInitializedServiceProvider class]];
  
  [[[serviceDescription stub] andThrow:[NSException exceptionWithName:@"E1" reason:@"E1" userInfo:nil]] validateProvider:unconformingProvider];

  STAssertThrows([container setProvider:unconformingProvider forService:@"testService"], @"Container doesn't throw when attempting to set an unconforming provider");

  id provider = [OCMockObject mockForClass:[RLInitializedServiceProvider class]];

  [[serviceDescription stub] validateProvider:provider];
  
  [container setProvider:provider forService:@"testService"];
  
  STAssertThrows([container setProvider:provider forService:@"barService"], @"Container doesn't throw when attempting to set provider for unknown barService");
  
  STAssertTrue([container hasProviderForService:@"testService"], @"Container claims not to have a provider for testService");
  STAssertFalse([container hasProviderForService:@"fooService"], @"Container claims to have a provider for fooService");
  STAssertThrows([container hasProviderForService:@"barService"], @"Container doesn't throw when asked for unknown barService");
  
  [container release];
}

-(void)testGetService
{
  RLContainer* container = [[RLContainer alloc] init];
  
  [container addServiceWithDescription:[self fooService]];
  
  STAssertThrows([container service:@"fooService"], @"Container doesn't throw when asked for fooService without provider");  
  
  [container setProvider:[self fooProvider] forService:@"fooService"];
  
  id serviceDescription = [OCMockObject mockForClass:[RLServiceDescription class]];
  
  [[[serviceDescription stub] andReturn:@"testService"] serviceName];
  [[[serviceDescription stub] andReturn:@protocol(TestProtocol)] requiredProtocol];
  [[serviceDescription stub] validateProvider:[OCMArg any]];
  
  [container addServiceWithDescription:serviceDescription];
  
  id provider = [OCMockObject mockForClass:[RLInitializedServiceProvider class]];
  [[[provider stub] andReturn:[[[TestProvider alloc] initWithFoo:nil] autorelease]] instantiateProviderWithResolvedDependencies:[OCMArg any]];
  [[[provider stub] andReturn:[NSArray array]] dependencies];
  
  [container setProvider:provider forService:@"testService"];
  
  STAssertTrue([[container service:@"fooService"] isMemberOfClass:[NSObject class]], @"fooService isn't an NSObject");
  STAssertTrue([[container service:@"testService"] isMemberOfClass:[TestProvider class]], @"testService isn't a TestProvider");
  STAssertThrows([container hasProviderForService:@"barService"], @"Container doesn't throw when asked for unknown barService");

  [container release];
}

-(id)fooService
{
  id serviceDescription = [OCMockObject mockForClass:[RLServiceDescription class]];

  [[[serviceDescription stub] andReturn:@"fooService"] serviceName];
  [[[serviceDescription stub] andReturn:@protocol(NSObject)] requiredProtocol];
  [[serviceDescription stub] validateProvider:[OCMArg any]];

  
  return serviceDescription;
}

-(id)fooProvider
{
  id provider = [OCMockObject mockForClass:[RLInitializedServiceProvider class]];
    
  [[[provider stub] andReturn:[[[NSObject alloc] init] autorelease]] instantiateProviderWithResolvedDependencies:[OCMArg any]];
  [[[provider stub] andReturn:[NSArray array]] dependencies];
  
  return provider;
}

@end
