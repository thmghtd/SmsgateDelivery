/*
 * Copyright (c)2009. Uptecs. All rights reserved.
 */
#import "UrlDownloader.h"

@implementation UrlDownloader

+(void) get: (NSString*) url responder:(id) responderObject {
	UrlDownloader *downloader = [[UrlDownloader alloc] init];
	[downloader loadPage: url responder: responderObject];
}

+(void) post: (NSString*) url responder: (id) responderObject
	  values: (NSMutableDictionary*) values {	
	UrlDownloader *downloader = [[UrlDownloader alloc] init];
	[downloader postPage: url responder: responderObject values: values];
}

-(void) loadPage: (NSString*) url responder:(id) responderObject {
	responder = [responderObject retain];
	responseData = [[NSMutableData data] retain];
	baseURL = [[NSURL URLWithString: url] retain];
	
	NSMutableURLRequest *request =
	[NSMutableURLRequest requestWithURL: baseURL
							cachePolicy: NSURLRequestReloadIgnoringCacheData
						timeoutInterval: 30];
	[request setHTTPShouldHandleCookies: YES];
	NSURLConnection* c = [[NSURLConnection alloc] initWithRequest:request delegate:self];

	if(!c)
		NSLog(@"NSUrlConnection failed");
}

-(void) postPage: (NSString*) url
	   responder: (id) responderObject
		  values: (NSMutableDictionary*) values {	
	responder = [responderObject retain];
	responseData = [[NSMutableData data] retain];
	baseURL = [[NSURL URLWithString: url] retain];
	
	NSString *post = @"";
    NSEnumerator* keyEnum = [values keyEnumerator];
	NSString* key;
    while ((key = [keyEnum nextObject])) {
		if([post length]==0)
			post = [post stringByAppendingFormat: @"%@=%@", key, [values objectForKey: key]];
		else
			post = [post stringByAppendingFormat: @"&%@=%@", key, [values objectForKey: key]];
	}
	NSLog(post);
	NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:url]];
	[request setHTTPShouldHandleCookies: YES];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	return nil;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
			 willSendRequest:(NSURLRequest *)request
			redirectResponse:(NSURLResponse *)redirectResponse {
	[baseURL autorelease];
	baseURL = [[request URL] retain];
	return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//[[NSAlert alertWithError:error] runModal];
	[responder urlFailed: [error localizedDescription]];
	[responder release];
	[self release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	//NSLog(@"Read %d bytes", [responseData length]);
	NSString* stringData = [[NSString alloc] initWithData: responseData encoding:NSUTF8StringEncoding];
	[responder urlResponse: stringData];
	[responder release];
	[self release];
}

- (void)dealloc {
	//NSLog(@"Deallocating UrlDownloader");
	[responseData release];
	[baseURL release];
	[super dealloc];
}

@end
