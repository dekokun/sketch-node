should = require("should")

describe "calc", ->
  describe ".add", ->
    it "should return sum of 2 arguments", ->
      result = 1 + 2
      result.should.equal 3

