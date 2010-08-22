//
//  TestServiceParser.m
//  Reliance
//
//  Created by Magnus Nordlander on 2010-08-21.
//  Copyright 2010 Smiling Plants HB. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "RLServiceParser.h"
#import "RLContainer.h"

@interface TestServiceParser : SenTestCase {
  
}

@end

@implementation TestServiceParser

-(void)testParse
{
  RLServiceParser* parser = [[RLServiceParser alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[TestServiceParser class]] pathForResource:@"TestContainerDescription" ofType:@"plist"]];
  
  id container = [OCMockObject mockForClass:[RLContainer class]];
  
  [[container expect] addServiceWithDescription:[OCMArg any]];
  
  [parser parseIntoContainer:container];
  
  [container verify];
  
  [parser release];
}

@end
