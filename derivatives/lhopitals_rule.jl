module lhopitals_rule




using WeavePynb, LaTeXStrings
using Gadfly, Reel, Mustache
using Roots



## Secant line approaches tangent line...
function lhopitals_picture_graph(n, dt)
    
g(x) = sqrt(1 + x) - 1 - x^2
f(x) = x^2
ts = linspace(-1/2, 1/2)


n = convert(Int, n)
a, b = 0, 1/2^n * 1/2

m = (f(b)-f(a)) /  (g(b)-g(a)) 
## get bounds
tl(x) = g(0) + m * (x - f(0))

lx = max(fzero(x -> tl(x) - (-0.05),-1000, 1000), -0.6)
rx = min(fzero(x -> tl(x) - (0.25),-1000, 1000), 0.2)
xs = [lx, rx]
ys = map(tl, xs)

plot(layer(x=map(g,ts), y = map(f, ts), Geom.line(preserve_order=true)),
layer(x=xs, y=ys, Geom.line, Theme(default_color=colorant"orange")),
  layer(x=[g(a),g(b)],y=[f(a),f(b)], Geom.point),
  Guide.xticks(ticks=collect(-0.6:.2:.2)),
  Guide.yticks(ticks=collect(-.05:.05:.25))
)
end
caption = L"""

Geometric interpretation of $L=\lim_{x \rightarrow 0} x^2 / (\sqrt{1 +
x} - 1 - x^2)$. At $0$ this limit is indeterminate of the form
$0/0$. The value for a fixed $x$ can be seen as the slope of a secant
line of a parametric plot of the two functions, plotted as $(g,
f)$. In this figure, the limiting "tangent" line has $0$ slope,
corresponding to the limit $L$. In general, L'Hopital's rule is
nothing more than a statement about slopes of tangent lines.

"""

film = roll(lhopitals_picture_graph, fps=1, duration=6)
film.fps=1/2


imgfile = tempname() * ".gif"
write(imgfile, film)
lhopitals_picture = gif_to_data(imgfile, caption)



end
