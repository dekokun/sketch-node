(function() {
  var routes, should;

  routes = process.env.TEST_COV ? require("../lib-cov/routes/index") : require("../lib/routes/index");

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
      it("タイトルがスケッチ", function(done) {
        res.render = function(view, vars) {
          view.should.equal("index");
          return done();
        };
        return routes.index(req, res);
      });
      return it("indexのviewが呼び出されていること", function(done) {
        res.render = function(view, vars) {
          view.should.equal("index");
          return done();
        };
        return routes.index(req, res);
      });
    });
  });

}).call(this);
