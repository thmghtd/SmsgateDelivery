#import <Foundation/Foundation.h>
#import <mysql/mysql.h>

@interface Test : NSObject {
	MYSQL db; 
}

- (void) setup;
- (void) query;
- (void) cleanup;

@end;
