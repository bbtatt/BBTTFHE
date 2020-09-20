using Random

include("../tlwe.jl")


function tlwe_test()
    n = 630
    α = 2e-15
    μ = 50000000
    rng = MersenneTwister(0)

    num_try_key = 10000
    num_try_whole = 100

    for i in 1:num_try_whole
        key = LweKey(rng, n)
        for j in 1:num_try_key
            message = rand(rng, Bool)
            ciphertext = lwe_encrypt_bool(rng, message, key, α, μ)
            decrypted_text = lwe_decrypt_bool(ciphertext, key)
            if message != decrypted_text
                return false
            end
        end
    end

    return true
end
    
tlwe_test()

