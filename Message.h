//
//  Message.h
//  SmsgateDelivery
//
//  Created by Jacob Rhoden on 26/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Message : NSObject {
	int uid;
	int accountUid;
	NSString* source;
	NSString* destination;
	NSString* text;
	double cost;
}

@property int uid;
@property int accountUid;
@property (retain) NSString* source;
@property (retain) NSString* destination;
@property (retain) NSString* text;
@property double cost;

@end
