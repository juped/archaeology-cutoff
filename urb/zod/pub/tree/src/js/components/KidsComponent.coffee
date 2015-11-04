reactify    = require './Reactify.coffee'
query       = require './Async.coffee'

recl = React.createClass
{div,a,ul,li,hr} = React.DOM

module.exports = query {kids: {body:'r', meta:'j'}}, recl
  displayName: "Kids"
  render: -> 
    klass = "kids"
    if @props.dataType then klass += " #{@props.dataType}"

    sorted = true
    keyed = {}
    for k,v of @props.kids
      if @props.sortBy
        if @props.sortBy is 'date'
          if not v.meta?.date?
            sorted = false
            continue
          d = v.meta.date.slice(1).split "."
          if d.length < 3 
            sorted = false
            continue
          str = "#{d[0]}-#{d[1]}-#{d[2]}"
          if d.length > 3
            str += " #{d[3]}:#{d[4]}:#{d[5]}"
          _k = Number(new Date(str))
          keyed[_k] = k
      else
        if not v.meta?.sort? then sorted = false
        keyed[Number(v.meta?.sort)] = k

    if sorted isnt true 
      _keys = _.keys(@props.kids).sort()
    else
      _keys = _.keys(keyed).sort()

    if @props.sortBy is 'date' then _keys.reverse()

    div {className:klass},
      for item in _keys
        elem = @props.kids[keyed[item]]
        [(div {key:item}, reactify elem.body), (hr {},"")]
