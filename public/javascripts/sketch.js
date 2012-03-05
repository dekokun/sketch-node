(function() {

  window.addEventListener("load", (function() {
    var canvas, canvas_others, clear, clear_button, color, colors, ctx, ctx_others, down, i, load, remote_down, save, socket, test_image, _results;
    canvas = document.getElementById("canvas_mine");
    canvas_others = document.getElementById("canvas_others");
    canvas.width = window.innerWidth - 30;
    canvas.height = window.innerHeight - 30;
    canvas_others.width = window.innerWidth - 30;
    canvas_others.height = window.innerHeight - 30;
    ctx = canvas.getContext("2d");
    ctx_others = canvas_others.getContext("2d");
    ctx.lineWidth = 1;
    ctx.strokeStyle = "#9eala3";
    ctx_others.lineWidth = 1;
    ctx_others.strokeStyle = "#9eala3";
    test_image = new Image;
    test_image.src = "/image/grade5-3.jpg";
    console.dir(test_image);
    test_image.onload = function() {
      return ctx_others.drawImage(test_image, 0, 0);
    };
    remote_down = false;
    socket = io.connect();
    socket.on("connect", function(data) {
      return console.log("connect");
    });
    clear = function(canvas) {
      return canvas.getContext("2d").clearRect(0, 0, canvas.width, canvas.height);
    };
    save = function(canvas, key) {
      var coded_canvas;
      coded_canvas = canvas.toDataURL();
      return window.localStorage[key] = coded_canvas;
    };
    load = function(canvas, key) {
      var img, local_data;
      local_data = window.localStorage[key];
      img = new Image();
      img.src = local_data;
      return canvas.getContext("2d").drawImage(img, 0, 0);
    };
    socket.on("message", function(data) {
      switch (data.act) {
        case "down":
          remote_down = true;
          ctx_others.strokeStyle = data.color;
          ctx_others.beginPath();
          return ctx_others.moveTo(data.x, data.y);
        case "move":
          console.log("remote: " + data.x, data.y);
          ctx_others.lineTo(data.x, data.y);
          return ctx_others.stroke();
        case "up":
          if (!remote_down) return;
          ctx_others.lineTo(data.x, data.y);
          ctx_others.stroke();
          ctx_others.closePath();
          return remote_down = false;
      }
    });
    down = false;
    canvas.addEventListener("mousedown", (function(e) {
      down = true;
      ctx.beginPath();
      ctx.moveTo(e.clientX, e.clientY);
      return socket.emit("message", {
        act: "down",
        x: e.clientX,
        y: e.clientY,
        color: ctx.strokeStyle
      });
    }), false);
    window.addEventListener("mousemove", (function(e) {
      if (!down) return;
      console.log(e.clientX, e.clientY);
      ctx.lineTo(e.clientX, e.clientY);
      ctx.stroke();
      return socket.emit("message", {
        act: "move",
        x: e.clientX,
        y: e.clientY
      });
    }), false);
    window.addEventListener("mouseup", (function(e) {
      if (!down) return;
      ctx.lineTo(e.clientX, e.clientY);
      ctx.stroke();
      ctx.closePath();
      down = false;
      return socket.emit("message", {
        act: "up",
        x: e.clientX,
        y: e.clientY
      });
    }), false);
    clear_button = document.getElementById("clear");
    clear_button.addEventListener("click", (function(e) {
      return clear(canvas);
    }), false);
    document.getElementById("save").addEventListener("click", (function(e) {
      save(canvas_others, "others");
      return save(canvas, "mine");
    }), false);
    document.getElementById("load").addEventListener("click", (function(e) {
      load(canvas_others, "others");
      return load(canvas, "mine");
    }), false);
    colors = document.getElementById("colors").childNodes;
    i = 0;
    color = void 0;
    _results = [];
    while (color = colors[i]) {
      if (color.nodeName.toLowerCase() !== "div") continue;
      color.addEventListener("click", (function(e) {
        var style;
        style = e.target.getAttribute("style");
        color = style.match(/background:(rgba.*,.*,.*,.*\))/)[1];
        console.log(color);
        return ctx.strokeStyle = color;
      }), false);
      _results.push(i++);
    }
    return _results;
  }), false);

}).call(this);
