from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor

class IphoneChat(Protocol):
    def connectionMade(self):
        self.factor.clients.append(self)
        print "clients are", self.factory.clients
    
    def connectionLost(self, reason):
        self.factory.clients.remove(self)

factory = Factory()
factory.protocol = IphoneChat
factory.clients = []
reactor.listenTCP(80, factory)
print "Iphone Chat server started"
reactor.run()

