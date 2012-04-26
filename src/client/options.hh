#ifndef CLIENT_OPTIONS_HH
# define CLIENT_OPTIONS_HH

# include <string>
# include <cstdint>

# include <utils/options.hh>

class Options : public utils::Options
{
public:
    virtual void process(int argc, char** argv);

    // Path to the configuration file
    std::string config;

    // ZeroMQ binding for REQ socket
    std::string req_addr;

    // ZeroMQ binding for SUB socket
    std::string sub_addr;

    // Client name (to get the right section in conf file and to properly show
    // results)
    std::string client_name;

    // Path to the rules library
    std::string rules_lib;

    // Path to the champion library
    std::string champion_lib;

    // Path to the map file
    std::string map_file;

    // Is this client a spectator?
    bool spectator;

    // Memory limit for the champion
    uint32_t memory;

    // Turn time limit for the champion in ms
    uint32_t time;

    // Path to the file to write the logs to
    std::string log;

    // Verbosity of the logs displayed/written
    unsigned verbose;
};

#endif // !CLIENT_OPTIONS_HH
