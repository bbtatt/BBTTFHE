using LinearAlgebra

include("util.jl")

const Torus32 = Int32

struct LweKey
    n :: Int
    tlwe :: Array{Bool, 1}

    LweKey(rng::AbstractRNG, n::Int) = new(n, rand(rng, Bool, n))
end

mutable struct EncriptedText
    a :: Array{Torus32, 1}
    b :: Torus32

    EncriptedText(a::Array{Torus32, 1}, b::Torus32) = 
        new(a, b)
end

function lwe_encrypt_bool(rng::AbstractRNG, message::Bool, key::LweKey, α::Float64, μ::Int)
    a = rand_uniform_Torus32(rng, key.n)
    s = key.tlwe
    m = Int32(μ*(2*message - 1))
    e = modular_gaussian(rng, α)
    b = a ⋅ s + m + e
    EncriptedText(a, b)
end

function lwe_decrypt_bool(ciphertext::EncriptedText, key::LweKey)
    (ciphertext.b - ciphertext.a ⋅ key.tlwe) > 0
end
    
Base.:+(x::EncriptedText, y::EncriptedText) = 
    EncriptedText(x.a + y.a, x.b + y.b)

Base.:-(x::EncriptedText, y::EncriptedText) = 
    EncriptedText(x.a - y.a, x.b - y.b)

function Base.:*(x::Integer, y::EncriptedText) 
    tx = Torus32(x)
    EncriptedText(tx * y.a, tx * y.b)
end

Base.:*(x::EncriptedText, y::Integer) = y * x