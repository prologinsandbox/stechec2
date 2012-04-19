#include "server-messenger.hh"

namespace net {

ServerMessenger::ServerMessenger(ServerSocket_sptr sckt)
    : sckt_(sckt)
{
}

void ServerMessenger::send(const utils::Buffer& buf)
{
    Message* msg = to_msg(buf.data(), buf.length());
    sckt_->send(*msg);
    delete msg;
}

utils::Buffer* ServerMessenger::recv()
{
    Message* msg = sckt_->recv();

    uint8_t* data;
    uint32_t size = from_msg(*msg, &data);

    std::vector<uint8_t> data_vector;
    data_vector.assign(data, data + size);

    utils::Buffer* buf = new utils::Buffer(data_vector);

    return buf;
}

} // namespace net
