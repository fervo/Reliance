//
//  TestServiceParser.m
//  Reliance
//
//  Created by Magnus Nordlander on 2010-08-21.
//  Copyright 2010 Smiling Plants HB. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import <Reliance/RLServiceParser.h>
#import <Reliance/RLServiceProvider.h>
#import <Reliance/RLContainer.h>
#import "TestProtocol.h"
#import "TestProvider.h"

@interface TestServiceParser : SenTestCase {
  
}

@end

@implementation TestServiceParser

-(void)testParse
{
  RLServiceParser* parser = [[RLServiceParser alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[TestServiceParser class]] pathForResource:@"TestContainerDescription" ofType:@"plist"]];
  
  id container = [OCMockObject mockForClass:[RLContainer class]];
  
  [[container expect] addServiceWithDescription:[OCMArg checkWithBlock:^(id serviceDescription) {
    return (BOOL)([[serviceDescription serviceName] isEqualToString:@"testService"] && ([serviceDescription requiredProtocol] == @protocol(TestProtocol)));
  }]];
  [[container expect] addServiceWithDescription:[OCMArg checkWithBlock:^(id serviceDescription) {
    return (BOOL)([[serviceDescription serviceName] isEqualToString:@"fooService"] && ([serviceDescription requiredProtocol] == nil));
  }]];
  
  [[container expect] setProvider:[OCMArg checkWithBlock:^(id provider) {
    return (BOOL)(([provider providerClass] == [TestProvider class]) && ([provider initializer] == @selector(initWithFooService:)) && [[provider dependencies] isEqual:[NSArray arrayWithObject:@"fooService"]]);
  }] forService:@"testService"];
  
  [parser parseIntoContainer:container];
  
  [container verify];
  
  [parser release];
}

@end
