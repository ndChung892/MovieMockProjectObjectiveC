//
//  Configuration.m
//  MockProjectObjectiveC
//
//  Created by Chung on 28/06/2023.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject

@end

@implementation Configuration

NSString *const baseURL = @"https://api.themoviedb.org/3/movie/popular";
NSString *const imageURL = @"https://image.tmdb.org/t/p/original/";

@end
