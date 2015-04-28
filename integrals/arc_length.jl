module arc_length
using WeavePynb, LaTeXStrings
using Reel, Gadfly



function make_arclength_graph(n,_)
    n = convert(Int, n) + 1

    ns = [10,15,20, 30, 50]
    
    g(t) = cos(t)/t
    f(t) = sin(t)/t
    
    ts = linspace(1, 4pi, 200)
    tis = linspace(1, 4pi, ns[n])

    p = plot(layer(x = map(g, ts), y=map(f, ts), Geom.line(preserve_order=true)),
             layer(x = map(g, tis), y=map(f, tis), Geom.line(preserve_order=true), Theme(default_color=color("orange"))),
             Guide.title("Approximate arc length with $(ns[n]) points in the partition.")
             )

end

film = roll(make_arclength_graph, fps=1, duration=6)
film.fps=1
imgfile = tempname() * ".gif"
write(imgfile, film)

caption = L"""

The arc length of the parametric curve can be approximated using straight line segments connecting points. This gives rise to an integral expression defining the length in terms of the functions $f$ and $g$.

"""

arclength_graph = gif_to_data(imgfile, caption)




end
