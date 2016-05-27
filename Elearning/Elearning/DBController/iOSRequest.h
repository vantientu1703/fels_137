
#import <Foundation/Foundation.h>
typedef void(^RequestCompletionHandler)(NSString*,NSError*);
typedef void(^RequestDictionaryCompletionHandler)(NSDictionary*);

@interface iOSRequest : NSObject

+(void)requestPath:(NSString *)path
        withMethod:(NSString*) method
         parameter:(NSString*) parameter
      onCompletion:(RequestCompletionHandler)complete;

+ (void) getDataRequestWithPath:(NSString*) path withMethod:(NSString*) method parameter:(NSString*)parameter onCoplete:(RequestDictionaryCompletionHandler) complete;
@end
