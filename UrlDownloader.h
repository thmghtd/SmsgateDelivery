/*
 * Copyright (c)2009. Uptecs. All rights reserved.
 */
#import <Foundation/Foundation.h>

@protocol UrlDownloaderResponse
-(void) urlResponse: (NSString*) response;
-(void) urlFailed: (NSString*) error;
@end


@interface UrlDownloader : NSObject {
	NSMutableData *responseData;
	NSURL *baseURL;
	id responder;
}

+(void) get: (NSString*) url responder:(id) responderObject;

+(void) post: (NSString*) url
   responder: (id) responderObject
	  values: (NSMutableDictionary*) values;

-(void) loadPage: (NSString*) url
	   responder: (id) responderObject;

-(void) postPage: (NSString*) url
	   responder: (id) responderObject
		  values: (NSMutableDictionary*) values;

@end
