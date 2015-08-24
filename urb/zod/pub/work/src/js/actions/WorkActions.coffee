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
        [window.util.talk.mainStationPath window.urb.ship]
    Persistence.put new:item
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

  removeItem: ({id}) ->
    Persistence.put audience:{id,to:[]}
    Dispatcher.handleViewAction {type:'archiveItem',id}
  
  setAudience: ({id},to) ->
    Persistence.put audience:{id,to}
    Dispatcher.handleViewAction {type:'setAudienece',id,to}

  addComment: ({id,version},val) ->
    version += 1
    Persistence.put old:{id,version,dif:add:comment:val}

  setFilter: (key,val) -> Dispatcher.handleViewAction {type:'setFilter', key,val}
  setSort: (key,val) -> Dispatcher.handleViewAction {type:'setSort',key,val}
  moveItem: (list,to,from) ->
    sort = _.clone list
    sort.splice to, 0, sort.splice(from,1)[0]
    Persistence.put {sort}
    Dispatcher.handleViewAction {list:sort,to,from,type:'moveItems'}  

  listenList: (type)->
    Persistence.subscribe type, (err,d)-> 
      if d?
        {sort,tasks} = d.data
        Dispatcher.handleServerAction {type:"getData",sort,tasks}
