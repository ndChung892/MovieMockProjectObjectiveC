//
//  SLMoviesCollectionViewCell.h
//  MockProjectObjectiveC
//
//  Created by Chung on 04/07/2023.
//

#import <UIKit/UIKit.h>
#import "Result.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLMoviesCollectionViewCell : UICollectionViewCell

-(void) configCollectionViewCell:(Result *)result;
@end

NS_ASSUME_NONNULL_END
