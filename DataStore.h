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
