//
//  DataStore.h
//  SmsgateDelivery
//
//  Created by Jacob Rhoden on 26/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <mysql.h>
#import "Message.h"

@interface DataStore : NSObject {
	MYSQL* db;
	NSString* error;
	NSString* database;
	int errorNumber;
}

@property int errorNumber;

- (void) setDatabase: (NSString*) aDatabase;

- (bool) connectTo: (NSString*) hostname asUser: (NSString*) username withPassword: (NSString*) password;
- (void) disconnect;
- (void) deliverySetup;
- (NSString*) error;

- (Message*) findAndLockNextMessage;
- (void) markMessageRescheduled: (Message*) message;
- (void) markMessageDelivered: (Message*) message;
- (void) rescheduleMessages;



@end
