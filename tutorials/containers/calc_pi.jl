"""
     function calc_pi(N)

This function calculates pi with a Monte Carlo simulation using N samples.
"""
function calc_pi(N)
    # Generate `N` pairs of x,y coordinates on a grid defined
    # by the extrema (1, 1), (-1,-1 ), (1, -1), and (-1, 1)
    samples = rand([1, -1], N, 2) .* rand(N, 2)
    # how many of these sample points lie within the circle
    # of max size bounded by the same extrema
    samples_in_circle = sum([sqrt(samples[i, 1]^2 + samples[i, 2]^2) < 1.0 for i in 1:N])

    pi = 4*samples_in_circle/N
end

# print the estimate of pi calculated with 10,000 samples
println(calc_pi(10_000))
