window.addEventListener "load", (->
  canvas = document.getElementById("canvas_mine")
  canvas_others = document.getElementById("canvas_others")
  canvas.width = window.innerWidth - 30
  canvas.height = window.innerHeight - 30
  canvas_others.width = window.innerWidth - 30
  canvas_others.height = window.innerHeight - 30
  ctx = canvas.getContext("2d")
  ctx_others = canvas_others.getContext("2d")
  ctx.lineWidth = 1
  ctx.strokeStyle = "#9eala3"
  ctx_others.lineWidth = 1
  ctx_others.strokeStyle = "#9eala3"

  test_image = new Image
  test_image.src = "/image/grade5-3.jpg"
  console.dir test_image
  test_image.onload = ->
    ctx_others.drawImage test_image, 0, 0

  remote_down = false
  socket = io.connect()
  socket.on "connect", (data) ->
    console.log "connect"

  clear = (canvas)->
    canvas.getContext("2d").clearRect(0, 0, canvas.width, canvas.height)

  socket.on "message", (data) ->
    switch data.act
      when "down"
        remote_down = true
        ctx_others.strokeStyle = data.color
        ctx_others.beginPath()
        ctx_others.moveTo data.x, data.y
      when "move"
        console.log "remote: " + data.x, data.y
        ctx_others.lineTo data.x, data.y
        ctx_others.stroke()
      when "up"
        return  unless remote_down
        ctx_others.lineTo data.x, data.y
        ctx_others.stroke()
        ctx_others.closePath()
        remote_down = false
  socket.on "clear", ->
    clear canvas_others
    clear canvas

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
  clear_button = document.getElementById("clear")
  clear_button.addEventListener "click", ((e) ->
    socket.emit "clear"
    clear canvas_others
    clear canvas
  ), false


  colors = document.getElementById("colors").childNodes
  i = 0
  color = undefined

  while color = colors[i]
    continue  unless color.nodeName.toLowerCase() is "div"
    color.addEventListener "click", ((e) ->
      style = e.target.getAttribute("style")
      color = style.match(/background:(rgba.*,.*,.*,.*\))/)[1]
      console.log color
      ctx.strokeStyle = color
    ), false
    i++
), false
