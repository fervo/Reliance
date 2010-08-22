//
//  RLServiceParser.h
//  Reliance
//
//  Created by Magnus Nordlander on 2010-08-21.
//  Copyright 2010 Smiling Plants HB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reliance/RLContainer.h>
#import <Reliance/RLServiceDescription.h>

@interface RLServiceParser : NSObject {
  @private
  NSDictionary* containerDescription;
}
-(id)initWithContentsOfFile:(NSString*)filepath;

-(void)parseIntoContainer:(RLContainer*)container;
@end
