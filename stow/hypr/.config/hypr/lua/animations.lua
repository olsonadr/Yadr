local function bezier(name, x1, y1, x2, y2)
    hl.curve(name, {
        type = "bezier",
        points = { { x1, y1 }, { x2, y2 } },
    })
end

bezier("myBezier", 0.05, 0.9, 0.1, 1.0)
bezier("linear", 0.0, 0.0, 1.0, 1.0)
bezier("wind", 0.05, 0.9, 0.1, 1.0)
bezier("winIn", 0.1, 1.1, 0.1, 1.1)
bezier("winOut", 0.3, 0, 0, 1)
bezier("slow", 0, 0.85, 0.3, 1)
bezier("overshot", 0.7, 0.6, 0.1, 1.2)
bezier("bounce", 0.5, 0.7, 0.3, 0.4)
bezier("sligshot", 1, -1, 0.15, 1.25)
hl.config({ animations = { enabled = true } })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "slow", style = "popin" })
hl.animation({ leaf = "windowsOut", enabled = false, speed = 1.5, bezier = "winOut", style = "popin" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 1, bezier = "wind", style = "slide" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "overshot" })
hl.animation({ leaf = "fadeOut", enabled = false, speed = 1, bezier = "overshot" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "wind" })
hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "bounce", style = "popin" })
