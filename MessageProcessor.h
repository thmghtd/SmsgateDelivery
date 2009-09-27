//
//  MessageProcessor.h
//  SmsgateDelivery
//
//  Created by Jacob Rhoden on 27/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DataStore.h"
#import "Message.h"
#import "UrlDownloader.h"

@interface MessageProcessor : NSObject<UrlDownloaderResponse> {
	DataStore* db;
	Message* message;
	int rescheduleTime;
}

- (void) process;
- (void) deliverMessage;
- (void) processMessage;

@end
