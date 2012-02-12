window.addEventListener "load", (->
  canvas = document.getElementById("canvas")
  canvas.width = window.innerWidth - 30
  canvas.height = window.innerHeight - 30
  ctx = canvas.getContext("2d")
  ctx.lineWidth = 5
  ctx.strokeStyle = "#9eala3"
  remote_down = false
  socket = io.connect "http://192.168.11.4"
  socket.on "connect", (data) ->
    console.log "connect"

  socket.on "message", (data) ->
    console.log "メッセージを受け取りました"
    console.dir data
    switch data.act
      when "down"
        remote_down = true
        ctx.strokeStyle = data.color
        ctx.beginPath()
        ctx.moveTo data.x, data.y
      when "move"
        console.log "remote: " + data.x, data.y
        ctx.lineTo data.x, data.y
        ctx.stroke()
      when "up"
        return  unless remote_down
        ctx.lineTo data.x, data.y
        ctx.stroke()
        ctx.closePath()
        remote_down = false

  down = false
  canvas.addEventListener "mousedown", ((e) ->
    down = true
    ctx.beginPath()
    ctx.moveTo e.clientX, e.clientY
    socket.emit "message",{
      act: "down"
      x: e.clientX
      y: e.clientY
      color: ctx.strokeStyle
    }
  ), false
  window.addEventListener "mousemove", ((e) ->
    return  unless down
    console.log e.clientX, e.clientY
    ctx.lineTo e.clientX, e.clientY
    ctx.stroke()
    socket.emit "message", {
      act: "move"
      x: e.clientX
      y: e.clientY
    }
  ), false
  window.addEventListener "mouseup", ((e) ->
    return  unless down
    ctx.lineTo e.clientX, e.clientY
    ctx.stroke()
    ctx.closePath()
    down = false
    socket.emit "message", {
      act: "up"
      x: e.clientX
      y: e.clientY
    }
  ), false
  colors = document.getElementById("colors").childNodes
  i = 0
  color = undefined

  while color = colors[i]
    continue  unless color.nodeName.toLowerCase() is "div"
    color.addEventListener "click", ((e) ->
      style = e.target.getAttribute("style")
      color = style.match(/background:(#......)/)[1]
      ctx.strokeStyle = color
    ), false
    i++
), false
