using Random

const Torus = Int32 

# Float64の値を[-0.5,0.5)に射影
FLoat2Torus05(x::Float64) = x - floor(x-0.5) - 1.0

# Float64の値を[0.0, 1.0)に射影
Float2Torus01(x::Float64) = x - floor(x)

# [-0.5,0.5)をTorus32に変換
dtot32(d::Float64) = trunc(Int32, d*2^32)

function gaussian_float(rng::AbstractRNG, sigma::Float64, dims...)
    randn(rng, dims...) .* sigma
end

# モジュラー正規分布に従う乱数生成
function modular_gaussian(rng::AbstractRNG, sigma::Float64, dims...)
    dtot32(Float2Torus05(gaussian_float(rng, sigma, dims...)))
end

# Torus32上の一様分布に従う乱数生成
function rand_uniform_Torus32(rng::AbstractRNG, dims...)
    rand(rng, Torus32, dims...)
end
