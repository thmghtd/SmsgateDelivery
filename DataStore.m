#import "DataStore.h"

@implementation DataStore

- (void) setDatabase: (NSString*) aDatabase {
	database = aDatabase;
}

- (BOOL) connectTo: (NSString*) hostname asUser: (NSString*) username withPassword: (NSString*) password {
	NSLog(@"Connecting to %@@%@ as %@",database,hostname,username);
	db = mysql_init(NULL);
	if (!mysql_real_connect(db, [hostname cStringUsingEncoding: NSUTF8StringEncoding],
							[username cStringUsingEncoding: NSUTF8StringEncoding],
							[password cStringUsingEncoding: NSUTF8StringEncoding],
							[database cStringUsingEncoding: NSUTF8StringEncoding], 0, NULL, 0)) { 
		NSLog(@"Connection failed: %s\n", mysql_error(db)); 
		return NO;
	} 
	
	NSLog(@"Connected");
	[self deliverySetup];
	return YES;
}

- (Message*) findAndLockNextMessage {
	Message* message = nil;
	errorNumber=0;
	
	if (mysql_query(db, "SELECT id, source, destination, message, account_id, cost FROM message WHERE status = 0 limit 1")) { 
		NSLog(@"findAndLockNextMessage: %d %s\n", mysql_errno(db), mysql_error(db)); 
		errorNumber = mysql_errno(db);
		return nil; 
	} 
	
	MYSQL_RES *res = mysql_use_result(db); 

	MYSQL_ROW row; 
	if ((row = mysql_fetch_row(res)) == NULL) {
		mysql_free_result(res);
		return nil;
	}
	message = [[Message alloc] init];
	[message setUid: [[NSString stringWithCString: row[0] encoding: NSUTF8StringEncoding] intValue]];
	[message setSource: [NSString stringWithCString:row[1] encoding: NSUTF8StringEncoding]];
	[message setDestination: [NSString stringWithCString:row[2] encoding: NSUTF8StringEncoding]];
	[message setText: [NSString stringWithCString:row[3] encoding: NSUTF8StringEncoding]];
	[message setAccountUid: [[NSString stringWithCString: row[4] encoding: NSUTF8StringEncoding] intValue]];
	[message setCost: [[NSString stringWithCString: row[5] encoding: NSUTF8StringEncoding] doubleValue]];
	mysql_free_result(res);
	
	NSString* update = [NSString stringWithFormat: @"UPDATE message SET status=1 WHERE id=%d", [message uid]];
	mysql_query(db, [update cStringUsingEncoding: NSUTF8StringEncoding]);
	long updates =(long) mysql_affected_rows(db);
	if(updates != 1) {
		NSLog(@"findAndLockNextMessage: Update failed %s\n", mysql_error(db));
		return nil;
	}

	return [message autorelease];
}

- (void) markMessageRescheduled: (Message*) message {
	NSString* update = [NSString stringWithFormat: @"UPDATE message SET status=2 WHERE id=%d", [message uid]];
	mysql_query(db, [update cStringUsingEncoding: NSUTF8StringEncoding]);
	long updates =(long) mysql_affected_rows(db);
	if(updates != 1) {
		NSLog(@"markMessageRescheduled: Update failed: %s\n", mysql_error(db));
		return;
	}
}

- (void) markMessageDelivered: (Message*) message {
	NSString* update = [NSString stringWithFormat: @"DELETE FROM message WHERE id=%d", [message uid]];
	mysql_query(db, [update cStringUsingEncoding: NSUTF8StringEncoding]);
	long updates =(long) mysql_affected_rows(db);
	if(updates != 1) {
		NSLog(@"markMessageDelivered: Delete sent message: %s\n", mysql_error(db));
		return;
	}
	NSString* history = [NSString stringWithFormat: @"insert into history (account_id,source,destination, message,otime,cost) values(%d,'%@','%@','%@',CURRENT_TIMESTAMP,%f)",
						 [message accountUid],
						 [message source],
						 [message destination],
						 [message text],
						 [message cost]];
	mysql_query(db, [history cStringUsingEncoding: NSUTF8StringEncoding]);
	updates =(long) mysql_affected_rows(db);
	if(updates != 1) {
		NSLog(@"markMessageDelivered: Storing message in delivery history: %s\n", mysql_error(db));
		return;
	}
	
}

- (void) rescheduleMessages {
	mysql_query(db, "UPDATE message SET status=0 WHERE status=2");
	long updates =(long) mysql_affected_rows(db);
	if(updates > 0) {
		NSLog(@"rescheduleMessages: Rescheduled %d message(s)\n", updates);
		return;
	}
}

- (void) deliverySetup {
	mysql_query(db, "UPDATE message SET status=0 WHERE status=1");
	long updates =(long) mysql_affected_rows(db);
	if(updates > 0) {
		NSLog(@"deliverySetup: Rescheduling %d message(s) that were discovered to be in-progress on startup. \n", updates);
		return;
	}
}

- (void) disconnect {
	NSLog(@"Disconnecting");
	mysql_close(db);
	NSLog(@"Disconnected");
}

- (NSString*) error {
	return error;
}

- (int) errorNumber {
	return errorNumber;
}

@end
