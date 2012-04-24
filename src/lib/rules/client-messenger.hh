#ifndef LIB_RULES_CLIENTMESSENGER_HH_
# define LIB_RULES_CLIENTMESSENGER_HH_

# include <memory>
# include <stdexcept>

# include <rules/messenger.hh>
# include <net/client-socket.hh>
# include <utils/buffer.hh>

namespace rules {

// Forward decls
class Actions;

class ClientMessengerError : public std::runtime_error
{
public:
    ClientMessengerError() : std::runtime_error("Client messenger error") {}
};

class ClientMessenger : public Messenger
{
public:
    ClientMessenger(net::ClientSocket_sptr sckt);

    virtual void send(const utils::Buffer&);
    void send_actions(Actions&);

    utils::Buffer* recv();

    utils::Buffer* pull();
    void pull_actions(Actions*);

    virtual void wait_for_ack();

private:
    net::ClientSocket_sptr sckt_;
};

typedef std::shared_ptr<ClientMessenger> ClientMessenger_sptr;

} // namespace net

#endif // !LIB_RULES_CLIENTMESSENGER_HH_
