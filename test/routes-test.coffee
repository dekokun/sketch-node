routes = if process.env.TEST_COV then require "../lib-cov/routes/index" else require "../lib/routes/index"
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
    it "タイトルがスケッチ", (done) ->
      res.render = (view, vars) ->
        view.should.equal "index"
        done()
      routes.index(req, res)

    it "indexのviewが呼び出されていること", (done) ->
      res.render = (view, vars) ->
        view.should.equal "index"
        done()
      routes.index(req, res)
