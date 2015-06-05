recl = React.createClass
div = React.DOM.div
a = React.DOM.a
b = React.DOM.button
hr = React.DOM.hr
table = React.DOM.table
th = React.DOM.th
tr = React.DOM.tr
td = React.DOM.td
input = React.DOM.input

DOControls = React.createClass({
  createDroplet: function(){
    urb.send({appl: "cloud",
              data: {
                    action:'create-do',
                    name:$('#name').val(),
                    region:$('#region').val(),
                    size:$('#size').val(),
                    image:$('#image').val(),
                    ssh:[], // $('#ssh').val()]
                    backups:null,//$('#backups').val(),
                    ipv6:null,//$('#ipv6').val(),
                    priv_networking:null,//$('#priv-networking').val(),
                    user_data:null//$('#user-data').val()
                    },
              mark: "json"})
  },

  render: function(){
      href = "https://cloud.digitalocean.com/v1/oauth/authorize?client_id=d8f46b95af38c1ab3d78ad34c2157a6959c23eb0eb5d8e393f650f08e6a75c6f&redirect_uri=http%3A%2F%2Flocalhost%3A8443%2Fhome%2Fpub%2Fcloud%2Ffab&response_type=code&scope=read+write"
    return (
      div({}, [
        div({},
          a({href:href},"get authcode"),
          b({onClick:this.props.handleClick('do')}, "Send Authcode")
        ),
        div({}, [
          input({id:"appsecret"}, 
          b({onClick:this.props.sendSecret('do','#appsecret')}, "Send Secret"))
        ]),

        div({}, [
          b({onClick:this.createDroplet}, "Create Droplet"),
          input({id:"name",placeholder:"Name of droplet"}), 
          input({id:"region",placeholder:"Region"}),
          input({id:"size",placeholder:"Size (str ending in mb"}),
          input({id:"image",placeholder:"Image"}),
          input({id:"ssh",placeholder:"ssh keys (optional)"}),
          input({id:"backups",placeholder:"backups (optional)"}),
          input({id:"ipv6",placeholder:"ipv6 (boolean, optional)"}),
          input({id:"user-data",placeholder:" user-data string (optional)"}),
          input({id:"priv-networking",placeholder:"Private Networking (boolean, optional)"})
        ])
      ])
    )
  }
})

GCEControls = React.createClass({
  createDroplet: function(){
  urb.send({
    appl: 'cloud',
    data: {action:'create-gce',
          project:$('#project').val(),
          zone:$('#zone').val(),
          name:$('#gname').val(),
          machine_type:$('#machine_type').val()
          },
    mark: 'json'})
  },

  createDisk: function(){
      urb.send({
        appl: 'cloud',
        data: {action:'create-gce-disk',
               snap:$('#gsnap').val(),
               number:$('#number').val(),
               name:$('#gcpName').val()},
        mark: 'json'})
  },

  render: function(){
    ghref = "https://accounts.google.com/o/oauth2/auth?response_type=token&scope=https://www.googleapis.com/auth/compute&redirect_uri=http://localhost:8443/home/pub/cloud/fab&client_id=719712694742-6htfj2t9s1j2jid92rc4dfq9psrr9qpo.apps.googleusercontent.com"
    return(
      div({}, [
        div({}, [
          b({onClick:this.createDisk}, 'Create Disk From Image'),
          input({id:'gcpName',placeholder:'Name for GCE Disk and Instance'}),
          input({id:'number',placeholder:'Number of instances'}),
          input({id:'gsnap',placeholder:'Snapshot'})
        ]),
        div({}, [
          a({href:ghref},"Get Google Authcode"),
          b({onClick:this.props.handleClick('gce')}, "Send Google Authcode")
        ]),
        div({}, [
          input({id:"gappsecret"}, 
          b({onClick:this.props.sendSecret('gce','#gappsecret')}, "Send Google Secret"))
        ]),
        div({}, [
          b({onClick:this.createDroplet}, "Create Droplet"),
          input({id:"project",placeholder:"project"}),
          input({id:"zone",placeholder:"zone"}),
          input({id:"gname",placeholder:"Name of droplet"}), 
          input({id:"machine_type",placeholder:"Machine Type"}),
          //input({id:"image",placeholder:"Image"}),
      ])
    ]))
  }
})

Droplet = React.createClass({
  dropletAction:function(id, action){
    urb.send({
      appl:"cloud",
      data: {action: action,
            id: id}})
  },

  render: function() {
    var $this = this    //local var, else it always points at second
    var acts = ["start","stop","reboot","delete"]
    var buttons = [];
    var buttons = acts.map(function(act){
      return b({onClick:function(){
        $this.dropletAction($this.props.id, act)
      }}, act)
    })     
    kay = Object.keys(this.props)
    kay = kay.filter(function(b){return b!="children"}) //  XX individually adress props
  return div({},
    buttons,
    table({},
      tr({},kay.map(function(k){return th({},k)})),
      tr({},kay.map(function(k){return td({},JSON.stringify($this.props[k]))}))),
    hr())
  }
})

Page = recl({
  handleClick: function(platform){
  return  function(){
      console.log(platform);
      if(window.authcode.length !== ''){
        urb.send({
          appl: "cloud",
          data: {authcode:window.authcode,
                platform:platform},
          mark: "cloud-auth"})
      } else { console.log("nocode") }
    }
  },

  sendSecret: function(platform,codeid){
    return function(){
    console.log(platform,codeid)
        secret= $(codeid).val()
        if(secret !== '') {
          urb.send({appl: "cloud",
                    data: {secret:secret,
                          platform:platform},
                    mark: "cloud-secret"})
        }
    }
  },

  getList: function(){
    urb.send({appl: "cloud",
              data: {action:"list"},
              mark: "json"})
  },


  render: function(){
      return (div({},
        DOControls({handleClick:this.handleClick,sendSecret:this.sendSecret}), 
        GCEControls({handleClick:this.handleClick,sendSecret:this.sendSecret}),
        this.props.droplets.map(Droplet)
      ))
  }
})


mounted = React.render(Page({droplets:[]}), $("#container")[0])
urb.bind("/", function(err,d) {

  mounted.setProps({droplets:d.data})
return}) 
