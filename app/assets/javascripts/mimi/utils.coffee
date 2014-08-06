class Mimi.Utils
  @findElements = (json, parent) ->
    result = {}
    for key, value of json
      if typeof(json[key]) == "string"
        result[key] = $(json[key], parent)
      else if typeof(json[key]) == "object"
        result[key] = @findElements(json[key], parent)
    result
