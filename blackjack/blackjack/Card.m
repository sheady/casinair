//
//  Card.m
//  blackjack
//
//  Created by sheady on 2/22/14.
//
//

#import "Card.h"

@interface Card ()

@property int suit;
@property int num;
@property (strong, nonatomic) UILabel *cardNum;

@end

@implementation Card

- (id)initWithSuit:(int)suit Num:(int)num origin:(CGPoint)origin
{
    self.suit = suit;
    self.num = num;
    self.cardView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, 100, 150)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 150)];
    switch (suit) {
        case kSpade:
            [image setImage:[UIImage imageNamed:@"spade"]];
            break;
        case kClub:
            [image setImage:[UIImage imageNamed:@"club"]];
            break;
        case kHeart:
            [image setImage:[UIImage imageNamed:@"heart"]];
            break;
        case kDiamond:
            [image setImage:[UIImage imageNamed:@"diamond"]];
            break;
        default:
            break;
    }
    [self.cardView addSubview:image];
    self.cardNum = [[UILabel alloc] initWithFrame:CGRectMake(6, 6, 30, 30)];
    switch (num) {
        case 1:
            self.cardNum.text = @"A";
            break;
        case 11:
            self.cardNum.text = @"J";
            break;
        case 12:
            self.cardNum.text = @"Q";
            break;
        case 13:
            self.cardNum.text = @"K";
            break;
            
        default:
            self.cardNum.text = [NSString stringWithFormat:@"%i", num];
            break;
    }
    [self.cardNum setBackgroundColor:[UIColor clearColor]];
    [self.cardNum setTextColor:[UIColor blackColor]];
    [self.cardNum setFont:[UIFont boldSystemFontOfSize:20]];
    [self.cardView addSubview:self.cardNum];
    
    self.shown = NO;
    
    return self;
}

@end
