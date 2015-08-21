urb.appl = 'work'
listeners = {}
cache = null
urb.bind "/repo", (err,dat)->
  if err 
    document.write err
  else 
    cache = dat
    (cb null,dat) for k,cb of listeners
module.exports =
  put: (update,cb) -> urb.send(update,{mark:'work-command'},cb)
  subscribe: (key,cb) -> 
    listeners[key] = cb
    (cb null,cache) if cache?
