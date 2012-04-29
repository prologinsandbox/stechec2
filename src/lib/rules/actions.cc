#include "actions.hh"

namespace rules {

void Actions::handle_buffer(utils::Buffer& buf)
{
    if (buf.serialize())
    {
        for (auto action : actions_)
        {
            // The id is needed to reconstruct the action when unserializing
            uint32_t action_id = action->id();
            buf.handle(action_id);

            action->handle_buffer(buf);
        }
    }
    else
    {
        while (!buf.empty())
        {
            // Get the action id
            uint32_t action_id;
            buf.handle(action_id);

            // Use it to instantiate the right rules Action
            IAction_sptr action = IAction_sptr(action_factory_[action_id]());

            // And finally unserialize
            action->handle_buffer(buf);
            actions_.push_front(action);
        }
    }
}

void Actions::register_action(uint32_t action_id,
        f_action_factory action_factory)
{
    action_factory_[action_id] = action_factory;
}

} // namespace rules
