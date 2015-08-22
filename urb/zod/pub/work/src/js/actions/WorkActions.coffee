Dispatcher   = require '../dispatcher/Dispatcher.coffee'
Persistence  = require '../persistence/Persistence.coffee'

module.exports =
  newItem: (index,_item={}) ->
    item =
      id:             window.util.uuid32()
      version:        0
      owner:          window.urb.ship
      date_created:   Date.now()
      date_modified:  Date.now()
      date_due:       _item.date_due    ? null
      done:           _item.done        ? null
      status:         _item.status      ? 'announced'
      tags:           _item.tags        ? []
      title:          _item.title       ? ''
      description:    _item.description ? ''
      discussion:     _item.discussion  ? []
      audience:       _item.audience    ?
        ["~zod/share", window.util.talk.mainStationPath window.urb.ship]
    Persistence.put "new":item
    Dispatcher.handleViewAction {type:'newItem', index, item}

  setItem: ({id,version},key,val) ->
    set = {}
    key = key.split('_').join '-'
    set[key] = val
    version += 1
    Persistence.put old:{id,version,dif:{set}}

  ownItem: ({id,version},own) ->
    o = {}
    o[own] = null
    version += 1
    Persistence.put old:{id,version,dif:own:o}

  addComment: ({id,version},val) ->
    version += 1
    Persistence.put old:{id,version,dif:add:comment:val}

  setFilter: (key,val) ->
    Dispatcher.handleViewAction
      type:'setFilter'
      key:key
      val:val

  setSort: (key,val) ->
    Dispatcher.handleViewAction
      type:'setSort'
      key:key
      val:val

  swapItems: (to,from) ->
    Dispatcher.handleViewAction
      type:'swapItem'
      from:from
      to:to

  removeItem: ({id,version},index) ->
    Persistence.put old:{id,version,dif:set:done:true}
    Dispatcher.handleViewAction
      type:'removeItem'
      index:index

  addItem: (index,item) ->
    Dispatcher.handleViewAction
      type:'addItem'
      index:index
      item:item
      
  listenList: (type)->
    Persistence.subscribe type, (err,d)-> 
      if d?
        {sort,tasks} = d.data
        Dispatcher.handleServerAction {type:"getData",sort,tasks}
