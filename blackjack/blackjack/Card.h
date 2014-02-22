//
//  Card.h
//  blackjack
//
//  Created by sheady on 2/22/14.
//
//

#import <Foundation/Foundation.h>
enum {
    kSpade,
    kClub,
    kHeart,
    kDiamond
};

@interface Card : NSObject

@property BOOL shown;
@property (strong, nonatomic) UIView *cardView;

- (id)initWithSuit:(int)suit Num:(int)num origin:(CGPoint)origin;

@end
