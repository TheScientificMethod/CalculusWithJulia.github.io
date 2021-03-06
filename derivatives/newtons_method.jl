module newtons_method


using WeavePynb, LaTeXStrings
using Gadfly, Reel, Mustache

using Roots

## Secant line approaches tangent line...
function newtons_method_graph(n, dt)

    f(x) = log(x)
    a,b = .15, 2
    c = .2

    
    xstars = [c]
    xs = [c]
    ys = [0.0]
    if n == 0
        ts = linspace(a,b)
        plot(layer(x=ts, y=map(f,ts), Geom.line),
             layer(x=xstars, y=0*xstars, Geom.point))
    else
        ts = linspace(a,b)
        for i in 1:n
            x0 = xs[end]
            x1 = x0 - f(x0)/D(f)(x0)
            push!(xstars, x1)
            append!(xs, [x0, x1])
            append!(ys, [f(x0), 0])
        end
        plot(layer(x=ts, y=map(f,ts), Geom.line),
             layer(x=xs, y=ys, Geom.line(preserve_order=true), Theme(default_color=colorant"gray")),
             layer(x=[0,2], y=[0,0], Geom.line, Theme(default_color=colorant"gray")),
             layer(x=xstars, y=0*xstars, Geom.point)
             )
    end
end
caption = """

Illustration of Newton's Method converging to a zero of a function.

"""

film = roll(newtons_method_graph, fps=1, duration=5)
film.fps=1/2


imgfile = tempname() * ".gif"
write(imgfile, film)
newtons_method_example = gif_to_data(imgfile, caption)


###

## Secant line approaches tangent line...
function newtons_method_poor_x0_graph(n, dt)

    f(x) = sin(x) - x/4
    a,b = -15, 20
    c = 2pi

    
    xstars = [c]
    xs = [c]
    ys = [0.0]
    if n == 0
        ts = linspace(a,b)
        plot(layer(x=ts, y=map(f,ts), Geom.line),
             layer(x=xstars, y=0*xstars, Geom.point))
    else
        ts = linspace(a,b)
        for i in 1:n
            x0 = xs[end]
            x1 = x0 - f(x0)/D(f)(x0)
            push!(xstars, x1)
            append!(xs, [x0, x1])
            append!(ys, [f(x0), 0])
        end
        plot(layer(x=ts, y=map(f,ts), Geom.line),
             layer(x=xs, y=ys, Geom.line(preserve_order=true), Theme(default_color=colorant"gray")),
             layer(x=xstars, y=0*xstars, Geom.point)
             )
    end
end
caption = """

Illustration of Newton's Method converging to a zero of a function,
but slowly as the initial guess, is very poor, and not close to the
zero. The algorithm does converge, but not quickly and not to the nearest root from
the initial guess.

"""

film = roll(newtons_method_poor_x0_graph, fps=1, duration=20)
film.fps=1/2


imgfile = tempname() * ".gif"
write(imgfile, film)
newtons_method_poor_x0 = gif_to_data(imgfile, caption)



###


## Secant line approaches tangent line...
function newtons_method_cycle_graph(n, dt)

    f(x) = abs(x)^(0.49)
    a,b = -2, 2
    c = 1.0

    
    xstars = [c]
    xs = [c]
    ys = [0.0]

    ts = linspace(a,b)
    tsl = linspace(a, -1e-5)
    tsr = linspace(1e-5, b)

    if n == 0
        plot(layer(x=tsl, y=map(f,tsl), Geom.line),
             layer(x=tsr, y=map(f,tsr), Geom.line),
             layer(x=xs, y=ys, Geom.line(preserve_order=true), Theme(default_color=colorant"gray")),
             layer(x=xstars, y=0*xstars, Geom.point))
    else
        ts = linspace(a,b)
        for i in 1:n
            x0 = xs[end]
            x1 = x0 - f(x0)/D(f)(x0)
            push!(xstars, x1)
            append!(xs, [x0, x1])
            append!(ys, [f(x0), 0])
        end
        plot(layer(x=tsl, y=map(f,tsl), Geom.line),
             layer(x=tsr, y=map(f,tsr), Geom.line),
             layer(x=xs, y=ys, Geom.line(preserve_order=true), Theme(default_color=colorant"gray")),             
             layer(x=xstars, y=0*xstars, Geom.point)
             )
    end
end
caption = L"""

Illustration of Newton's Method not converging. Here the second
derivative is too big near the zero -- it blows up near $0$ -- and the
convergence does not occur. Rather the iterates increase in their
distance from the zero.

"""

film = roll(newtons_method_cycle_graph, fps=1, duration=10)
film.fps=1/2


imgfile = tempname() * ".gif"
write(imgfile, film)
newtons_method_cycle = gif_to_data(imgfile, caption)




## function too close to a flat spot
function newtons_method_flat_graph(n, dt)

    f(x) = x^5 - x + 1
    a,b =  -1.5, 1.4
    c = 0.0

    
    xstars = [c]
    xs = [c]
    ys = [0.0]
    if n == 0
        ts = linspace(a,b)
        plot(layer(x=ts, y=map(f,ts), Geom.line),
             layer(x=xs, y=ys, Geom.line(preserve_order=true), Theme(default_color=colorant"gray")),
             layer(x=xstars, y=0*xstars, Geom.point))
    else
        ts = linspace(a,b)
        for i in 1:n
            x0 = xs[end]
            x1 = x0 - f(x0)/D(f)(x0)
            push!(xstars, x1)
            append!(xs, [x0, x1])
            append!(ys, [f(x0), 0])
        end
        plot(layer(x=ts, y=map(f,ts), Geom.line),
             layer(x=xs, y=ys, Geom.line(preserve_order=true), Theme(default_color=colorant"gray")),             
             layer(x=xstars, y=0*xstars, Geom.point)
             )
    end
end
caption = L"""

Illustration of Newton's method failing to coverge as for some $x_i$,
$f'(x_i)$ is too close to 0. In this instance after a few steps, the
algorithm just cycles around the local minimum near $0.66$. The values
of $x_i$ repeat in the pattern: $1.0002, 0.7503, -0.0833, 1.0002,
\dots$. This is also an illustration of a poor initial guess. If there
is a local minimum or maximum between the guess and the zero, such
cycles can occur.

"""

film = roll(newtons_method_flat_graph, fps=1, duration=7)
film.fps=1/2


imgfile = tempname() * ".gif"
write(imgfile, film)
newtons_method_flat = gif_to_data(imgfile, caption)



###

## function too close to a flat spot
function newtons_method_wilkinson_graph(n, dt)

    f(x) = x^20 - 1
    a,b =  .7, 1.4
    c = 8/9

    
    xstars = [c]
    xs = [c]
    ys = [0.0]
    if n == 0
        ts = linspace(a,b)
        plot(layer(x=ts, y=map(f,ts), Geom.line),
             layer(x=xs, y=ys, Geom.line(preserve_order=true), Theme(default_color=colorant"gray")),
             layer(x=xstars, y=0*xstars, Geom.point))
    else
        ts = linspace(a,b)
        for i in 1:n
            x0 = xs[end]
            x1 = x0 - f(x0)/D(f)(x0)
            push!(xstars, x1)
            append!(xs, [x0, x1])
            append!(ys, [f(x0), 0])
        end
        plot(layer(x=ts, y=map(f,ts), Geom.line),
             layer(x=xs, y=ys, Geom.line(preserve_order=true), Theme(default_color=colorant"gray")),             
             layer(x=xstars, y=0*xstars, Geom.point)
             )
    end
end
caption = L"""

The function $f(x) = x^{20} - 1$ has two bad behaviours for Newton's
method: for $x < 1$ the derivative is nearly $0$ and for $x>1$ the
second derivative is very big. In this illustration, we have an
initial guess of $x_0=8/9$. As the tangent line is fairly flat, the
next approximation is far away, $x_1 = 1.313\dots$. As this guess is
is much bigger than $1$, the ratio $f(x)/f'(x) \approx
x^{20}/(20x^{19}) = x/20$, so $x_i - x_{i-1} \approx (19/20)x_i$
yielding slow, linear convergence until $f''(x_i)$ is moderate. For
this function, starting at $x_0=8/9$ takes 11 steps, at $x_0=7/8$
takes 13 steps, at $x_0=3/4$ takes 55 steps, and at $x_0=1/2$ it takes
$204$ steps.

"""

film = roll(newtons_method_wilkinson_graph, fps=1, duration=10)
film.fps=1/2


imgfile = tempname() * ".gif"
write(imgfile, film)
newtons_method_wilkinson = gif_to_data(imgfile, caption)



end
