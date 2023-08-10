//
//  Configuration.h
//  MockProjectObjectiveC
//
//  Created by Chung on 28/06/2023.
//
#import <UIKit/UIKit.h>
#ifndef Configuration_h
#define Configuration_h


#endif /* Configuration_h */


@interface Configuration : NSObject
#pragma mark - api URL
FOUNDATION_EXPORT NSString *const baseURL;
FOUNDATION_EXPORT NSString *const imageURL;
FOUNDATION_EXPORT NSDictionary *parameters;
FOUNDATION_EXPORT NSString *const aboutURL;

@end
