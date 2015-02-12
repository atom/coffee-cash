crypto = require 'crypto'
path = require 'path'

CoffeeScript = null # defer until used
fs = require 'fs-plus'

stats =
  hits: 0
  misses: 0
cacheDirectory = null

getCachePath = (coffee) ->
  digest = crypto.createHash('sha1').update(coffee, 'utf8').digest('hex')
  path.join(cacheDirectory, "#{digest}.js")

getCachedJavaScript = (cachePath) ->
  if fs.isFileSync(cachePath)
    try
      cachedJavaScript = fs.readFileSync(cachePath, 'utf8')
      stats.hits++
      return cachedJavaScript
  return

convertFilePath = (filePath) ->
  if process.platform is 'win32'
    filePath = "/#{path.resolve(filePath).replace(/\\/g, '/')}"
  encodeURI(filePath)

compileCoffeeScript = (coffee, filePath, cachePath) ->
  CoffeeScript ?= require 'coffee-script'
  {js, v3SourceMap} = CoffeeScript.compile(coffee, filename: filePath, sourceMap: true)
  stats.misses++

  if btoa? and unescape? and encodeURIComponent?
    js = """
      #{js}
      //# sourceMappingURL=data:application/json;base64,#{btoa unescape encodeURIComponent v3SourceMap}
      //# sourceURL=#{convertFilePath(filePath)}
    """

  try
    fs.writeFileSync(cachePath, js)
  js

requireCoffeeScript = (module, filePath) ->
  coffee = fs.readFileSync(filePath, 'utf8')
  cachePath = getCachePath(coffee)
  js = getCachedJavaScript(cachePath) ? compileCoffeeScript(coffee, filePath, cachePath)
  module._compile(js, filePath)

module.exports =
  register: (newCacheDirectory) ->
    cacheDirectory = newCacheDirectory

    extensionsProperty = {writable: false, value: requireCoffeeScript}
    Object.defineProperty(require.extensions, '.coffee', extensionsProperty)
    Object.defineProperty(require.extensions, '.litcoffee', extensionsProperty)
    Object.defineProperty(require.extensions, '.coffee.md', extensionsProperty)

  getCacheMisses: -> stats.misses

  getCacheHits: -> stats.hits
