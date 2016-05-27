#import "iOSRequest.h"
@implementation iOSRequest

+(void)requestPath:(NSString *)path withMethod:(NSString*) method parameter:(NSString*) parameter  onCompletion:(RequestCompletionHandler)complete
{
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] init];
    NSString *post;
    if ([method isEqualToString:@"GET"]) {
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",path,parameter]]];
        post = @"";
    } else {
        [request setURL:[NSURL URLWithString:path]];
        post = parameter;
    }
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    request.HTTPMethod = method;
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = postData;
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    
                    NSError *errorr;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errorr];
                    if (complete) complete(result,error);
                }] resume];
}

+ (void) getDataRequestWithPath:(NSString*) path withMethod:(NSString*) method parameter:(NSString*)parameter onCoplete:(RequestDictionaryCompletionHandler) complete {
    [iOSRequest requestPath:path withMethod:method parameter:parameter onCompletion:^(NSString *result, NSError *error)
    {
        if (error || [result isEqualToString:@""]) {
            if (complete) complete(nil);
        } else {
            NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dataJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (complete) complete(dataJson);
        }
    }];
}
@end
