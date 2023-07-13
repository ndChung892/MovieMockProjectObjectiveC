//
//  Favorites+CoreDataProperties.m
//  MockProjectObjectiveC
//
//  Created by Chung on 12/07/2023.
//
//

#import "Favorites+CoreDataProperties.h"

@implementation Favorites (CoreDataProperties)

+ (NSFetchRequest<Favorites *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Favorites"];
}

@dynamic id;
@dynamic title;
@dynamic releaseDate;
@dynamic rating;
@dynamic overview;
@dynamic imgUrl;

@end
