(function() {
  var app, express, io, routes;

  express = require("express");

  routes = require("./lib/routes");

  app = module.exports = express.createServer();

  app.configure(function() {
    app.set("views", __dirname + "/views");
    app.set("view engine", "jade");
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
    return app.use(express.static(__dirname + "/public"));
  });

  app.configure("development", function() {
    return app.use(express.errorHandler({
      dumpExceptions: true,
      showStack: true
    }));
  });

  app.configure("production", function() {
    return app.use(express.errorHandler());
  });

  io = require("socket.io").listen(app);

  io.sockets.on("connection", function(socket) {
    return socket.on("message", function(data) {
      socket.broadcast.emit("message", data);
      return console.log(data);
    });
  });

  app.get("/", routes.index);

  app.listen(process.env.PORT || 3000);

  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);

}).call(this);
