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

+ (instancetype)sharedInstance {
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Fetch Popular movie
- (void)fetchMovieAPI:(int) pageNumber
             withPath:(NSString *) path
       withCompletion:(void (^)(NSDictionary *response))completion {
    NSString *url = [NSString stringWithFormat:@"%@%@", baseURL, path];
    NSNumber *page = [NSNumber numberWithInt:pageNumber];
    
    NSMutableDictionary *param = [parameters mutableCopy];
    [param setObject:page forKey:@"page"];

    NSDictionary *updatedParameters = [param copy];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url
      parameters:updatedParameters
         headers:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject);
        
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - Fetch Detail of movie
- (void)fetchDetailMovieAPI:(NSNumber *)iD
             withCompletion:(void (^)(NSDictionary *response))completion {
    NSString *urlDetail = [NSString stringWithFormat:@"%@%@", baseURL, iD];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlDetail
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

#pragma mark - Fetch cast and crew
- (void)fetchCastAndCrew:(NSNumber *)iD
        
          withCompletion:(void (^)(NSDictionary *response))completion {
    NSString *urlDetail = [NSString stringWithFormat:@"%@%@/credits", baseURL, iD];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlDetail
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
