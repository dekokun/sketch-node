(function() {
  var should;

  should = require("should");

  describe("calc", function() {
    return describe(".add", function() {
      return it("should return sum of 2 arguments", function() {
        var result;
        result = 1 + 2;
        return result.should.equal(3);
      });
    });
  });

}).call(this);
