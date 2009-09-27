#import <Foundation/Foundation.h>
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
