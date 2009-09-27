#import "MessageProcessor.h"
#import "UrlDownloader.h"

@implementation MessageProcessor

- (void) deliverMessage {
	NSLog(@"deliverMessage: Attempting to deliver message to %@", [message destination]);
	[UrlDownloader get: @"http://jacobrhoden.com/" responder: self];
}

-(void) urlResponse: (NSString*) response {
	[db markMessageDelivered: message];
	NSLog(@"urlResponse: Delivered message to %@", [message destination]);
	[message release];
	message = nil;
	[self processMessage];
}

-(void) urlFailed: (NSString*) error {
	[db markMessageRescheduled: message];
	NSLog(@"urlFailed: Message to %@ not delivered. Rescheduling.", [message destination]);
	[message release];
	message = nil;
	[self processMessage];
}

- (void) process {
	if(db==nil) {
		db = [[DataStore alloc] init];
		[db setDatabase: @"smsgate"];		
	}

	while(![db connectTo: @"localhost" asUser: @"smsgate" withPassword: @"smsgate"])
		sleep(1);

	rescheduleTime = time(NULL)+30;

	[self processMessage];
	
	//[db disconnect];
	//[db release];
}

- (void) processMessage {

	do {
		message = [db findAndLockNextMessage];

		if(message == nil) {
			usleep(500000);
			// Is message nil because an error occured?
			if([db errorNumber] == 2006)
				break;
			
			// If no error occured, no messages to deliver, lets try to resend
			// any messages that are somehow blocked.
			if(time(NULL) >= rescheduleTime) {
				[db rescheduleMessages];
				rescheduleTime = time(NULL) + 30;
			}
		}
		
	} while(message == nil);
	
	if([db errorNumber] == 2006)
		[self process];
	else {
		[message retain];
		[self deliverMessage];		
	}

}

@end
