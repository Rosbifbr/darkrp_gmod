zmlab2 = zmlab2 or {}
zmlab2.MiniGame = zmlab2.MiniGame or {}


function zmlab2.MiniGame.GetPenalty(Machine)
    local val = zmlab2.config.MiniGame.Quality_Penalty
    /*
    local m_data = zmlab2.config.MethTypes[Machine:GetMethType()]

    // Higher difficulty means more penality
    if m_data and m_data.difficulty then
        val = (zmlab2.config.MiniGame.Quality_Penalty / 10) * m_data.difficulty
    end
    print("GetPenalty: " .. val)
    */
    return math.Round(val)
end

function zmlab2.MiniGame.GetReward(Machine)
    local val = zmlab2.config.MiniGame.Quality_Reward
    /*
    local m_data = zmlab2.config.MethTypes[Machine:GetMethType()]

    // Higher difficulty means less reward
    if m_data and m_data.difficulty then
        val = (zmlab2.config.MiniGame.Quality_Reward / 10) * (10 - m_data.difficulty)
    end
    print("GetReward: " .. val)
    */
    return math.Round(val)
end
