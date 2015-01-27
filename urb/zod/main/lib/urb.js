window.urb.seqn_s = 0

window.urb.send = function(params,cb) {
  if(!params)
    throw new Error("You must supply params to urb.send.")
  if(!params.appl) {
    if(!urb.appl)
      throw new Error("You must specify an appl for urb.send.")
    params.appl = urb.appl
  }
  if(!params.data) { params.data = {}; }

  var method, perm, url, $this

  type = params.type ? params.type : "mes"
  perm = this.perms[type]

  params.ship = params.ship ? params.ship : this.ship
  params.mark = params.mark ? params.mark : "json"

  method = "put"
  url = [perm,this.user,this.port,this.seqn_s]
  url = "/"+url.join("/")

  this.seqn_s++

  $this = this
  this.qreq(method,url,params,true,function(err,data) {
    if(err) { $this.seqn_s--; }
    if(cb) { cb.apply(this,arguments); }
  })
}

window.urb.subscribe = function(params,cb) {
  if(!cb)
    throw new Error("You must supply a callback to urb.subscribe.")
  if(!params)
    throw new Error("You must supply params to urb.subscribe.")
  if(!params.appl) {
    if(!urb.appl)
      throw new Error("You must specify an appl for urb.subscribe.")
    params.appl = urb.appl
  }
  if(!params.path)
    throw new Error("You must specify a path for urb.subscribe.")
  params.ship = params.ship ? params.ship : this.ship

  var method, perm, url, $this

  params.type = "sub"

  this.cabs[this.gsig(params)] = cb

  url = [this.perms["sub"],this.user,this.port]
  url = "/"+url.join("/")
  method = "put"

  $this = this
  this.qreq(method,url,params,true,function(err,data) {
    if(cb) { cb.apply(this,[err,{status: data.status, data: data.data}])}
    if(!err && $this.puls == 0) {
      params.type = "pol"
      $this.poll(params)
    }
  })
}

window.urb.unsubscribe = function(params,cb) {
  if(!params)
    throw new Error("You must supply params to urb.unsubscribe.")
  if(!params.appl) {
    if(!urb.appl)
      throw new Error("You must specify an appl for urb.unsubscribe.")
    params.appl = urb.appl
  }
  if(!params.path)
    throw new Error("You must specify a path for urb.unsubscribe.")
  params.ship = params.ship ? params.ship : this.ship

  method = "put"
  type = "uns"
  url = [this.perms[type],this.user,this.port]
  url = "/"+url.join("/")

  var $this = this
  this.req(method,url,params,true,function(err,data) {
    cb(err,data)
  })
}

window.urb.util = {
  toDate: function (dat){
    var mils = Math.floor((0x10000 * dat.getUTCMilliseconds()) / 1000).toString(16)
    function pad(num, str){
      return ((new Array(num + 1)).join('0') + str).substr(-num,num)
    }
    return  '~' + dat.getUTCFullYear() + 
            '.' + (dat.getUTCMonth() + 1) + 
            '.' + dat.getUTCDate() + 
           '..' + pad(2, dat.getUTCHours()) + 
            '.' + pad(2, dat.getUTCMinutes()) + 
            '.' + pad(2, dat.getUTCSeconds()) + 
           '..' + pad(4, mils)
  }
}
