//
//  DataContext.m
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

#import "DataContext.h"


@implementation DataContext

-(id)initWithSqlTransport:(SqlTransport*)sqlTransport andConfigurationStore:(ConfigurationStore*)configurationStore
{
  NSAssert(sqlTransport != nil, @"Sql transport is nil");
  NSAssert(configurationStore != nil, @"Configuration store is nil");
  
  NSAssert([sqlTransport isMemberOfClass:[SqlTransport class]], @"Sql transport is of wrong class");
  NSAssert([configurationStore isMemberOfClass:[ConfigurationStore class]], @"Configuration store is of wrong class");  
  return [self init];
}

@end
