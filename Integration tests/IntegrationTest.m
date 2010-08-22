//
//  IntegrationTest.m
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

#import "IntegrationTest.h"


@implementation IntegrationTest

-(void)testIntegration
{
  RLContainer* container = [[RLContainer alloc] init];
  
  RLServiceDescription* placeFinderService = [[RLServiceDescription alloc] init];
  placeFinderService.serviceName = @"placeFinderService";
  [container addServiceWithDescription:placeFinderService];
  
  RLServiceDescription* dataContextService = [[RLServiceDescription alloc] init];
  dataContextService.serviceName = @"dataContextService";
  [container addServiceWithDescription:dataContextService];
  
  RLServiceDescription* sqlTransportService = [[RLServiceDescription alloc] init];
  sqlTransportService.serviceName = @"sqlTransportService";
  [container addServiceWithDescription:sqlTransportService];
  
  RLServiceDescription* configurationStoreService = [[RLServiceDescription alloc] init];
  configurationStoreService.serviceName = @"configurationStoreService";
  [container addServiceWithDescription:configurationStoreService];
  
  RLServiceProvider* placeFinderProvider = [[RLServiceProvider alloc] init];
  placeFinderProvider.providerClass = [PlaceFinder class];
  placeFinderProvider.initializer = @selector(initWithDataContext:);
  placeFinderProvider.dependencies = [NSArray arrayWithObject:@"dataContextService"];
  [container setProvider:placeFinderProvider forService:@"placeFinderService"];
  
  RLServiceProvider* dataContextProvider = [[RLServiceProvider alloc] init];
  dataContextProvider.providerClass = [DataContext class];
  dataContextProvider.initializer = @selector(initWithSqlTransport:andConfigurationStore:);
  dataContextProvider.dependencies = [NSArray arrayWithObjects:@"sqlTransportService", @"configurationStoreService", nil];
  [container setProvider:dataContextProvider forService:@"dataContextService"];
  
  RLServiceProvider* sqlTransportProvider = [[RLServiceProvider alloc] init];
  sqlTransportProvider.providerClass = [SqlTransport class];
  sqlTransportProvider.initializer = @selector(initWithConfigurationStore:);
  sqlTransportProvider.dependencies = [NSArray arrayWithObject:@"configurationStoreService"];
  [container setProvider:sqlTransportProvider forService:@"sqlTransportService"];
  
  RLServiceProvider* configurationStoreProvider = [[RLServiceProvider alloc] init];
  configurationStoreProvider.providerClass = [ConfigurationStore class];
  configurationStoreProvider.initializer = @selector(init);
  configurationStoreProvider.dependencies = [NSArray array];
  [container setProvider:configurationStoreProvider forService:@"configurationStoreService"];

  id placeFinder = [container service:@"placeFinderService"];
  
  STAssertNotNil(placeFinder, @"Placefinder is nil");
}

@end
