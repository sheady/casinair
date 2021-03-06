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

@property (strong, nonatomic) UIImageView *image;
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
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [self.image setImage:[UIImage imageNamed:@"background"]];
    
    
    self.hit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.hit setFrame:CGRectMake(50, 525, 50, 20)];
    [self.hit setTitle:@"hit" forState:UIControlStateNormal];
    [self.hit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.hit addTarget:self action:@selector(didPressHit) forControlEvents:UIControlEventTouchUpInside];
    [self.hit setEnabled:NO];
    [self.hit setHidden:YES];
    [self.hit setAlpha:0];
    
    self.stand = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.stand setFrame:CGRectMake(200, 525, 50, 20)];
    [self.stand setTitle:@"stand" forState:UIControlStateNormal];
    [self.stand setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.stand addTarget:self action:@selector(didPressStand) forControlEvents:UIControlEventTouchUpInside];
    [self.stand setEnabled:NO];
    [self.stand setHidden:YES];
    [self.stand setAlpha:0];
    
    self.reset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.reset setFrame:CGRectMake(20, 525, 50, 20)];
    [self.reset setTitle:@"reset" forState:UIControlStateNormal];
    [self.reset setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.reset addTarget:self action:@selector(didPressReset) forControlEvents:UIControlEventTouchUpInside];
    [self.reset setEnabled:NO];
    [self.reset setHidden:YES];
    [self.reset setAlpha:0];
    
    self.turnLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 525, 150, 20)];
    [self.turnLabel setTextColor:[UIColor whiteColor]];
    
    self.manager = [[NetworkManager alloc] init];
    self.manager.delegate = self;
    
    [self initializeHands];
}

- (void)initializeHands
{
    [self.view addSubview:self.image];
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
}

- (void)addCardP1Suit:(int)suit Num:(int)num origin:(CGPoint)origin
{
    [self.hand1 addObject:[self createCardSuit:suit Num:num origin:origin]];
    
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
    [self.manager hit];
}

- (void)didPressStand
{
    [self.manager stand];
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
            if ([self.dealer count] == 0) {
                [self addCardDealerSuit:suit Num:num origin:CGPointMake(5, dealerY)];
                Card *card = [self.dealer objectAtIndex:0];
                UIImageView *Iview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
                [card.cardView addSubview:Iview];
                [self updateFieldFor:self.dealer];
            }
            else {
                Card *prev = [self.dealer lastObject];
                [self addCardDealerSuit:suit Num:num origin:CGPointMake(prev.cardView.frame.origin.x + 50, dealerY)];
                [self updateFieldFor:self.dealer];
            }
            break;
        case 1:
            if ([self.hand1 count] == 0) {
                [self addCardP1Suit:suit Num:num origin:CGPointMake(5, hand1Y)];
                Card *card = [self.hand1 objectAtIndex:0];
                UIImageView *Iview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
                [card.cardView addSubview:Iview];
                [self updateFieldFor:self.hand1];
            }
            else {
                Card *prev = [self.hand1 lastObject];
                [self addCardP1Suit:suit Num:num origin:CGPointMake(prev.cardView.frame.origin.x + 50, hand1Y)];
                [self updateFieldFor:self.hand1];
            }
            break;
        case 2:
            if ([self.hand2 count] == 0) {
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
    Card *card = [self.hand1 objectAtIndex:0];
    [[[card.cardView subviews] lastObject] removeFromSuperview];
    Card *card1 = [self.dealer objectAtIndex:0];
    [[[card1.cardView subviews] lastObject] removeFromSuperview];
    switch (winner) {
        case 0:
            [self.turnLabel setText:@"Dealer Won"];
            [self ready2reset];
            break;
        case 1:
            [self.turnLabel setText:@"Player 1 Won"];
            [self ready2reset];
            break;
        case 2:
            [self.turnLabel setText:@"You Won"];
            [self ready2reset];
            break;
    }
}

- (void)ready2reset
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
        [self.turnLabel setText:@""];
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

        [self.manager reset];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
