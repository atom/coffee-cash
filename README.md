# Coffee Cash [![Build Status](https://travis-ci.org/atom/coffee-cash.svg?branch=master)](https://travis-ci.org/atom/coffee-cash)

Simple CoffeeScript caching based on a SHA-1 of the contents.

## Installing

```sh
npm install coffee-cash
```

## Usage

```coffee
CoffeeCache = require 'coffee-cash'
CoffeeCache.setCacheDirectory('/tmp/cache/coffee')
CoffeeCache.register()

# CoffeeScript is now registered so you can require .coffee files
# and they will be automatically use cached JavaScript when available
require('./foo.coffee')
```
