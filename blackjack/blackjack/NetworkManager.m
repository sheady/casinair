//
//  NetworkManager.m
//  blackjack
//
//  Created by sheady on 2/22/14.
//
//

#import "NetworkManager.h"

@implementation NetworkManager

-(id)init
{
    self = [super init];
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:@"192.168.8.104" onPort:8080];
    return self;
}

- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveEvent()");
    
    SocketIOCallback cb = ^(id argsData) {
        NSDictionary *response = argsData;
        // do something with response
        NSLog(@"ack arrived: %@", response);
    };
    [socketIO sendMessage:@"hello back!" withAcknowledge:cb];
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
