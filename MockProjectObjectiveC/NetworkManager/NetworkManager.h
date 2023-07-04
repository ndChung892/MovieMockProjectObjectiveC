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

+(instancetype) sharedInstance;
- (void)fetchMovieAPI:(void (^)(NSDictionary *response))completion;

@end

