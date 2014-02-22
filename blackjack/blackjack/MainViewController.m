//
//  ViewController.m
//  blackjack
//
//  Created by sheady on 2/22/14.
//
//

#import "MainViewController.h"

#define dealerY 20
#define hand1Y 190
#define hand2Y 360

@interface MainViewController ()

@property (strong, nonatomic) NSMutableArray *dealer;
@property (strong, nonatomic) NSMutableArray *hand1;
@property (strong, nonatomic) NSMutableArray *hand2;
@property (strong, nonatomic) UIButton *hit;
@property (strong, nonatomic) UIButton *stand;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dealer = [[NSMutableArray alloc] init];
    self.hand1 = [[NSMutableArray alloc] init];
    self.hand2 = [[NSMutableArray alloc] init];
    
    [self addCardDealerSuit:kClub Num:1 origin:CGPointMake(5, dealerY)];
    [self addCardDealerSuit:kHeart Num:11 origin:CGPointMake(55, dealerY)];
    
    [self addCardP1Suit:kDiamond Num:4 origin:CGPointMake(5, hand1Y)];
    [self addCardP1Suit:kSpade Num:13 origin:CGPointMake(55, hand1Y)];
    
    [self addCardP2Suit:kSpade Num:13 origin:CGPointMake(5, hand2Y)];
    [self addCardP2Suit:kHeart Num:11 origin:CGPointMake(55, hand2Y)];
    
    self.hit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.hit setFrame:CGRectMake(50, 525, 50, 40)];
    [self.hit setTitle:@"hit" forState:UIControlStateNormal];
    [self.hit addTarget:self action:@selector(didPressHit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.hit];
    
    self.stand = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.stand setFrame:CGRectMake(200, 525, 50, 40)];
    [self.stand setTitle:@"stand" forState:UIControlStateNormal];
    [self.view addSubview:self.stand];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (Card *)createCardSuit:(int)suit Num:(int)num origin:(CGPoint)origin
{
    Card *card = [[Card alloc] initWithSuit:suit Num:num origin:origin];
    [card.cardView setAlpha:0];
    return card;
}

- (void)addCardDealerSuit:(int)suit Num:(int)num origin:(CGPoint)origin
{
    [self.dealer addObject:[self createCardSuit:suit Num:num origin:origin]];
    [self updateFieldFor:self.dealer];
}

- (void)addCardP1Suit:(int)suit Num:(int)num origin:(CGPoint)origin
{
    [self.hand1 addObject:[self createCardSuit:suit Num:num origin:origin]];
    [self updateFieldFor:self.hand1];
}

- (void)addCardP2Suit:(int)suit Num:(int)num origin:(CGPoint)origin
{
    [self.hand2 addObject:[self createCardSuit:suit Num:num origin:origin]];
    [self updateFieldFor:self.hand2];
}

- (void)updateFieldFor:(NSArray *)hand
{
    for (Card *card in hand)
    {
        if (!card.shown)
        {
            [self.view addSubview:card.cardView];
            [UIView animateWithDuration:.5 animations:^{
                [card.cardView setAlpha:1];
            }completion:^(BOOL finished) {
                card.shown = YES;
            }];
        }
    }
}

- (void)didPressHit
{
    Card *prev = [self.hand2 lastObject];
    [self addCardP2Suit:kSpade Num:5 origin:CGPointMake(prev.cardView.frame.origin.x + 50, hand2Y)];
}

@end
