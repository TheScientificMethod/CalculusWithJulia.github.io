module polynomial
using Gadfly, Reel, Mustache, WeavePynb
using SymPy


## XXX Need a better set of polynomials
## Make poly chart
function makedifferentpolychart(n, dt)
    n = convert(Int, n)
    x = symbols("x")

    

    
    ns = [5,6,4,7,3,8,2,9,1]


    xs = linspace(extrema(ns[1:(n+1)]...)...)
    f(x) = prod([(x-i) for i in ns[1:(n+1)]])




    p = prod([(x - i) for  i in ns[1:(n+1)]])
    tit = string(expand(p))
    
    ticks = [-10, -5, 0, 5, 10]    
    Gadfly.plot(x=xs, y=map(f, xs), Geom.line, #Guide.yticks(ticks=ticks),
                Guide.title(tit))
end



## Make polygroth plot
function makelinemgraph(n, dt)
    ms = [-5, -2, -1, 1, 2, 5, 10, 20]
    n = convert(Integer, n) +1
    m = ms[n]
    ticks = [-20, -10, 0, 10, 20]
    g(x)=ms[n]*x
    xs = linspace(-1,1)
    ys = map(g, xs)
    Gadfly.plot(x=xs, y=ys, Guide.yticks(ticks=ticks), Guide.title("y = $m x"), Geom.line)
end

film = roll(makelinemgraph, fps=1, duration=9)
film.fps=1
imgfile = tempname() * ".gif"
write(imgfile, film)

caption = "Graphs of y = mx for different values of m"
lines_m_graph =  gif_to_data(imgfile, caption)


# film = roll(makedifferentpolychart, fps=1, duration=9)
# film.fps=1
# imgfile = tempname() * ".gif"
# write(imgfile, film)
# data = readall(`julia4 -e "base64encode(readall(\"$imgfile\")) |> print"`);
# caption = "Polynomials of varying degrees over [-1,1]."
# different_poly_graph =  Mustache.render(gif_to_data_tpl, Compat.@Dict("data"=>data, "caption"=>caption))


## Make polygroth plot
function makepolygrowthgraph(n, dt)
    xs = linspace(-2, 2)
    ticks = [0, 64, 128, 256, 512, 1024]
    
    n = convert(Int, 2n)
    ys = map(x -> x^n, xs)    
    Gadfly.plot(x=xs, y=ys, Guide.yticks(ticks=ticks), Guide.title("x^$n"), Geom.line)
end

film = roll(makepolygrowthgraph, fps=1, duration=7)
film.fps=1
imgfile = tempname() * ".gif"
write(imgfile, film)

caption = "Demonstration that x^10 grows faster than x^8, ... and x^2  grows faster than x^0 (which is constant)."
poly_growth_graph =  gif_to_data(imgfile, caption)


## leading term dominates
## XXX Watch [f,g] bit. Doesn't like leading NaNs XXX
function leadingtermgraph(n, dt)
    n = convert(Int,n) + 1
    m = [1, 1/2, -1, -5, -20]
    M = [2, 4,    5, 10, 25]
    f(x) = (x-1)*(x-2)*(x-3)*(x-5)
    xs = linspace(m[n+1], M[n+1])
    ys = map(f, xs)
    x = symbols("x")
    fn = string(f(x))
    if n == 0
        Gadfly.plot(f, m[1], M[1], Guide.title("Graph of $fn on $(m[n+1]) to $(M[n+1])"))
    else
        g(x) = x < m[n] ? NaN : (x > M[n] ? NaN : f(x))
        Gadfly.plot([f, g], m[n+1], M[n+1], Guide.title("Graph of $fn on $(m[n+1]) to $(M[n+1])"))
    end
end

film = roll(leadingtermgraph, fps=1, duration=5)
film.fps=1/2

caption = "Ulitmately the leading term (\$x^4\$ here) dominates the graph"
imgfile = tempname() * ".gif"
write(imgfile, film)
leading_term_graph = gif_to_data(imgfile, caption)

end
