#import <Foundation/Foundation.h>
#import "Test.h"
#import <mysql/mysql.h>

@implementation Test

- (void) setup {
	NSLog(@"Connecting");
	mysql_init(&db);
	if (!mysql_real_connect(&db, "localhost", "smstest", "smstest55", "smstest", 0, NULL, 0)) { 
		fprintf(stderr, "%s\n", mysql_error(&db)); 
		return;
	} 
}

- (void) cleanup {
	NSLog(@"Disconnecting");
	mysql_close(&db);
}

- (void) query {
	NSLog(@"Test query");

	if (mysql_query(&db, "SELECT name, description FROM word LIMIT 100")) { 
		fprintf(stderr, "%s\n", mysql_error(&db)); 
		exit(0); 
	} 

	MYSQL_RES *res = mysql_use_result(&db); 

	MYSQL_ROW row; 
	while ((row = mysql_fetch_row(res)) != NULL) 
		printf("%s %s\n", row[0], row[1]); 

	mysql_free_result(res); 
}
@end
