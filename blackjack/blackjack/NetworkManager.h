//
//  NetworkManager.h
//  blackjack
//
//  Created by sheady on 2/22/14.
//
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"

@protocol NetworkManager;

@interface NetworkManager : NSObject <SocketIODelegate>
{
    SocketIO *socketIO;
}

@property (nonatomic, weak) id<NetworkManager> delegate;

-(id)init;
@end

@protocol MyProtocolName <NSObject>

@required
-(BOOL)turnDidChange:(int)player;
-(BOOL)cardDidArrive:(int)player:(int)suit:(int)num;
-(BOOL)turnDidEnd;
-(BOOL)gameDidEnd:(int)winner;

@end