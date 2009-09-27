#import "Message.h"


@implementation Message

-(int) uid {
	return uid;
}

-(int) accountUid {
	return accountUid;
}

-(NSString*) source {
	return source;
}

-(NSString*) destination {
	return destination;
}

-(NSString*) text {
	return text;
}

-(double) cost {
	return cost;
}


-(void) setUid: (int) aUid {
	uid = aUid;
}

-(void) setAccountUid: (int) aAccountUid {
	accountUid = aAccountUid;
}

-(void) setSource: (NSString*) aSource {
	source = aSource;
}

-(void) setDestination: (NSString*) aDestination {
	destination = aDestination;
}

-(void) setText: (NSString*) aText {
	text = aText;
}

-(void) setCost: (double) aCost {
	cost = aCost;
}

@end
