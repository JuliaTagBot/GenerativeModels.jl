module GenerativeModels

using POMDPs

export generate_s,
       generate_o,
       generate_sr,
       generate_so,
       generate_or,
       generate_sor,
       initial_state

function generate_s{S}(p::POMDP{S}, s, a, rng::AbstractRNG, sp::S=create_state(p))
    td = transition(p, s, a)
    return rand(rng, td, sp)
end

function generate_o{S,A,O}(p::POMDP{S,A,O}, s, a, sp, rng::AbstractRNG, o::O=create_observation(p))
    od = observation(p, s, a, sp)
    return rand(rng, od, o)
end

function generate_sr{S}(p::POMDP{S}, s, a, rng::AbstractRNG, sp::S=create_state(p))
    sp = generate_s(p, s, a, rng)
    return sp, reward(p, s, a, sp)
end

function generate_so{S,A,O}(p::POMDP{S,A,O}, s, a, rng::AbstractRNG, sp::S=create_state(p), o::O=create_observation(p))
    sp = generate_s(p, s, a, rng, sp)
    return sp, generate_o(p, s, a, sp, rng, o)
end

function generate_or{S,A,O}(p::POMDP{S,A,O}, s, a, sp, rng::AbstractRNG, o::O=create_observation(p))
    return generate_o(p, s, a, sp, rng, o), reward(p, s, a, sp)
end

function generate_sor{S,A,O}(p::POMDP{S,A,O}, s, a, rng::AbstractRNG, sp::S=create_state(p), o::O=create_observation(p))
    sp,o = generate_so(p, s, a, rng, sp, o)
    return sp, o, reward(p, s, a, sp)
end

function initial_state{S}(p::POMDP{S}, rng::AbstractRNG, s::S=create_state(p))
    b = initial_belief(p)
    return rand(rng, b, s)
end

end # module
