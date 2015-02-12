path = require 'path'
temp = require 'temp'
CoffeeCache = require '../src/coffee-cash'

describe "Coffee Cache", ->
  cachePath = null

  beforeEach ->
    cachePath = temp.mkdirSync('coffee-cash')
    CoffeeCache.setCacheDirectory(cachePath)
    CoffeeCache.resetCacheStats()
    CoffeeCache.register()

    expect(CoffeeCache.getCacheMisses()).toBe 0
    expect(CoffeeCache.getCacheHits()).toBe 0
    expect(CoffeeCache.getCacheDirectory()).toBe cachePath

  it "caches the compiled CoffeeScript", ->
    sample = require('./fixtures/sample')
    expect(sample(2)).toBe 4
    expect(CoffeeCache.getCacheMisses()).toBe 1
    expect(CoffeeCache.getCacheHits()).toBe 0

    duplicateSample = require('./fixtures/duplicate')
    expect(duplicateSample).not.toBe sample
    expect(duplicateSample(2)).toBe 4
    expect(CoffeeCache.getCacheMisses()).toBe 1
    expect(CoffeeCache.getCacheHits()).toBe 1

  describe "addPathToCache", ->
    it "compiles the file and caches it", ->
      filePath = path.join(__dirname, 'fixtures', 'added.coffee')
      CoffeeCache.addPathToCache(filePath)
      expect(CoffeeCache.getCacheMisses()).toBe 1
      expect(CoffeeCache.getCacheHits()).toBe 0

      added = require(filePath)
      expect(added(5)).toBe 6
      expect(CoffeeCache.getCacheMisses()).toBe 1
      expect(CoffeeCache.getCacheHits()).toBe 1
