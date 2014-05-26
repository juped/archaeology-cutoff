!:
::  clay (4c), revision control
::
|=  pit=vase
^-  vane
=>
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  ::              section 4cA, filesystem logic         ::
  ::
  |%
  ::
  ++  un                                                ::  per ship
    |=  [who=@p now=@da ruf=raft]
    =+  ^=  yar  ^-  room
        =+  yar=(~(get by fat.ruf) who)
        ?~(yar *room u.yar)
    =|  yel=(list ,[p=duct q=card])
    =|  byn=(list ,[p=duct q=riot])
    =|  vag=(list ,[p=duct q=card])
    =|  say=(list ,[p=duct q=path r=ship s=[p=@ud q=riff]])
    |%
    ++  abet
      ^-  [(list move) raft]
      :_  ruf(fat (~(put by fat.ruf) who yar))
      ;:  weld
        %+  turn  (flop yel)
        |=([a=duct b=card] [hun.yar %give b])
      ::
        %+  turn  (flop byn)
        |=([a=duct b=riot] [a %give [%writ b]])
      ::
        %+  turn  (flop vag)
        |=([a=duct b=card] [a %give b])
      ::
        %+  turn  (flop say)
        |=  [a=duct b=path c=ship d=[p=@ud q=riff]]
        :-  a
        [%call %a b %want [who c] [%q %re p.q.d (scot %ud p.d) ~] q.d]
      ==
    ::
    ++  doze
      =+  saz=(turn (~(tap by dos.yar) ~) |=([a=@tas b=*] a))
      =|  nex=(unit ,@da)
      |-  ^+   nex
      ?~  saz  nex
      $(saz t.saz, nex (hunt nex doze:(di i.saz)))
    ::
    ++  wake
      ^+  .
      =+  saz=(turn (~(tap by dos.yar) ~) |=([a=@tas b=*] a))
      |-  ^+  ..wake
      ?~  saz  ..wake
      $(saz t.saz, ..wake abet:wake:(di i.saz))
    ::
    ++  zest
      |=  his=@p
      :~  :-  %load
          =+  sim=(scot %p his)
          =+  sod=(~(tap by dos.yar) ~)
          |-  ^-  (list ,[p=@tas q=path q=rave])
          ?~  sod  ~
          =+  xiq=(~(tap by `cult`p.q.i.sod) ~)
          |-  ^-  (list ,[p=@tas q=path r=rave])
          ?~  xiq  ^$(sod t.sod)
          =+  nex=$(xiq t.xiq)
          ?.  ?&  ?=([[%c @ *] *] p.i.xiq)
                  =(sim i.t.i.p.i.xiq)
              ==  nex
          [[p.i.sod t.t.i.p.i.xiq q.i.xiq] nex]
      ::
          :-  %know
          =+  rob=(~(get by rid.yar) his)
          ?~  rob  ~
          =+  vob=(~(tap by u.rob) ~)
          |-
          ?~  vob  ~
          :-  p.i.vob
          :~  [%lim lim.q.i.vob]
              [%qyx qyx.q.i.vob]
              ?~  ref.q.i.vob
                ~
              :~  [%nix nix.u.ref.q.i.vob]
                  [%bom bom.u.ref.q.i.vob]
                  [%fod fod.u.ref.q.i.vob]
              ==
          ==
      ==
    ::
    ++  zeta
      |=  [his=@p syd=@tas lok=case tyl=path]
      ^-  (unit)
      ?.  ?=([%da @] lok)  ~
      ?.  ?=(~ tyl)  ~
      ?+  syd    ~
          %show  [~ `tank`>(zest his)<]
          %tell  [~ (zest his)]
      ==
    ::
    ++  de                                              ::  per desk
      |_  [for=@p syd=@ta rede]
      ++  abet
        ?:  =(for who)
          %_(..de dos.yar (~(put by dos.yar) syd qyx dom))
        %_    ..de
            rid.yar
          =+  ^=  rob   ^-  (map ,@tas rede)
              =+  rob=(~(get by rid.yar) for)
              ?~(rob ~ u.rob)
          (~(put by rid.yar) for (~(put by rob) syd `rede`+<+>.abet))
        ==
      ::
      ++  aver                                          ::  read
        |=  mun=mood
        ^-  (unit (unit ,*))
        =+  ezy=?~(ref ~ (~(get by haw.u.ref) mun))
        ?^  ezy  ezy
        =+  nao=(~(aeon ze lim dom) q.mun)
        ::  ~&  [%aver-mun nao [%from syd lim q.mun]]
        ?~(nao ~ [~ (~(avid ze lim dom) u.nao mun)])
      ::
      ++  balk                                          ::  read and send
        |=  [hen=duct oan=@ud mun=mood]
        ^+  +>
        =+  vid=(~(avid ze lim dom) oan mun)
        ?~  vid  (blob hen)  (blab hen mun u.vid)
      ::
      ++  blab                                          ::  ship result
        |=  [hen=duct mun=mood dat=*]
        ^+  +>
        +>(byn [[hen ~ [p.mun q.mun syd] r.mun dat] byn])
      ::
      ++  bleb                                          ::  ship sequence
        |=  [hen=duct ins=@ud hip=(list frog)]
        ^+  +>
        ?~  hip  +>
        %=  $
          hip  t.hip
          ins  +(ins)
          +>   (blab hen [%w [%ud ins] ~] i.hip)
        ==
      ::
      ++  blob                                          ::  ship stop
        |=  hen=duct
        %_(+> byn [[hen ~] byn])
      ::
      ++  doze                                          ::  sleep until
        =+  xiq=(~(tap by qyx) ~)
        =|  nex=(unit ,@da)
        |-  ^+  nex
        ?~  xiq  nex
        =+  ^=  zis  ^+  nex
            ?-    -.q.i.xiq
                &  ?.(?=(%da -.q.p.q.i.xiq) ~ [~ p.q.p.q.i.xiq])
            ::
                |
              =+  mot=`moat`p.q.i.xiq
              %+  hunt
                ?.  ?=(%da -.p.mot)  ~
                ?.((lth now p.p.mot) ~ [~ p.p.mot])
              ?.  ?=(%da -.q.mot)  ~
              ?.((lth now p.q.mot) [~ now] [~ p.q.mot])
            ==
        $(xiq t.xiq, nex (hunt nex zis))
      ::
      ++  duce                                          ::  produce request
        |=  [hen=duct rav=rave]
        ^+  +>
        =.  qyx  (~(put by qyx) hen rav)
        ?~  ref  +>
        |-  ^+  +>+.$
        =+  ^=  vaw  ^-  rave
          ?.  ?=([%& %v *] rav)  rav
          [%| [%ud let.dom] `case`q.p.rav]
        =+  inx=nix.u.ref
        %=  +>+.$
          say        [[hen [(scot %ud inx) ~] for [inx syd ~ vaw]] say]
          nix.u.ref  +(nix.u.ref)
          bom.u.ref  (~(put by bom.u.ref) inx [hen vaw])
          fod.u.ref  (~(put by fod.u.ref) hen inx)
        ==
      ::
      ++  ease                                          ::  release request
        |=  hen=duct
        ^+  +>
        =.  qyx  (~(del by qyx) hen)
        ?~  ref  +>
        |-  ^+  +>+.$
        =+  nux=(~(get by fod.u.ref) hen)
        ?~  nux  +>+.$
        %=  +>+.$
          say        [[hen [(scot %ud u.nux) ~] for [u.nux syd ~]] say]
          fod.u.ref  (~(del by fod.u.ref) hen)
          bom.u.ref  (~(del by bom.u.ref) u.nux)
        ==
      ::
      ++  eave                                          ::  subscribe
        |=  [hen=duct rav=rave]
        ^+  +>
        ?-    -.rav
            &
          =+  ver=(aver p.rav)
          ?~  ver
            (duce hen rav)
          ?~  u.ver
            (blob hen)
          (blab hen p.rav u.u.ver)
        ::
            |
          =+  nab=(~(aeon ze lim dom) p.p.rav)
          ?~  nab
            ?>  =(~ (~(aeon ze lim dom) q.p.rav))
            (duce hen rav)
          =+  huy=(~(aeon ze lim dom) q.p.rav)
          ?:  &(?=(^ huy) |((lth u.huy u.nab) &(=(0 u.huy) =(0 u.nab))))
            (blob hen)
          =+  top=?~(huy let.dom u.huy)
          =+  seb=(slag (sub let.dom top) hit.dom)
          =+  wid=(sub top u.nab)
          =+  fud=(flop (scag wid seb))
          =.  +>.$  (bleb hen u.nab fud)
          ?^  huy
            (blob hen)
          =+  ^=  ptr  ^-  case
              ?:  =(0 u.nab)  [%da _@da]
              =+(old=(slag wid seb) ?>(?=(^ old) `case`[%da p.i.old]))
          (duce hen `rave`[%| ptr q.p.rav])
        ==
      ::
      ++  echo                                          ::  announce changes
        |=  [hen=duct wen=@da lem=nori]
        ^+  +>
        %=    +>
            vag  ?~(hez.yar vag :_(vag [u.hez.yar [%ergo who syd let.dom]]))
            yel
          =+  pre=`path`~[(scot %p for) syd (scot %ud let.dom)]
          ?-  -.lem
            |  :_  yel
               [hen %note '=' %leaf :(weld (trip p.lem) " " (spud pre))]
            &  |-  ^+  yel
               ?~  q.q.lem  yel
               :_  $(q.q.lem t.q.q.lem)
               :-  hen
               :+  %note
                 ?-(-.q.i.q.q.lem %del '-', %ins '+', %mut ':')
               [%leaf (spud (weld pre p.i.q.q.lem))]
          ==
        ==
      ::
      ++  edit                                          ::  apply changes
        |=  [wen=@da lem=nori]
        ^+  +>
        +>(dom +<+:(~(axel ze lim dom) wen lem))
      ::
      ++  exec                                          ::  change and update
        |=  [hen=duct wen=@da lem=nori]
        ^+  +>
        (echo:wake:(edit wen lem) hen wen lem)
      ::
      ++  knit                                          ::  external change
        |=  [inx=@ud rot=riot]
        ^+  +>
        ?>  ?=(^ ref)
        |-  ^+  +>+.$
        =+  ruv=(~(get by bom.u.ref) inx)
        ?~  ruv  +>+.$
        =>  ?.  |(?=(~ rot) ?=(& -.q.u.ruv))  .
            %_  .
              bom.u.ref  (~(del by bom.u.ref) inx)
              fod.u.ref  (~(del by fod.u.ref) p.u.ruv)
            ==
        ?~  rot
          =+  rav=`rave`q.u.ruv
          %=    +>+.$
              lim
            ?.(&(?=(| -.rav) ?=(%da -.q.p.rav)) lim `@da`p.q.p.rav)
          ::
              haw.u.ref
            ?.  ?=(& -.rav)  haw.u.ref
            (~(put by haw.u.ref) p.rav ~)
          ==
        ?<  ?=(%v p.p.u.rot)
        =.  haw.u.ref
          (~(put by haw.u.ref) [p.p.u.rot q.p.u.rot q.u.rot] ~ r.u.rot)
        ?.  ?=(%w p.p.u.rot)  +>+.$
        |-  ^+  +>+.^$
        =+  nez=[%w [%ud let.dom] ~]
        =+  nex=(~(get by haw.u.ref) nez)
        ?~  nex  +>+.^$
        ?~  u.nex  +>+.^$  ::  should never happen
        %=  $
          haw.u.ref  (~(del by haw.u.ref) nez)
          +>+.^$     =+  roo=(edit ((hard frog) u.u.nex))
                     ?>(?=(^ ref.roo) roo)
        ==
      ::
      ++  wake                                          ::  update subscribers
        ^+  .
        =+  xiq=(~(tap by qyx) ~)
        =|  xaq=(list ,[p=duct q=rave])
        |-  ^+  ..wake
        ?~  xiq
          ..wake(qyx (~(gas by *cult) xaq))
        ?-    -.q.i.xiq
            &
          =+  cas=?~(ref ~ (~(get by haw.u.ref) `mood`p.q.i.xiq))
          ?^  cas
            %=    $
                xiq     t.xiq
                ..wake  ?~  u.cas  (blob p.i.xiq)
                        (blab p.i.xiq p.q.i.xiq u.u.cas)
            ==
          =+  nao=(~(aeon ze lim dom) q.p.q.i.xiq)
          ?~  nao  $(xiq t.xiq, xaq [i.xiq xaq])
          $(xiq t.xiq, ..wake (balk p.i.xiq u.nao p.q.i.xiq))
        ::
            |
          =+  mot=`moat`p.q.i.xiq
          =+  nab=(~(aeon ze lim dom) p.mot)
          ?~  nab
            $(xiq t.xiq, xaq [i.xiq xaq])
          =+  huy=(~(aeon ze lim dom) q.mot)
          ?~  huy
            ?:  =(let.dom u.nab)
              $(xiq t.xiq, xaq [i.xiq xaq])
            ?>  ?=(^ hit.dom)
            =+  ptr=[%da p.i.hit.dom]
            =+  fud=(flop (scag (sub let.dom u.nab) `(list frog)`hit.dom))
            %=  $
              xiq     t.xiq
              xaq     [[p.i.xiq [%| ptr q.mot]] xaq]
              ..wake  (bleb p.i.xiq let.dom fud)
            ==
          =+  yad=(slag (sub let.dom u.huy) `(list frog)`hit.dom)
          =+  fud=(flop (scag (sub u.huy u.nab) yad))
          %=  $
            xiq     t.xiq
            ..wake  (blob:(bleb p.i.xiq +(u.nab) fud) p.i.xiq)
          ==
        ==
      --
    ::
    ++  di
      |=  syd=@ta
      =+  ^=  saq  ^-  dojo
          =+  saq=(~(get by dos.yar) syd)
          ?~(saq *dojo u.saq)
      ~(. de who syd now p.saq ~ q.saq)
    ::
    ++  do
      |=  [him=ship syd=@tas]
      =+  ^=  red  ^-  rede
          =+  roy=(~(get by rid.yar) him)
          =+  yit=?~(roy ~ (~(get by u.roy) syd))
          ?^(yit u.yit `rede`[~2000.1.1 ~ [~ *rind] *dome])
      ::  ~&  [%do-qyx him syd qyx.red]
      ~(. de him syd red)
    --
  --
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  ::              section 4cA, filesystem vane          ::
  ::                                                    ::
  =|                                                    ::  instrument state
      $:  ruf=raft                                      ::  revision tree
      ==                                                ::
  |=  [now=@da eny=@ ska=$+(* (unit (unit)))]           ::  activate
  ^?                                                    ::  opaque core
  |%                                                    ::
  ++  beat                                              ::  update
    |=  [tea=wire hen=duct typ=type fav=card]
    ^-  [p=(list move) q=vane]
    ?+    -.fav  [[[hen %give fav] ~] ..^$]
        %crud
      [[[hen %slip %d %flog fav] ~] ..^$]
    ::
        %init
      [~ ..^$(fat.ruf (~(put by fat.ruf) p.fav [hen ~ ~ ~]))]
    ::
        ?(%info %into)
      ?:  =(%$ q.fav)
        ?.  ?=(%into -.fav)  [~ ..^$]
        =+  yar=(need (~(get by fat.ruf) p.fav))
        [~ ..^$(fat.ruf (~(put by fat.ruf) p.fav yar(hez [~ hen])))]
      =^  mos  ruf
        =+  ^=  zot
          abet:(exec:(di:wake:(un p.fav now ruf) q.fav) hen now r.fav)
        abet:zot(hez.yar ?.(=(%into -.fav) hez.yar.zot [~ hen]))
      [mos ..^$]
    ::
        %waft
      ?>  ?=([@ @ ~] tea)
      =+  syd=(need (slaw %tas i.tea))
      =+  inx=(need (slaw %ud i.t.tea))
      =^  mos  ruf
        =<  abet
        =<  abet
        =<  wake
        %.  [inx ((hard riot) q.fav)]
        knit:(do:(un p.p.fav now ruf) q.p.fav syd)
      [mos ..^$]
    ::
        %warp
      =^  mos  ruf
        =<  abet
        =+  une=(un p.p.fav now ruf)
        =+  wex=?.(=(p.p.fav q.p.fav) (do:une q.p.fav p.q.fav) (di:une p.q.fav))
        ?~  q.q.fav
          abet:(ease:wex hen)
        abet:(eave:wex hen u.q.q.fav)
      [mos ..^$]
    ::
        %wart
      ?>  ?=(%re q.fav)
      =+  ryf=((hard riff) s.fav)
      :_  ..^$
      :~  :-  hen
          :^  %call  %c
            [(scot %p p.p.fav) (scot %p q.p.fav) r.fav]
          [%warp [p.p.fav p.p.fav] ryf]
      ==
    ::
        %writ
      ?>  ?=([@ @ *] tea)
      =+  our=(need (slaw %p i.tea))
      =+  him=(need (slaw %p i.t.tea))
      :_  ..^$
      :~  :-  hen
          [%call %a ~ [%want [our him] [%r %re %c t.t.tea] p.fav]]
      ==
    ::
        %went                             ::  XX should actually propagate
      ?:  =(%good q.fav)  [~ ..^$]
      ~&  [%clay-lost p.fav tea]
      [~ ..^$]
    ::
        %wake
      =+  dal=(turn (~(tap by fat.ruf) ~) |=([a=@p b=room] a))
      =|  mos=(list move)
      |-  ^-  [p=(list move) q=vane]
      ?~  dal  [mos ..^^$(las.ruf now)]
      =^  som  ruf  abet:wake:(un i.dal now ruf)
      $(dal t.dal, mos (weld som mos))
    ==
  ::
  ++  call                                                ::  process move
    |=  [hen=duct typ=type fav=card]
    (beat ~ hen typ fav)
  ::
  ++  come
    |=  [sam=? old=vase]
    ^-  vane
    (load old)
  ::
  ++  doze
    |=  [now=@da hen=duct]
    =|  nex=(unit ,@da)
    =+  dal=(turn (~(tap by fat.ruf) ~) |=([a=@p b=room] a))
    |-  ^+  nex
    ?~  dal  nex
    $(dal t.dal, nex (hunt nex doze:(un i.dal now ruf)))
  ::
  ++  load
    |=  old=vase
    ^-  vane
    ?.  (~(nest ut -:!>(ruf)) & p.old)
      ~&  %clay-reset
      ..^$
    ..^$(ruf (raft q.old))
  ::
  ++  raze
    ^-  vane
    ..$(ruf *raft)
  ::
  ++  scry                                              ::  inspect
    |=  [our=ship ren=@tas his=ship syd=desk lot=coin tyl=path]
    ^-  (unit (unit))
    =+  ^=  whu  ^-  (unit ,@p)                          ::  XX HEINOUS!
        ?:  (~(has by fat.ruf) his)
          `his
        =+  foo=`(list ,[p=ship q=room])`(~(tap by fat.ruf) ~)
        |-  ^-  (unit ,@p)
        ?~  foo  ~
        ?:  (~(has by rid.q.i.foo) his)  `p.i.foo
        $(foo t.foo)
    ?~  whu  ~
    =.  our  u.whu
    ::  ~?  !=(`our whu)  [%clay-scry whu our ren his syd lot tyl]
    =+  luk=?.(?=(%$ -.lot) ~ ((soft case) p.lot))
    ?~  luk  [~ ~]
    =+  une=(un our now ruf)
    ?:  =(%$ ren)
      [~ (zeta:une his syd u.luk tyl)]
    =+  run=((soft care) ren)
    ?~  run  [~ ~]
    %.  [u.run u.luk tyl]
    =+  dud=?.(=(our his) (do:une his syd) (di:une syd))
    ::  ~&  [%scry-at [our his] now lim.dud]
    aver:dud
  ::
  ++  stay  `vase`!>(ruf)
  ++  vern  [164 0]
  --
