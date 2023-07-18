//
//  Favorites+CoreDataProperties.h
//  MockProjectObjectiveC
//
//  Created by Chung on 13/07/2023.
//
//

#import "Favorites+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Favorites (CoreDataProperties)

+ (NSFetchRequest<Favorites *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nonatomic) int64_t iD;
@property (nullable, nonatomic, copy) NSString *imgUrl;
@property (nullable, nonatomic, copy) NSString *overview;
@property (nonatomic) float rating;
@property (nullable, nonatomic, copy) NSString *releaseDate;
@property (nullable, nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
