class ScanError extends Error
  constructor: (errorList) ->
    @name = 'ScanError'
    @message = errorList?.reduce ((prev, cur) ->
      prev + cur.getMessage() + '\n '), ''

module.exports = ScanError
