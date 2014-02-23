//
//  NetworkManager.m
//  blackjack
//
//  Created by sheady on 2/22/14.
//
//

#import "NetworkManager.h"
#import "SocketIOPacket.h"

@implementation NetworkManager

-(id)init
{
    self = [super init];
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:@"192.168.8.104" onPort:8080];
    return self;
}

- (void)hit
{
    [socketIO sendMessage:@"hit"];
}

- (void)stand
{
    [socketIO sendMessage:@"stand"];
}

- (void)reset
{
    [socketIO sendMessage:@"reset"];
}

- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveEvent()");
    
    if ([packet.name isEqualToString:@"connected"])
    {
        NSDictionary *d = [packet.args objectAtIndex:0];
        self.identification = [[d objectForKey:@"id"] integerValue];
    }
    else if ([packet.name isEqualToString:@"error"])
    {
        
    }
    else if ([packet.name isEqualToString:@"startTurn"])
    {
        NSDictionary *d = [packet.args objectAtIndex:0];
        NSInteger i = [[d objectForKey:@"id"] integerValue];
        
        switch (i) {
            case 0:
                [self.delegate turnDidChange:0];
                break;
            case 1:
                if (self.identification == 1)
                    [self.delegate turnDidChange:2];
                else
                    [self.delegate turnDidChange:1];
                break;
            case 2:
                if (self.identification == 1)
                    [self.delegate turnDidChange:1];
                else
                    [self.delegate turnDidChange:2];
                break;
        }
    }
    else if ([packet.name isEqualToString:@"hit"])
    {
        NSDictionary *args = [packet.args objectAtIndex:0];
//        NSDictionary *iden = [packet.args objectAtIndex:0];
//        NSDictionary *su = [packet.args objectAtIndex:1];
//        NSDictionary *val = [packet.args objectAtIndex:2];
        NSInteger i = [[args valueForKey:@"id"] integerValue];
        NSInteger suit = [[args valueForKey:@"suit"] integerValue];
        NSInteger value = [[args valueForKey:@"value"] integerValue];
        
        switch (i) {
            case 0:
                [self.delegate cardDidArrive:0 :suit :value];
                break;
            case 1:
                if (self.identification == 1)
                    [self.delegate cardDidArrive:2 :suit :value];
                else
                    [self.delegate cardDidArrive:1 :suit :value];
                break;
            case 2:
                if (self.identification == 1)
                    [self.delegate cardDidArrive:1 :suit :value];
                else
                   [self.delegate cardDidArrive:2 :suit :value];
                break;
        }
    }
    else if ([packet.name isEqualToString:@"turnOver"])
    {
        [self.delegate turnDidEnd];
    }
    else if ([packet.name isEqualToString:@"gameOver"])
    {
        NSDictionary *d = [packet.args objectAtIndex:0];
        NSInteger i = [[d objectForKey:@"id"] integerValue];
        
        switch (i) {
            case 0:
                [self.delegate gameDidEnd:0];
                break;
            case 1:
                if (self.identification == 1)
                    [self.delegate gameDidEnd:2];
                else
                    [self.delegate gameDidEnd:1];
                break;
            case 2:
                if (self.identification == 1)
                    [self.delegate gameDidEnd:1];
                else
                    [self.delegate gameDidEnd:2];
                break;
        }
    }
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error
{
    NSLog(@"onError() %@", error);
}

- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    NSLog(@"socket.io disconnected. did error occur? %@", error);
}
@end
