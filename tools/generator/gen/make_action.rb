CxxFileGenerator.class_eval do

  def fn_is_action?(fn)
    (not fn.dumps) && fn.conf['fct_action']
  end
  
  def print_register_actions
    for_each_fun(false) do |fn| 
      if fn_is_action? fn then
        @f.print <<-EOF
    api_->actions()->register_action(
        ID_ACTION_#{fn.name.upcase},
        []() -> rules::IAction* { return new Action#{camel_case fn.name}(); }
        );
EOF
      end
    end
  end
  
  def print_actions_hh
    # I don't think for_each_fun without block returns an enumerator
    # (which it really should)
    # so this code is less nice / more imperative than it could have been
    action_ids = []
    for_each_fun(false) do |fn|
      if (not fn.dumps) && fn.conf['fct_action']
        action_ids << "ID_ACTION_#{fn.name.upcase}"
      end
    end
    
    File.open("actions.hh", 'w') do |file|
      file.write <<-EOF
// FIXME License notice

#ifndef ACTIONS_HH
#define ACTIONS_HH

enum action_id {
    #{action_ids.join(",\n    ")}
};

#endif // !ACTIONS_HH
EOF
    end
  end
  
  def print_action_file(fn)
    return nil unless fn_is_action? fn

    puts "Generating action file for #{fn.name}"
    
    ifdef_name = "ACTION_#{fn.name.upcase}_HH"
    class_name = "Action" + (camel_case fn.name)
    
    arg_list = fn.args.map { |arg| [cxx_type(arg.type), arg.name] } \
               + [["int", "player_id"]]

    constr_args = arg_list.map{|t,v| "#{t} #{v}"}.join(", ")
    constr_proto = class_name + '(' + constr_args + ')'

    members = arg_list.map{|t,v| "#{t} #{v}_;"}.join("\n    ")
    bufhandle = arg_list.map{|t,v| "buf.handle(#{v}_);"}.join("\n    ")
    
    init_list = arg_list.map{|t,v| "#{v}_(#{v})"}.join("\n    , ")
    init_list_default = arg_list.map{|t,v| "#{v}_(FIXME)"}.join("\n    , ")
    
    File.open("action_#{fn.name}.hh", 'w') do |file|
      file.write <<-EOF
// FIXME License notice

#ifndef #{ifdef_name}
#define #{ifdef_name}

#include <rules/action.hh>

#include "actions.hh"
#include "game_state.hh"
#include "constant.hh"

class #{class_name} : public rules::Action<GameState>
{
public:
    #{constr_proto};
    #{class_name}();

    virtual int check(const GameState* st) const;
    virtual void handle_buffer(utils::Buffer& buf);
    virtual void apply_on(GameState* st) const;

    uint32_t player_id() const;
    uint32_t id() const;

private:
    #{members}
};

#endif // !#{ifdef_name}

EOF
    end
    File.open("action_#{fn.name}.cc", 'w') do |file|
      file.write <<-EOF
// FIXME License notice

#include "action_#{fn.name}.hh"

#{class_name}::#{constr_proto}
    : #{init_list}
{
}

#{class_name}::#{class_name}()
    : #{init_list_default}
{
}

int #{class_name}::check(const GameState* st) const
{
    // FIXME
    return 0;
}

void #{class_name}::handle_buffer(utils::Buffer& buf)
{
    #{bufhandle}
}

void #{class_name}::apply_on(GameState* st) const
{
    // FIXME
}

uint32_t #{class_name}::player_id() const
{
    return player_id_;
}

uint32_t #{class_name}::id() const
{
    return ID_ACTION_#{fn.name.upcase};
}

EOF
    end
  end
end
