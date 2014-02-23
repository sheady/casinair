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
@property (strong, nonatomic) UIButton *reset;
@property (strong, nonatomic) UILabel *turnLabel;
@property (nonatomic) NetworkManager *manager;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dealer = [[NSMutableArray alloc] init];
    self.hand1 = [[NSMutableArray alloc] init];
    self.hand2 = [[NSMutableArray alloc] init];
    
    self.hit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.hit setFrame:CGRectMake(50, 525, 50, 20)];
    [self.hit setTitle:@"hit" forState:UIControlStateNormal];
    [self.hit addTarget:self action:@selector(didPressHit) forControlEvents:UIControlEventTouchUpInside];
    [self.hit setEnabled:NO];
    [self.hit setHidden:YES];
    [self.hit setAlpha:0];
    
    self.stand = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.stand setFrame:CGRectMake(200, 525, 50, 20)];
    [self.stand setTitle:@"stand" forState:UIControlStateNormal];
    [self.stand addTarget:self action:@selector(didPressStand) forControlEvents:UIControlEventTouchUpInside];
    [self.stand setEnabled:NO];
    [self.stand setHidden:YES];
    [self.stand setAlpha:0];
    
    self.reset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.reset setFrame:CGRectMake(135, 525, 50, 20)];
    [self.reset setTitle:@"reset" forState:UIControlStateNormal];
    [self.reset addTarget:self action:@selector(didPressReset) forControlEvents:UIControlEventTouchUpInside];
    [self.reset setEnabled:NO];
    [self.reset setHidden:YES];
    [self.reset setAlpha:0];
    
    self.turnLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 525, 50, 20)];
    
    self.manager = [[NetworkManager alloc] init];
    self.manager.delegate = self;
    
    [self initializeHands];
}

- (void)initializeHands
{
    [self.view addSubview:self.hit];
    [self.view addSubview:self.stand];
    [self.view addSubview:self.reset];
    [self.view addSubview:self.turnLabel];
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

- (void)didPressStand
{
    
}

- (void)turnDidChange:(int)player
{
    switch (player) {
        case 0:
            [self.turnLabel setText:@"Dealer's Turn"];
            break;
        case 1:
            [self.turnLabel setText:@"Player 1's Turn"];
            break;
        case 2:
            [UIView animateWithDuration:.5 animations:^{
                [self.hit setEnabled:YES];
                [self.hit setHidden:NO];
                [self.hit setAlpha:1];
                [self.stand setEnabled:YES];
                [self.stand setHidden:NO];
                [self.stand setAlpha:1];
            }];
            break;
    }
}

- (void)cardDidArrive:(int)player :(int)suit :(int)num
{
    switch (player) {
        case 0:
            if ([self.dealer objectAtIndex:0] != nil) {
                [self addCardDealerSuit:suit Num:num origin:CGPointMake(5, dealerY)];
            }
            else {
                Card *prev = [self.dealer lastObject];
                [self addCardDealerSuit:suit Num:num origin:CGPointMake(prev.cardView.frame.origin.x + 50, dealerY)];
            }
            break;
        case 1:
            if ([self.hand1 objectAtIndex:0] != nil) {
                [self addCardP1Suit:suit Num:num origin:CGPointMake(5, hand1Y)];
            }
            else {
                Card *prev = [self.hand1 lastObject];
                [self addCardP1Suit:suit Num:num origin:CGPointMake(prev.cardView.frame.origin.x + 50, hand1Y)];
            }
            break;
        case 2:
            if ([self.hand2 objectAtIndex:0] != nil) {
                [self addCardP2Suit:suit Num:num origin:CGPointMake(5, hand2Y)];
            }
            else {
                Card *prev = [self.hand2 lastObject];
                [self addCardP2Suit:suit Num:num origin:CGPointMake(prev.cardView.frame.origin.x + 50, hand2Y)];
            }
            break;
    }
}

- (void)turnDidEnd
{
    [self.turnLabel setText:@""];
    [UIView animateWithDuration:.5 animations:^{
        [self.hit setAlpha:0];
        [self.stand setAlpha:0];
    }completion:^(BOOL finished) {
        [self.hit setEnabled:NO];
        [self.hit setHidden:YES];
        [self.stand setEnabled:NO];
        [self.stand setHidden:YES];
    }];
}

- (void)gameDidEnd:(int)winner
{
    switch (winner) {
        case 0:
            [self.turnLabel setText:@"Dealer Won"];
            [self reset];
            break;
        case 1:
            [self.turnLabel setText:@"Player 1 Won"];
            [self reset];
            break;
        case 2:
            [self.turnLabel setText:@"You Won"];
            [self reset];
            break;
    }
}

- (void)reset
{
    [UIView animateWithDuration:.5 animations:^{
        [self.reset setEnabled:YES];
        [self.reset setHidden:NO];
        [self.reset setAlpha:1];
    }];
}
         
- (void)didPressReset
{
    [UIView animateWithDuration:.5 animations:^{
        [self.reset setAlpha:0];
    }completion:^(BOOL finished) {
        [self.reset setEnabled:NO];
        [self.reset setHidden:YES];
        for (UIView *view in [self.view subviews]) {
            [view removeFromSuperview];
        }
        [self.dealer removeAllObjects];
        [self.hand1 removeAllObjects];
        [self.hand2 removeAllObjects];
        [self initializeHands];
    }];
}

@end
