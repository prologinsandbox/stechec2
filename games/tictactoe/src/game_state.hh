#ifndef GAME_STATE_HH
#define GAME_STATE_HH

#include <rules/game-state.hh>
#include <rules/player.hh>

#include <unordered_map>
#include <vector>

#include "constant.hh"

class GameState : public rules::GameState
{
public:
    const int NO_PLAYER = -1;

    GameState(rules::Players_sptr players);
    rules::GameState* copy() const override;

    std::vector<int> get_board() const;
    bool is_valid_cell(position pos) const;
    int get_cell(position pos) const;
    void set_cell(position pos, int player_id);

    int winner() const;

    void set_player_turn(int player_id, bool state);
    bool is_player_turn(int player_id) const;

private:
    std::unordered_map<int, bool> is_player_turn_;
    std::vector<int> board_;
};

std::ostream& operator<<(std::ostream& out, const GameState& gs);

#endif /* !GAME_STATE_HH */
