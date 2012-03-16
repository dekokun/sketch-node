routes = require "../routes/index"
should = require "should"

describe "routes", ->
  req =
    params: {}
    body: {}
  res =
    redirect: (route) ->
      #do nothing
    render: (view, vars)->
      #do nothing

  describe "index", ->
    it "should be title Sketch", (done) ->
      res.render = (view, vars) ->
        view.should.equal "index"
        done()
      routes.index(req, res)

    it "should vbe view index", (done) ->
      res.render = (view, vars) ->
        view.should.equal "index"
        done()
      routes.index(req, res)
