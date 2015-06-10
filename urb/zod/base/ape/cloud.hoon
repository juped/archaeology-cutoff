::  digital ocean fleet management
::
::::
  ::
/?  314
/-  *talk
/+  talk, sole, http

::
::
::::  sivtyv-barnel
  ::
             
!:
|%
++  instance
$:  plat=?(%do %gce)  name=@t  id=@t  status=@t  created=@da  snapshot=name=@t  ::disk=@u  region=@t  
::ip=(list ,@if)
==
++  image
$:  plat=?(%do %gce)  name=@t  id=@t
==
++  create-req-do
$:
name=@t  ::region=@t
size=@t  image=@t  ssh=(list cord)
backups=(unit ,?)  ipv6=(unit ,?)
private-networking=(unit ,?)  user-data=(unit ,@t)
==
++  create-req-gce  ,[project=@t zone=@t name=@t machine-type=@t]
++  axle
$:  auth=[do=keys gce=keys]  toke=[do=tokens gce=tokens]
    insts=(map ,@t instance)  images=(map [,[@t @t] image])
==
++  keys  ,[authc=(unit ,@t) client-secret=(unit ,@t)]
++  tokens  ,[access=@t refresh=@t]
++  move  ,[bone card]
++  card
$%  [%diff %json json]
    [%wait wire @da]
    [%send wire [ship term] %poke %talk-command command]
    [%them wire (unit hiss)]
==
++  droplet-action
$%  [%start ~]
    [%stop ~]
    [%reboot ~]
    [%delete ~]
    [%snapshot p=@t]
==
++  cloud-command
$%  [%action id=@t name=@t act=droplet-action]
    [%create-do p=json]
    [%create-gce p=json]
==
--
!:
|% :::
++  parse-iso8601
  =<  (cook to-time (parsf ;"{parse-day}T{parse-seconds}{parse-zone}"))
  |%
  ++  to-time
     |=  [[y=@u m=@u d=@u] t=[h=@u m=@u s=@u ms=@u] [syn=? zh=@u zm=@u]]
     ^-  @da
     %-  year
     ^-  date
     =:  h.t  ?:(syn (sub h.t zh) (add h.t zh))
         m.t  ?:(syn (sub m.t zm) (add m.t zm))
       == 
     [[& y] m d h.t m.t s.t (div (mul ms.t 0x1.0000) 1.000) ~]
  ++  parse-day    (parsf ;"{dem}\-{dem}\-{dem}")
  ++  parse-seconds  (parsf ;"{dem}:{dem}:{dem}{(optional ;~(pfix dot dem))}")
  ++  optional  |*(fel=_rule ;~(pose fel (easy 0)))
  ++  parse-zone
    ;~  pose 
      (cold [& 0 0] (jest 'Z')) 
      (parsf ;"{parse-zone-sign}{dem}:{dem}")
    ==
  ++  parse-zone-sign  ;~(plug ;~(pose (cold & lus) (cold | hep)))
  --
++  parse-cloud-command
  =+  jo
  %-   of  :~
    [%create-do some]
    [%create-gce some]
    :-  %action 
    (ot id/so name/so act/parse-droplet-action ~)
  ==
++  parse-droplet-action
  =>  jo
  %-  of  :~
    [%start ul]
    [%stop ul]
    [%reboot ul]
    [%delete ul]
    [%snapshot so]
  ==
++  key-do
  (mo [%start 'power_on'] [%stop 'shutdown'] [%reboot 'power_cycle'] ~)
++  adapter-do
  |=  a=cord
  (~(got by key-do) a)
++  parse-ip-do
  =>  jo
  %-  ot  
  :_  ~  v4/(ar (ot 'ip_address'^(su lip:ag) ~))
++  parse-ip-gce
  =>  jo
  %+  cu  |=(a=(list (list ,@if)) `(list ,@if)`(zing a))
  (ar (ot 'accessConfigs'^(ar (ot 'natIP'^(su lip:ag) ~)) ~))
++  tail-url
  |=  a=cord
  -:(flop q.q:(need (epur a)))
++  parse-region
  =>  jo
  (ot name/so ~)
++  parse-id-text
  |=  jon=json
  ?.(?=([?(%n %s) *] jon) ~ (some p.jon))
++  create-do-body
  |=  $:  name=@t  ::region=@t
      size=@t  image=@t  ssh-keys=(list cord)
      backups=(unit ,?)  ipv6=(unit ,?)  private-networking=(unit ,?)  user-data=(unit ,@t)  
  ==
  %-  jobe
  :~  name/s/name  ::region/s/region
      size/s/size  image/s/image ::(jone image)
       backups/?~(backups ~ b/u.backups)  ipv6/?~(ipv6 ~ b/u.ipv6)
      'user_data'^?~(user-data ~ s/u.user-data)  'private_networking'^?~(private-networking ~ b/u.private-networking)
  ==
++  convert-do
  |=  a=?(%start %stop %reboot %snapshot)
  ?-  a
    %start
  'power_on'
    %stop
  'shutdown'
    %reboot
  'power_cycle'
    %snapshot
  'snapshot'
  ==
++  instance-to-json
  |=  a=(list instance)
  ^-  json
  %+  joba  'instances'
  :-  %a
  %+  turn  a
  |=  instance
  ^-  json
  %-  jobe
  :~  name/`json`s/name
      id/s/id
      status/s/status
      created/s/(crip (dust (yore created)))
      ::region/s/region
      snapshot/s/snapshot
  ::    disk/`json`(jone disk)
      ::ip/a/(turn ip |=(a=@if s/(rsh 3 1 (scot %if a))))
  ==
++  map-to-list
  |=  a=(map [,[@t @t] image])
  ^-  liz=(list image)
  %+  turn  (~(tap by a) *(list ,[[@t @t] image]))
  |=(a=[[@t @t] image] `image`+.a)
++  image-to-json
  |=  a=(list image)
  %+  joba  'images'
  :-  %a
  %+  turn  a
  |=  image
  ^-  json
  %-  jobe
  :~  name/s/name  id/s/id  ==
--
!:
|_  [bowl vat=axle]
::
::++  prep  ,_`.
::
++  peer
  |=  pax=path
  ^-  [(list move) _+>.$]
  :_  +>.$
  =+  lis=(~(tap by insts.vat))
  [ost %diff %json (instance-to-json (turn lis |=(a=[@t instance] +.a)))]~
::
++  spam
  |=  jon=json
  %+  turn  (~(tap by sup))
  |=  [sub=bone @ pax=path]
  ^-  move
  [sub %diff %json jon]
++  httpreq
    |=  $:  pour-path=wire
            domain=(list cord)  end-point=path
          req-type=$?(%get %delt [%post json])  headers=math
        queries=quay
        ==
    ^-  move
    =+  ^-  parsed-url=purl
        :+  ^=  host-port                               ::  ++hart
            :+  security=%.y
              port=~
            host=[%.y [path=[%com domain]]]
          endpoint=[extensions=~ point=end-point]       ::  ++pork,
        q-strings=queries                               ::  ++quay
    =+  ^-  request=hiss                                ::  cast to hiss
        :-  parsed-url
        ?@  req-type
          [req-type headers ~]
        [%post headers ~ (tact (pojo +.req-type))]
    :^  ost  %them  pour-path
    `(unit hiss)`[~ request]
::
++  auth-queries  
    |=  code=cord
    :~  'grant_type'^'authorization_code'
        'code'^code
        :-  'client_id'
        'd8f46b95af38c1ab3d78ad34c2157a6959c23eb0eb5d8e393f650f08e6a75c6f'
        'redirect_uri'^'http://localhost:8443/home/pub/cloud/fab'
    ==
::
++  poke-cloud-auth
  |=  [cde=cord typ=cord]
  ^-  [(list move) _+>.$]
  ?:  =(%do typ) 
      =.  authc.do.auth.vat
      [~ cde]
    :_  +>.$  ~
  =.  access.gce.toke.vat
  cde
  :_  +>.$
  :_  list-gce
  (publish [%lin & 'successfully authenticated to gce']~)
::
++  poke-cloud-secret
  |=  [secret=cord typ=cord]
  ^-  [(list move) _+>.$]
  ?+    typ  ~|(missing-platform=typ !!)
      %do
    =.  client-secret.do.auth.vat
      [~ secret]
    :_  +>.$
    :_  ~
    %+  httpreq  /auth/do
    :^    ~[%digitalocean %cloud]  `path`/v1/oauth/token
        [%post ~]
    :-  ~  `quay`['client_secret'^secret (auth-queries (need authc.do.auth.vat))]
  ==
::
++  receive-auth
  |=  [pour-path=path resp=httr]
  ^-  [(list move) _+>.$]
  ~|  resp
  =+  body=(rash q:(need r.resp) apex:poja)
  ~|  recieve-auth/resp(r body)
  =+  [ac re]=(need ((ot 'access_token'^so 'refresh_token'^so ~):jo body))
  =:  access.do.toke.vat   ac
      refresh.do.toke.vat  re
    == 
  :_  +>.$
  :-  (publish [%lin & 'successfully authenticated']~)
  list-do
::
++  poke-json
  |=  jon=json
  ^-  [(list move) _+>.$]
  ~&  receive-act/jon
  =+  action=`cloud-command`(need (parse-cloud-command jon))
  :_  +>.$
  ?-  -.action
      %create-do
    [(create-do p.action)]~
  ::
      %create-gce
    ::(create-gce-disks p.action)
    ~[(create-gce 'name')]
  ::
      %action
    [(instance-action [id name act]:action)]~
  ==
::
++  instance-action
  |=  [id=@t name=@t action=droplet-action]
  =+  d=(~(got by insts.vat) id)
  ~|  'can\'t find id'
  =+  typ=?~(d !! -.d)
  ?-  typ
    %do
        =+  ^=  meth
            ?:  ?=(%delete -.action)  
              %delt  
            [%post (jobe type/s/(convert-do -.action) ?.(?=(%snapshot -.action) ~ [name/s/p.action ~]))]
        ^-  move
        =+  ^=  req
        %-  httpreq  :*
           /do/[-.action]
          ~[%digitalocean %api]  
          ?:(?=(%delt meth) /v2/droplets/[id] /v2/droplets/[id]/actions)
          meth
          %^  mo  ['Content-Type' 'application/json' ~]
          ['Authorization' (cat 3 'Bearer ' access.do.toke.vat) ~]  ~
          *quay
         ==
        req
    %gce
        =+  ^=  head-query
        :-  %^  mo  ['Content-Type' 'application/json' ~]
        ['Authorization' (cat 3 'Bearer ' access.gce.toke.vat) ~]  ~
        *quay
      ?-  -.action
        ?(%start %stop %reboot %'snapshot')
          =+  end=/compute/v1/projects/urbcloud/zones/us-central1-a/instances/[name]
          %-  httpreq  :*
              /gce-act/[-.action]    ~['googleapis' 'www']
              (welp end [?:(?=(%reboot -.action) 'reset' -.action) ~])
              [%post ~]           
              head-query
              ==
        %delete
          =+  end=/compute/v1/projects/urbcloud/zones/us-central1-a/instances/[name]
          %-  httpreq  :*
              /gce-act/[-.action]    ~['googleapis' 'www']
              end
              %delt
              head-query
              ==
        ==
    ==
++  thou-do-snapshot
  |=  [pax=path resp=httr]
  ~&  'arrives'
  ~&  response/resp
  :_  +>.$  ~
  ++  thou-gce-act
  |=  [pax=path resp=httr]
  ~&  [resp act/pax]
  :_  +>.$  ~
::
++  create-do
  |=  act=json
  =+  ^-  deets=create-req-do
      %-  need
      %.  act
      =>  jo
      %-  ot
      :~  name/so  size/so  image/so ::  id key:img object  region/so  
      ssh/(ar so)  backups/(mu bo)
      'ipv6'^(mu bo)  'priv_networking'^(mu bo)  'user_data'^(mu so)
      ==
  =+  ^-  body=json
      %-  create-do-body  :*
        name.deets  size.deets  image.deets  ssh.deets  backups.deets  ::region.deets  
        ipv6.deets  private-networking.deets  user-data.deets 
      ==
  %-  httpreq  :*
    /create-do
    ~[%digitalocean %api]  /v2/droplets
    [%post body]
    %^  mo  ['Content-Type' 'application/json; charset=utf-8' ~]
      ['Authorization' (cat 3 'Bearer ' access.do.toke.vat) ~]
    ~
    ~
  ==
::
++  create-gce-disks
  |=  act=json :: num=(unit ,@u)
  ~&  act
  =+  ^-  [name=@t snapshot=@t number=@u snap=@t]
      (need ((ot name/so 'instance_img'^so number/ni snap/so ~):jo act))
  ::
  |-  ^-  (list move)
      ?~  number  ~&  'loop done'  
        ~
      :_  $(number (dec number))
      =+  name=(cat 3 name (scot %ud number))
      =.  number  (dec number)  
      =+  ^-  body=json
          (jobe name/s/name %'sourceSnapshot'^s/'compute/v1/projects/urbcloud/global/snapshots/snapshot-1' ~)  ::^so/snap ~)
      %-  httpreq
      :*  /create-gce-disk/[snap]/[name]
          ~['googleapis' 'www']    /compute/v1/projects/urbcloud/zones/us-central1-a/disks
          [%post body]
         %^  mo  ['Content-Type' 'application/json' ~]
           ['Authorization' (cat 3 'Bearer ' access.gce.toke.vat) ~]
          ~
      ~ 
      ==
::
++  ask-disk-status
  |=  pax=path  ^-  move
  ~&  'ask disk status'
  =+  :-  safe=(slav %uv ?~(pax !! -.pax))
      snap=?.(?=([* ^] pax) !! i.t.pax)
  =+  link=(need (epur ?~(pax !! safe)))
  =.  r.link  ['access_token'^access.gce.toke.vat r.link]
  :^  ost  %them  `wire`/disk-status/snap
  `(unit hiss)`[~ [link [%get ~ ~]]]
::
++  disk-status                       ::receive
  |=  [ins-img=@t resp=httr]
  ^-  [(list move) _+>.$]
  ~&  'disk status called'
  =+  hcode=p.resp
  ?:  =('200' hcode)
    ~|  'did not receive 200'  !!
  =+  :-(parsed=(rash q:(need r.resp) apex:poja) jo)
  ~&  parsed
  =+  :-  status=(need ((ot status/so ~) parsed))
  lin=(need ((ot 'selfLink'^so ~) parsed))
  =+  link=(scot %uv lin)
  ?:  =('DONE' status)
    ~&  'boot disk now running, now starting instance'
    =+  target=(need ((ot 'targetLink'^so ~):jo parsed))
    =+  nam=-:(flop q.q:(need (epur target)))
    :_   +>.$  ~[(create-gce nam ins-img)]
  :_  +>.$
  [ost %wait `path`[%check-status link ins-img ~] `@da`(add ~s3 now)]~       ::  refesh every 10 sec
::
++  create-gce
  |=  name=@t ::snap=@t]
  =+  ^=  image  
      "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/".
      "images/backports-debian-7-wheezy-v20150603"
  =+  src=(cat 3 'compute/v1/projects/urbcloud/zones/us-central1-a/disks/' name)
  =+  ^-  body=json
      %-  jobe
      :~  name/s/name  'machineType'^s/'zones/us-central1-a/machineTypes/n1-standard-1'
      :-  %disks  :-  %a  :_  ~
      ^-  json  (jobe 'initializeParams'^`json`(jobe 'sourceImage'^s/(crip image) ~) ~)   ::boot/b/%.y type/s/'persistent' source/s/src ~)
      :-  'networkInterfaces'  :-  %a  :_  ~
      (joba 'network' `json`[%s 'global/networks/default'])
      ==
  %-  httpreq
  :*  `path`/create-gce
      `(list cord)`~['googleapis' 'www']  `path`/compute/v1/projects/urbcloud/zones/us-central1-a/'instances'
      [%post `json`body]
     %^  mo  ['Content-Type' 'application/json' ~]
       ['Authorization' (cat 3 'Bearer ' access.gce.toke.vat) ~]
    ~
      `quay`[%key access.gce.toke.vat]~
  ==
:: 
++  wake
  |=  [pour-path=path ~]
  ?+    -.pour-path  !!
      %refresh-do
    :_  +>.$
    list-do
      %refresh-gce
    :_  +>.$
    list-gce
      %check-status
    :_  +>.$
    [(ask-disk-status +.pour-path)]~
  ==
::
++  list-gce  
^-  (list move)
:+  (list-something-gce /zones/['us-central1-a']/instances)
    (list-something-gce /global/snapshots)
    ~
++  list-something-gce 
  |=  endpoint=path
  =+  ^=  lis
      :*
      /list-gce/[-.endpoint]
      ~[%googleapis %www]  (welp /compute/v1/projects/urbcloud endpoint)
      %get                    ~
      ^-  quay
      [%'access_token' access.gce.toke.vat]~
      ==
      ~!  lis
      ~!  +<:httpreq
  (httpreq lis)
::
++  thou-list-gce-zones  ::  instances
  |=  [pax=path resp=httr]
  ^-  [(list move) _+>.$]
  =+  parsed=(rash q:(need r.resp) apex:poja)           ::  body httr to json
  ~|  'no list received or bad json'
  =+  items=(need ((ot items/(ar some) ~):jo parsed))
  =+  ^-  ins=(list ,[@t instance])
  ~|  'bad-json'^items
  %+  turn  items
  |=  in=json
  =<  [id .]
  ^-  instance
  :-  %gce
  %-  need
  %.  in  =+  jo
  %-  ot
  :~  name/so  id/so  status/so  'creationTimestamp'^(su parse-iso8601)  ::zone/so
      'machineType'^(cu tail-url so)
::          'networkInterfaces'^parse-ip-gce
  ==
  =.  insts.vat
    %-  mo
    %+  weld  ins
    %+  skip  (~(tap by insts.vat))   :: keep non-gce
    |=  a=[@t instance]  ?=(%gce +<.a)
  =+  buf=`@da`(add ~s10 now)
  =+  liz=(~(tap by insts.vat))
  =+  tail=(turn liz |=(a=[@t instance] +.a))
  :_  +>.$ ::
  :-  [ost %wait /refresh-gce buf]
  (spam (instance-to-json tail))
::
++  thou-list-gce-global  ::  imgs
  |=  [pax=path resp=httr]
  ^-  [(list move) _+>.$]
  =+  parsed=(rash q:(need r.resp) apex:poja)
  =+  imgz=(need ((ot items/(ar some) ~):jo parsed))
  =.  images.vat
  %-  mo
  %+  weld  
  %+  skip  (~(tap by images.vat) *(list ,[[@t @t] image]))
  |=(a=[[@t @t] image] ?=(%gce ->.a))
  %+  turn  imgz
  |=  a=json
  =<  [[name %gce] .]
  ^-  image
  :-  %gce
  %-  need
  %.  a  =+  jo
  %-  ot
  [name/so id/so ~]
  :_  +>.$  [(spam `json`(image-to-json `(list image)`(map-to-list images.vat)))]
++  list-do
:+((list-something-do %droplets) (list-something-do %images) ~)
++  list-something-do
  |=  som=@tas
  =+  ^=  lis
      :~  /list-do/[som]
      ~[%digitalocean %api]  /v2/[som]
      %get
      (mo ['Content-Type' 'application/json' ~] ['Authorization' (cat 3 'Bearer ' access.do.toke.vat) ~] ~)
      ==
    (httpreq lis)
::
++  thou-list-do-droplets
  |=  [pax=path resp=httr]
  ^-  [(list move) _+>.$]
  =+  parsed=(rash q:(need r.resp) apex:poja)           ::  parse httr to json
  ~|  recieve-list/parsed
  =+  dar=(need ((ot droplets/(ar some) ~):jo parsed))  ::  reparse ar of insts
  =+  ^-  dropz=(list ,[@t instance])
      ~|  bad-json/-.dar
      %+  turn  dar
      |=  drp=json    ^-  [@t instance]
      =-  ~!  -  -
      =<  [id .]
      ^-  instance
      :-  %do
      %-  need
      %.  drp
      =+  jo
      %-  ot
      :~  name/so  id/parse-id-text  status/so  'created_at'^(su parse-iso8601)  ::region/parse-region
          image/(ot name/so ~)  ::disk/ni  
::          networks/parse-ip-do 
      ==
  =.  insts.vat
  %-  mo
  %+  weld  dropz
  %+  skip  (~(tap by insts.vat) *(list ,[@t instance]))
  |=(a=[@t instance] ?=(%do +>.$))
  =+  buf=`@da`(add ~s10 now)
  :_  +>.$
  :-  [ost %wait /refresh-do buf]
  %-  spam
  %-  instance-to-json  
  %+  turn  (~(tap by insts.vat) *(list ,[@t instance]))
  |=(a=[@t instance] +.a)
::
++  thou-list-do-images
  |=  [pax=path resp=httr] 
  =+  parsed=(rash q:(need r.resp) apex:poja)
  ~|  crashed-do-images/parsed
  =+  imgz=(need ((ot images/(ar (ot [name/so distribution/so id/no ~])) ~):jo parsed))
  =+  ^-  images=(list ,[[@t @t] image])
      %+  turn  imgz
      |=  [name=@t dist=@t id=@t]
      =+  nom=(cat 3 name dist)
      [[%do nom] `image`[%do nom id]]
  =.  images.vat
  %-  mo
  %+  weld  images
  %+  skip  (~(tap by images.vat) *(list ,[[@t @t] image]))
  |=(a=[[@t @t] image] ?=(%do ->.a))
  :_  +>.$  ~
  ::=.  
::
++  thou-do
  |=  [pax=path resp=httr]
  ~&  resp
  :_  +>.$  ~
++  thou-create
    |=  [pax=path resp=httr]
    ~&  resp
    :_  +>.$  ~
++  thou
  |=  [pour-path=path resp=httr]
  ^-  [(list move) _+>.$]
  ?+    -.pour-path  ~&  pour-path  !!
      %auth
    (receive-auth +.pour-path resp)
  ::
      $?
      %create-do  %create-gce
      ==
      :_  +>.$  ~
  ::
      ?(%create-gce-disk %disk-status)
      =+  snap=?~(t.pour-path !! i.t.pour-path)
    (disk-status snap resp)
  ::
      %check-status
    :_  +>.$  ~[(ask-disk-status +.pour-path)]
  ::
      %pub
    :_  +>.$  ~
  ::
  ==
++  publish
  |=  [act=(list speech)]
  ^-  move
  =+  ^=  spchz
      %+  turn  act
      |=  sp=speech
      =+  ^=  tail
      :-  ^-  audience
          :+  :-  `partner`[%& our ?+((clan our) !! %czar %court, %duke %porch)]
              ^-  (pair envelope delivery)
              [`envelope`[& ~] %pending]
            ~
          ~
      `statement`[now ~ sp]
      ^-  thought
      :-  `@`(sham eny tail)
      tail
  =+  mez=[%talk-command [%publish `(list thought)`spchz]]
  [ost %send /pub [our %talk] %poke mez]
--

