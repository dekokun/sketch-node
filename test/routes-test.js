(function() {
  var routes, should;

  routes = require("../routes/index");

  should = require("should");

  describe("routes", function() {
    var req, res;
    req = {
      params: {},
      body: {}
    };
    res = {
      redirect: function(route) {},
      render: function(view, vars) {}
    };
    return describe("index", function() {
      it("should be title Sketch", function(done) {
        res.render = function(view, vars) {
          view.should.equal("index");
          return done();
        };
        return routes.index(req, res);
      });
      return it("should vbe view index", function(done) {
        res.render = function(view, vars) {
          view.should.equal("index");
          return done();
        };
        return routes.index(req, res);
      });
    });
  });

}).call(this);
