//
//  NetworkManager.h
//  blackjack
//
//  Created by sheady on 2/22/14.
//
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"

@protocol NetworkManagerProtocol;

@interface NetworkManager : NSObject <SocketIODelegate>
{
    SocketIO *socketIO;
}

@property (nonatomic, weak) id<NetworkManagerProtocol> delegate;

- (id)init;
- (void)hit;
- (void)stand;
- (void)reset;
@end

@protocol NetworkManagerProtocol <NSObject>

@required
- (void)turnDidChange:(int)player;
- (void)cardDidArrive:(int)player :(int)suit :(int)num;
- (void)turnDidEnd;
- (void)gameDidEnd:(int)winner;

@end