!:
::  /=main=/bin/chat/hoon
::
=>  %=    .
        +
      =>  +
      =>  ^/===/lib/pony
      =+  ^=  flag
          $?  %leet
              %monitor
              %noob
              %quiet
              [%tower p=@p]
              [%s p=path]
          ==
      =+  flags=*(list flag)
      =>  |%
          ++  chat                                      ::  user action
            $%  [%all p=mess]                           ::  say
                [%back p=?(%da %dr %ud) q=@]            ::  backlog
                [%how ~]                                ::  help
                [%priv p=@p q=mess]                     ::  private
                [%who ~]                                ::  who
            ==                                          ::
          ++  idad  ,[p=@p q=@t]                        ::  identity
          ++  mess                                      ::  message
            $%  [%do p=@t]                              ::  act
                [%exp p=@t q=tank]                      ::  code
                [%say p=@t]                             ::  say
            ==                                          ::
          ++  user                                      ::  amigos
            $%  [%in p=idad]                            ::  coming on the air
                [%out p=idad]                           ::  signing off
            ==                                          ::
          ++  station  path                             ::
          ++  zing                                      ::  client to server
            $%  [%backlog p=path q=?(%da %dr %ud) r=@]  ::
                [%hola p=station]                       ::
                [%mess p=station q=mess]                ::
            ==                                          ::
          ++  zong                                      ::  server to client
            $%  [%mess p=@da q=ship r=mess]             ::
            ==                                          ::
          --
      =>  |%
          ++  chat
            %+  cook  |=(a=^chat a)
            ;~  pose
              (cold [%how ~] wut)
              (cold [%who ~] tis)
              (stag %back dat)
              (stag %priv ;~(plug ;~(pfix sig fed:ag) ;~(pfix ace mess)))
              (stag %all mess)
            ==
          ::
          ++  dat
            %+  cook
              |=  p=coin
              ?.  ?=(~ -.p)  [%ud 5]
              ?+  p.p.p  [%ud 5]
                %da  [%da q.p.p]
                %dr  [%dr q.p.p]
                %ud  [%ud q.p.p]
              ==
            ;~(pfix (jest '\\\\ ') nuck:so)
          ::
          ++  expn
            %-  sear
            :_  text
            |=  a=@t
            ^-  (unit ,[p=@t q=tank])
            =+  hun=(rush a wide:vast)
            ?~  hun  ~
            ?~(a ~ [~ a (sell (slap seed u.hun))])
          ::
          ++  mess
            %+  cook  |=(a=^mess a)
            ;~  pose
              (stag %do ;~(pfix pat text))
              (stag %exp ;~(pfix hax expn))
              (stag %do (full (easy '')))
              (stag %say text)
            ==
          ::
          ++  text  (boss 256 (star prn))
          --
      |%
      ++  idt
        |=  from=idad
          ?:  |(!(lien flags |=(a=flag ?=(%noob a))) =("" q.from))
            (scow %p p.from)
          %-  trip
          %^  cat  3  %^  cat  3  (scot %p p.from)  ' '  q.from
      ++  rend
        |=  [from=idad msg=^mess pre=tape] ::  roo=^room
        ^-  tank
        ?-  -.msg
          %do   =+  mes=?:(=(0 p.msg) "remains quietly present" (trip p.msg))
                :-  %leaf
                "{pre}{(idt from)} {mes}"
          %exp  :~  %rose
                    [" " "" ""]
                    :-  %leaf
                    "{pre}{(idt from)} {(trip p.msg)}"
                    q.msg
                ==
          %say  [%leaf "{pre}{(idt from)}: {(trip p.msg)}"]
        ==
      --
      ::
    ==
=>  %=    .
        -
      :-  :*  ami=*(map ,@p ,@t)                        ::
              bud=(sein `@p`-<)                         ::  chat server
              dun=|                                     ::  done
              mon=*?                                    ::  leet mode
              nub=*?                                    ::  monitor mode
              giz=*(list gift)                          ::  stuff to send
              sta=*station                              ::  station
              sub=*(list path)                          ::  subscriptions
              tod=*(map ,@p ,@ud)                       ::  outstanding, friend
              wak=_@da                                  ::  next heartbeat
          ==
      [who=`@p`-< how=`path`->]
    ==
|=  [est=time *]
|=  args=(list flag)
=.  flags  args
=.  wak  est
=.  bud
  ?:  (lien args |=(a=flag &(?=(^ a) ?=(%tower -.a))))
    (roll args |=([p=flag q=@p] ?:(&(?=(^ p) ?=(%tower -.p)) p.p q)))
  bud
=.  nub  (lien args |=(a=flag ?=(%noob a)))
=.  mon  (lien args |=(a=flag ?=(%monitor a)))
=.  sta
  ?:  (lien args |=(a=flag &(?=(^ a) ?=(%s -.a))))
    (roll args |=([p=flag q=station] ?:(&(?=(^ p) ?=(%s -.p)) p.p q)))
  sta
|-  ^-  bowl
=<  abet:init
|%
++  abet  `bowl`[(flop giz) ?:(dun ~ [~ hope vent(giz ~)])]
++  hope
  :^    [/up %up %text ["& " ""]]
      [/wa %wa wak]
    [/ya %lq %ya]
  %+  welp
    (turn sub |=(pax=path [[%gr pax] [%gr ~]]))
  %+  turn  (~(tap by tod))
  |=  [p=@p q=@ud]
  [[%ra (scot %p p) ~] [%ow ~]]
::
++  iden
  |=  her=@p
  (fall (~(get by ami) her) *@t)
::
++  init  (joke:(subs:(subs (welp sta /amigos)) (welp sta /mensajes)) %hola sta)
::
++  jake
  |=  [her=@p msg=^mess]
  ^+  +>
  %=  +>.$
    giz  :_(giz [%sq her %ya [%ra (scot %p her) ~] msg])
    tod  (~(put by tod) her +((fall (~(get by tod) her) 0)))
  ==
::
++  joke                                                ::  send message
  |=  msg=zing
  ^+  +>
  +>(giz :_(giz [%xz [bud %radio] who %zing msg]))
::
++  join
  |=  you=user
  ^+  +>
  ?-  -.you
      %in
    =.  ami  (~(put by ami) p.you)
    ?.  mon  +>.$
    (show %leaf "{(idt p.you)} comes on the air")
      %out
    =.  ami  (~(del by ami) p.p.you)
    ?.  mon  +>.$
    (show %leaf "{(idt p.you)} signs off")
  ==
++  joyn
  |=  yall=(list idad)
  ^+  +>
  =.  ami  (~(gas by ami) yall)
  ?.  mon  +>.$
  (shew (turn yall |=(you=idad [%leaf "{(idt you)} is on the air"])))
::
++  nice                                                ::  got response
  |=  [her=@p kay=cape]
  ^+  +>
  =.  +>
    =+  dyt=(need (~(get by tod) her))
    %_    +>.$
        tod
      ?:  =(1 dyt)
        (~(del by tod) her)
      (~(put by tod) her (dec dyt))
    ==
  ?-  kay
    %good  +>
    %dead  (show %leaf "server {(scow %p her)} choked")
  ==
::
++  priv
  |=  [now=@da her=@p mes=^mess]
  ^+  +>
  (show (rend [her (iden her)] mes "(private) "))
::
++  said                                                ::  server message
  |=  duz=(list zong)
  ^+  +>
  ?~  duz  +>
  %=    $
      duz  t.duz
      +>
    %-  show
    ^-  tank
    ?-    -.i.duz
      %mess  (rend [q.i.duz (iden q.i.duz)] r.i.duz "")
==  ==
::
++  shew  |=(tax=(list tank) +>(giz [[%lo tax] giz]))   ::  print to screen
++  show  |=(tan=tank +>(giz [[%la tan] giz]))          ::  print to screen
::
++  subs
  |=  pax=path
  ^+  +>
  +>(sub [pax sub], giz :_(giz [%zz /g [%gr pax] %show [bud %radio] who pax]))
::
++  take  (joke(wak (add ~m1 (max wak est))) %hola sta) ::  beat heart
++  toke                                                ::  user action
  |=  [now=@da txt=@t]
  ^+  +>
  ?:  =(0 txt)  +>
  =+  rey=(rush txt chat)
  ?~  rey
    (show %leaf "invalid input")
  ?-  -.u.rey
    %all   (joke %mess sta p.u.rey)
    %back  (joke %backlog sta p.u.rey q.u.rey)
    %how   (shew (turn (lore ^:@/===doc%/help/txt) |=(a=@t [%leaf (trip a)])))
    %priv  (jake p.u.rey q.u.rey)
    %who
      %^  show  %rose  [", " "" ""]
      %+  turn  (~(tap by ami))
      |=  p=idad  [%leaf (idt p)]
  ==
::
++  vent                                                ::  handle event
  |=  [now=@da pax=path nut=note]
  ^-  bowl
  =.  est  now
  =<  abet
  ?+  -.pax  ~&  [%chat-vent-unknown -.nut]  +>.$
    %gr  ?>  ?=(%gr -.nut)
         ?+  p.nut  ~&  %chat-vent-logo-fail  +>.$
           %user   (join ((hard user) q.nut))
           %users  (joyn ((hard (list idad)) q.nut))
           %zong   (said [((hard zong) q.nut) ~])
           %zongs  (said ((hard (list zong)) q.nut))
         ==
    %up  ?>(?=(%up -.nut) (toke now p.nut))
    %ra  ?>  &(?=(%ow -.nut) ?=(^ t.pax))
         (nice (need (slaw %p i.t.pax)) p.nut)
    %wa  ?>(?=(%wa -.nut) take)
    %ya  ?>  ?=(%lq -.nut)
         =+  n=((soft ^mess) r.nut)
         ?~  n
           ~&  %chat-mess-fail  +>+
         (priv now p.nut u.n)
  ==
--
