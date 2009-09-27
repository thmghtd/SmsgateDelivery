
@interface Message : NSObject {
	int uid;
	int accountUid;
	NSString* source;
	NSString* destination;
	NSString* text;
	double cost;
}

-(int) uid;
-(int) accountUid;
-(NSString*) source;
-(NSString*) destination;
-(NSString*) text;
-(double) cost;

-(void) setUid: (int) aUid;
-(void) setAccountUid: (int) aAccountUid;
-(void) setSource: (NSString*) aSource;
-(void) setDestination: (NSString*) aDestination;
-(void) setText: (NSString*) aText;
-(void) setCost: (double) aCost;

@end
