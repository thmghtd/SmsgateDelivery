#import <Foundation/Foundation.h>
#import "Test.h"

int main (int argc, const char * argv[]) 
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	NSLog(@"Hello World!");

	Test* test = [[Test alloc] init];
	[test setup];
	[test query];
	[test cleanup];
	[test release];

	[pool release];
}

