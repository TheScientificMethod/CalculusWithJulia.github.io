module optimization

using WeavePynb, LaTeXStrings
using Gadfly, Reel, Mustache

function perimeter_area_graphic_graph(n, _)
    h = 1 + 2n
    w = 10-h
    plot(layer(x=[0,0,w,w,0], y=[0,h,h,0,0], Geom.line(preserve_order=true)),
         layer(x=[w], y=[h], Geom.point),
         layer(x=[w/2],y=[h/2], label=["Area=$(round(w*h,1))"], Geom.label),
         Guide.yticks(ticks=[0,5,10]), Guide.xticks(ticks=[0,5,10])
         )
end

caption = """ 

Some possible rectangles that satisfy the constraint on the perimeter and their area.

"""

film = roll(perimeter_area_graphic_graph, fps=1, duration=5)
film.fps=1/2


imgfile = tempname() * ".gif"
write(imgfile, film)
perimeter_area_graphic = gif_to_data(imgfile, caption)

                            

end
