//
//  NetworkManager.m
//  MockProjectObjectiveC
//
//  Created by Chung on 27/06/2023.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Configuration.h"
#import "SLMoviesViewController.h"
#import "Model.h"

@interface NetworkManager : NSObject

@end

@implementation NetworkManager

+(instancetype) sharedInstance {
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)fetchMovieAPI:(void (^)(NSDictionary *response))completion {
    NSDictionary *parameters = @{@"api_key": @"e7631ffcb8e766993e5ec0c1f4245f93"};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:baseURL
      parameters:parameters
         headers:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject);
        
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
