recl = React.createClass
{div,textarea} = React.DOM

WorkActions   = require '../actions/WorkActions.coffee'

module.exports = recl
  onDragStart: (e) ->
    $t = $(e.target)
    @dragged = $t.closest('.item')
    e.dataTransfer.effectAllowed = 'move'
    e.dataTransfer.setData 'text/html',e.currentTarget
    @props._dragStart e,@
  
  onDragEnd: (e) -> @props._dragEnd e,@

  onKeyDown: (e) -> 
    @props._keyDown e,@

    kc = e.keyCode

    switch kc
      # tab - expand
      when 9
        if @state.expand is false
          @setState {expand:true}
      # esc - collapse
      when 27
        @setState {expand:false}

    if (kc is 9 and @state.expand is false) or (kc is 27) 
      e.preventDefault()
      return

  getVal: ($el,key) ->
    if $el[0].tagName is 'TEXTAREA'
      return $el.val()
    else
      if key is 'date_due'
        d = $el.text().slice(1).replace(/\./g, "-")
        return NaN if d.length < 8
        return new Date(d).valueOf()      
      if key is 'tags'
        return $el.text().trim().split(" ")
      if key is 'audience'
        a = $el.text().trim().split(" ")
        a = a.map (_a) -> "~#{_a}"
        return a
      return $el.text()

  compareVal: (l,n,key) ->
    if key is 'tags' or key is 'audience'
      return (_.xor(l,n).length > 0)
    if key is 'date_due'
      return l isnt new Date(n)
    l isnt n

  validateField: ($t,key,val) ->
    valid = 1
    if key is 'date_due'
      valid = 0 if isNaN(val)
    if key is 'audience'
      i = _.filter val,(a) -> 
        if a[0] isnt "~"
          return 0
        if a.split("/").length < 2
          return 0
        if a.split("/")[0].length < 3 or
        a.split("/")[1].length < 3
          return 0
        1
      valid = 0 if i.length isnt val.length
    valid

  onKeyUp: (e) ->
    $t = $(e.target).closest '.field'
    key = $t.attr 'data-key'
    val = @getVal $t.find('.input'),key

    if @compareVal @props.item[key],val,key
      if not @validateField($t,key,val) 
        $t.addClass 'invalid'
        return
      $t.removeClass 'invalid'
      if @to then clearTimeout @to
      @to = setTimeout => 
          WorkActions.setItem @props.item,key,val
        ,1000

  onFocus: (e) -> @props._focus e,@

  _markDone: (e) -> WorkActions.setItem @props.item,'done',true

  _claim: (e) ->

  _release: (e) ->

  _submitComment: (e) ->
    $t = $(e.target).closest('.item')
    val = $t.find('.comment .input').text()

    WorkActions.addComment @props.item,val

  formatDate: (d) ->
    return "" if d is null
    "~#{d.getFullYear()}.#{(d.getMonth()+1)}.#{d.getDate()}"

  formatOwner: (o) ->
    return "" if o is null
    o.replace /\~/g,""

  formatAudience: (a) ->
    @formatOwner a.join(" ")

  getInitialState: -> {expand:false}

  renderField: (key,props,format=_.identity)->
    _props = _.extend {}, props, {contentEditable:true,className:'input ib'}
    className = "#{props.className ? key} field ib"
    (div {className,'data-key':key}, (div _props, format(@props.item[key])))
  
  renderTopField: (key,props,format)->
    _props = _.extend {className:"#{props.className ? key} top"}, props
    @renderField key,_props,format
  
  render: ->
    itemClass = 'item'
    if @state.expand then itemClass += ' expand'

    owner = []
    if @props.item.owner?.slice(1) is window.urb.ship
      k = 'mine'
      owner.push (div {className:'release a',onClick:@_release},'Release')
    if @props.item.owner is null
      k = 'open'
      owner.push (div {className:'claim a',onClick:@_claim}, "Claim")
    owner.unshift (div {className:k},@formatOwner(@props.item.owner))

    (div {
        className:itemClass
        draggable:true
        @onDragStart,@onDragEnd
      }, [
        (div {className:'owner ib','data-key':'owner'},owner)
        (@renderField 'audience', {}, @formatAudience) # no onKeyUp?
        (div {className:'sort ib top'}, @props.item.sort)
        (div {className:'done ib', onClick:@_markDone}, '')
        (@renderTopField 'title', {@onFocus,@onKeyDown,@onKeyUp})
        (@renderTopField 'date_due', {@onKeyUp,className:'date'}, @formatDate)
        (@renderTopField 'tags', {@onKeyUp}, (tags)-> tags.join(" "))
        (div {
          className:'expand ib',
          onClick: (e) => @setState {expand:!@state.expand}
          }, (div {className:'caret left'},"")
        )
        (@renderField 'description',{@onKeyUp})
      
        (div {className:"hr"},"")
        (div {className:"discussion"},[
          (div {className:"comments"}, @props.item.discussion.map (slug) =>
              (div {className:'comment'}, [
                (div {className:'hr2'},"")
                (div {className:'ship ib'}, slug.ship)
                (div {className:'date ib'}, @formatDate(slug.date))
                (div {className:'body'}, slug.body)
              ])
          ),
          (div {className:'new comment'},[
              (div {className:'hr2'},"")
              (div {className:'ship ib'}, window.urb.ship)
              (div {className:'date ib'}, @formatDate(new Date()))
              (div {
                contentEditable:true,
                className:'input'},"")
              (div {className:'submit',onClick:@_submitComment},'Post')
          ])
        ])
    ])
