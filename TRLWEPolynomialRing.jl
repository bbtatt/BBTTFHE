# naive implementationr

const Torus32 = Int32

mutable struct Polynomial {T} <: Number
    coef :: Array{T, 1}
end

degree(p::Polynomial) = length(p.coef) - 1

Int32PolynomialRing = Polynomial{Int32}
Torus32PolynomialRing = Polynomial{Torus32}

Base.:+(p1::Torus32PolynomialRing, p2::Torus32PolynomialRing) =
    Torus32PolynomialRing(p1.coef + p2.coef)

function Base.:*(p1::Int32PolynomialRing, p2::Torus32PolynomialRing)
    N_1 = degree(p1)
    coef = zeros(Torus32, degree(p1))
    for i in 0:N_1
        for j in 0:N_1
            if i + j < N_1 + 1
                coef[i+j+1] += p1.coef[i+1] * p2.coef[j+1]
            else
                coef[i+j-N_1] -= p1.coef[i+1] * p2.coef[j+1]
            end
        end
    end
    Torus32PolynomialRing(coef)
end

Base.:*(p1::Torus32PolynomialRing, p2::Int32PolynomialRing) = p2*p1




