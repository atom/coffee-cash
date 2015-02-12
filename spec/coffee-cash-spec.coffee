temp = require 'temp'
CoffeeCache = require '../src/coffee-cash'

describe "Coffee Cache", ->
  it "caches the compiled CoffeeScript", ->
    cachePath = temp.mkdirSync('coffee-cash')
    CoffeeCache.register(cachePath)
    expect(CoffeeCache.getCacheMisses()).toBe 0
    expect(CoffeeCache.getCacheHits()).toBe 0

    sample = require('./fixtures/sample')
    expect(sample(2)).toBe 4
    expect(CoffeeCache.getCacheMisses()).toBe 1
    expect(CoffeeCache.getCacheHits()).toBe 0

    duplicateSample = require('./fixtures/duplicate')
    expect(duplicateSample).not.toBe sample
    expect(duplicateSample(2)).toBe 4
    expect(CoffeeCache.getCacheMisses()).toBe 1
    expect(CoffeeCache.getCacheHits()).toBe 1
