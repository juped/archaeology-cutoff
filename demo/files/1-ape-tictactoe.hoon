::                                                      ::  ::
::::  /hook/core/acto/ape                               ::  ::  dependencies
  ::                                                    ::  ::
/-  *sole                                               ::  structure
/+  sole                                                ::  library
::                                                      ::  ::
::::                                                    ::  ::  structures
  !:                                                    ::  ::
=>  |%                                                  ::  board logic
    ++  board  ,@                                       ::  one-player bitfield
    ++  point  ,[x=@ y=@]                               ::  coordinate
    ++  game   ,[who=? box=board boo=board]             ::  game state
    ++  icon   |=(? ?:(+< 'X' 'O'))                     ::  display at
    ++  bo                                              ::  per board
      |_  bud=board                                     ::
      ++  get  |=(point =(1 (cut 0 [(off +<) 1] bud)))  ::  get point
      ++  off  |=(point (add x (mul 3 y)))              ::  bitfield address
      ++  set  |=(point (con bud (bex (off +<))))       ::  set point
      ++  win  %-  lien  :_  |=(a=@ =(a (dis a bud)))   ::  test for win
               (rip 4 0wl04h0.4A0Aw.4A00s.0e070)        ::
      --                                                ::
    ::                                                  ::  ::
    ::::                                                ::  ::  semantics
      ::                                                ::  ::
    ++  go                                              ::  per game
      |_  game                                          ::
      ++  at  |_  point                                 ::  per point
              ++  g  +>+<                               ::  game
              ++  k  !|(x o)                            ::  ok move
              ++  m  ?.(k [| g] [& g:t:?:(who y p)])    ::  move
              ++  o  (~(get bo boo) +<)                 ::  old at o
              ++  p  .(boo (~(set bo boo) +<))          ::  play at o
              ++  t  .(who !who)                        ::  take turn
              ++  v  ?:(x (icon &) ?:(o (icon |) '.'))  ::  view
              ++  x  (~(get bo box) +<)                 ::  old at x
              ++  y  .(box (~(set bo box) +<))          ::  play at x
              --                                        ::
      ++  res  ?:  ~(win bo box)  `"{~[(icon &)]} wins" ::  result
               ?:  ~(win bo boo)  `"{~[(icon |)]} wins" ::
               ?:  =(511 (con boo box))  `"tie :-("  ~  ::
      ++  row  |=  y=@   :~  (add y '1')                ::  print row
                   ' '  ~(v at y 0)                     ::
                   ' '  ~(v at y 1)                     ::
                   ' '  ~(v at y 2)                     ::
               ==                                       ::
      ++  tab  ~["+ 1 2 3" (row 0) (row 1) (row 2)]     ::  print table
      --                                                ::
    --                                                  ::
::                                                      ::  ::
::::                                                    ::  ::  server
  ::                                                    ::  ::
=>  |%                                                  ::  arvo structures
    ++  axle  ,[%0 eye=face gam=game]                   ::  agent state
    ++  card  ,[%diff lime]                             ::  update
    ++  face  (pair (list ,@c) (map bone sole-share))   ::  interface
    ++  lime  ,[%sole-effect sole-effect]               ::  console update
    ++  move  (pair bone card)                          ::  cause and action
    --                                                  ::
=>  |%                                                  ::  parsers
    ++  colm  (cook |=(a=@ (sub a '1')) (shim '1' '3')) ::  row or column
    ++  come  ;~(plug colm ;~(pfix fas colm))           ::  coordinate
    --                                                  ::
|_  [hid=hide moz=(list move) axle]                     ::  per agent
++  et                                                  ::
  |_  [from say=sole-share]                             ::  per console
  ++  abet  +>(q.eye (~(put by q.eye) ost say))         ::  continue
  ++  amok  +>(q.eye (~(del by q.eye) ost))             ::  discontinue
  ++  beep  (emit %bel ~)                               ::  bad user
  ++  delt  |=  cal=sole-change                         ::  input line change
            =^  cul  say  (remit:sole cal good)         ::
            ?~  cul  (park:abet(p.eye buf.say) | ~)     ::
            abet:beep:(emit det/u.cul)                  ::
  ++  emit  |=  fec=sole-effect  ^+  +>                 ::  send effect
            +>(moz [[ost %diff %sole-effect fec] moz])  ::  
  ++  emil  |=  fex=(list sole-effect)                  ::  send effects
            ?~(fex +> $(fex t.fex, +> (emit i.fex)))    ::
  ++  good  |=((list ,@c) -:(rose (tufa +<) come))      ::  valid input
  ++  kick  |=  point                                   ::  move command
            =^  dud  gam  ~(m ~(at go gam) +<)          ::
            ?.  dud  abet:beep  =+  mus=~(res go gam)   ::
            (park:abet(gam ?^(mus *game gam)) %2 mus)   ::
  ++  line  =^  cal  say  (transmit:sole set/p.eye)     ::  update command
            (emit %det cal)                             ::
  ++  make  =+  dur=(rust (tufa p.eye) come)            ::
            ?~  dur  abet:beep                          ::
            (kick:line(p.eye ~) +.dur)                  ::
  ++  mean  |=((unit tape) ?~(+< +> (emit txt/+<+)))    ::  optional message
  ++  play  |=  lev=?(%0 %1 %2)                         ::  update by level
            ?-(lev %0 +>, %1 line, %2 line:show:prom)   ::
  ++  plow  |=  [lev=?(%0 %1 %2) mus=(unit tape)]       ::  complete print
            abet:(mean:(play lev) mus)                  ::
  ++  prom  %^  emit  %pro  %&  :-  %acto               ::  update prompt
            ": {~[(icon who.gam)]} to move (row/col): " ::  
  ++  rend  (turn `wall`~(tab go gam) |=(tape txt/+<))  ::  table print
  ++  show  (emit %mor rend)                            ::  update board
  ++  sole  ~(. cs say)                                 ::  console library
  ++  work  |=  act=sole-action                         ::  console input
            ?:(?=(%det -.act) (delt +.act) make)        ::
  --                                                    ::
++  abet  [(flop moz) .(moz ~)]                         ::  resolve core
++  flet  |=(from ~(. et +< (~(got by q.eye) ost)))     ::  in old client
++  fret  |=(from ~(. et +< *sole-share))               ::  in new client
++  pals  %+  turn  (pale hid (prix /sole))  |=  sink   ::  per console 
          [[p=p.+< q=q.+<] r=(~(got by q.eye) p.+<)]    ::
++  park  |=  [lev=?(%0 %1 %2) mus=(unit tape)]         ::  general update
          =+  pals  |-  ^+  +>.^$  ?~  +<  +>.^$        ::
          $(+< t.+<, +>.^$ (~(plow et i.+<) lev mus))   ::
::                                                      ::  ::
::::                                                    ::  ::  events
  ::                                                    ::  ::
++  peer-sole                                           ::  console subscribe
          |=  [from *]  =<  abet                        ::
          (plow:(fret +<-) %2 ~)                        ::
++  poke-sole-action                                    ::  console input
          |=  [from act=sole-action]  =<  abet          ::
          (work:(flet +<-) act)                         ::
++  prep  |=  [from old=(unit ,[(list move) axle])]     ::  initialize
          =<  abet  ?~  old  +>  =<  (park %2 ~)        ::
          +>(+<+ u.old)                                 ::
++  pull-sole                                           ::  disconnect console
          |=  [from *]  =<  abet                        ::
          amok:(flet +<-)                               ::
--
