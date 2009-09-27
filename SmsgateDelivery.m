#import <Foundation/Foundation.h>
#import "DataStore.h"
#import "MessageProcessor.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];

	MessageProcessor* processor = [[MessageProcessor alloc] init];
	[processor process];
	
	[runLoop run];
	
	[processor release];
	[pool drain];
    return 0;
}
