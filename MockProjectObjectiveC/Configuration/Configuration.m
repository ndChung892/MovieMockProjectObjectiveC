//
//  Configuration.m
//  MockProjectObjectiveC
//
//  Created by Chung on 28/06/2023.
//

#import <Foundation/Foundation.h>
#import "Configuration.h"



@implementation Configuration

NSString *const baseURL = @"https://api.themoviedb.org/3/movie/";
NSString *const imageURL = @"https://image.tmdb.org/t/p/original/";
NSDictionary *parameters = @{
    @"api_key": @"e7631ffcb8e766993e5ec0c1f4245f93"
};
NSString *const aboutURL = @"https://www.themoviedb.org/about/our-history";


@end
