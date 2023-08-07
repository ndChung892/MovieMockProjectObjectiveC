//
//  NetworkManager.h
//  MockProjectObjectiveC
//
//  Created by Chung on 27/06/2023.
//

#ifndef NetworkManager_h
#define NetworkManager_h

#endif /* NetworkManager_h */

@interface NetworkManager : NSObject

+ (instancetype)sharedInstance;
- (void)fetchMovieAPI:(int) pageNumber
             withPath:(NSString *) path
       withCompletion:(void (^)(NSDictionary *response))completion;
- (void)fetchDetailMovieAPI:(NSNumber *)iD
             withCompletion:(void (^)(NSDictionary *response))completion;
- (void)fetchCastAndCrew:(NSNumber *)iD
          withCompletion:(void (^)(NSDictionary *response))completion;

@end

