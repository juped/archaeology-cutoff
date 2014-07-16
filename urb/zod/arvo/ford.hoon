::::::
::  ::  %ford, new execution control
!?  164
::::
|=  pit=vase
=>  =~
::  structures
|%
++  bead  ,[p=(set beam) q=cage]                        ::  computed result
++  gift                                                ::  out result <-$
          $%  [%made p=(each bead (list tank))]         ::  computed result
          ==                                            ::
++  hood                                                ::  assembly plan
          $:  sys=$|(@ud [@ud @ud])                     ::  system kelvin
              pro=(map term beam)                       ::  protocols
              lib=(map term beam)                       ::  libraries
              ::  res=(map term (trel horn beam path))  ::  resource trees
              src=(list hoop)                           ::  program
          ==                                            ::
++  hoop                                                ::  source in hood
          $%  [%code p=twig]                            ::  direct twig
              [%cone p=beam]                            ::  core from folder
              [%coop p=(map term hoop)]                 ::  complex core
              [%hood p=beam]                            ::  recursive hood
              [%text p=@]                               ::  direct text
          ==                                            ::
++  horn                                                ::  resource tree
          $|  ~                                         ::  leaf
          $%  [%day p=horn]                             ::  list by time
              [%fan p=(map term horn)]                  ::  tuple
              [%for p=logo q=horn]                      ::  leaf protocol
              [%hub p=horn]                             ::  list by number
              [%nap p=horn]                             ::  soft map
          ==                                            ::
++  kiss                                                ::  in request ->$
          $%  [%exec p=@p q=(unit silk)]                ::  make / kill
          ==                                            ::
++  move  ,[p=duct q=(mold note gift)]                  ::  local move
++  note                                                ::  out request $->
          $%  $:  %c                                    ::  to %clay
          $%  [%warp p=sock q=riff]                     ::
          ==  ==  ==                                    ::
++  rave                                                ::  see %clay
          $%  [& p=mood]                                ::  single request
              [| p=moat]                                ::  change range
          ==                                            ::
++  riff  ,[p=desk q=(unit rave)]                       ::  see %clay
++  sign                                                ::  in result $<-
          $%  $:  %c                                    ::  by %clay
          $%  [%writ p=riot]                            ::
          ==  ==  ==                                    ::
++  silk                                                ::  construction layer
          $&  [p=silk q=silk]                           ::  cons
          $%  [%bake p=logo q=beam r=path]              ::  local synthesis
              [%boil p=logo q=beam r=path]              ::  general synthesis
              [%brew p=logo q=beam r=path]              ::  specific synthesis
              [%call p=silk q=silk]                     ::  slam
              [%cast p=logo q=beak r=silk]              ::  translate
              [%done p=(set beam) q=cage]               ::  literal
              [%dude p=tank q=silk]                     ::  error wrap
              [%dune p=(set beam) q=(unit cage)]        ::  unit literal
              [%mute p=silk q=(list (pair wing silk))]  ::  mutant
              [%plan p=silk q=hood]                     ::  structured build
              [%reef ~]                                 ::  kernel reef
              [%ride p=silk q=sill]                     ::  obsolete old plan
              [%vale p=logo q=sack r=*]                 ::  validate [our his]
          ==                                            ::
++  sill                                                ::  code construction
          $&  [p=sill q=sill]                           ::  compose
          $%  [%dire p=@]                               ::  direct text
              [%dirt p=twig]                            ::  direct twig
              [%dish p=toga q=sill]                     ::  tislus
              [%disk p=(list sill)]                     ::  pipe
              [%drag p=beam q=path]                     ::  beam to %hoon
              [%drug p=silk]                            ::  indirect twig
              [%dust p=silk]                            ::  literal value
          ==                                            ::
--                                                      ::
|%                                                      ::  structures
++  axle                                                ::  all %ford state
  $:  %1                                                ::  version for update
      pol=(map ship baby)                               ::
  ==                                                    ::
++  baby                                                ::  state by ship
  $:  tad=[p=@ud q=(map ,@ud task)]                     ::  tasks by number
      dym=(map duct ,@ud)                               ::  duct to task number
      jav=(map ,* calx)                                 ::  cache
  ==                                                    ::
++  bolt                                                ::  gonadic edge
  |*  a=$+(* *)                                         ::  product clam
  $:  p=cafe                                            ::  cache
    $=  q                                               ::
      $%  [%0 p=(set beam) q=a]                         ::  depends/product
          [%1 p=(set ,[p=beam q=(list tank)])]          ::  blocks
          [%2 p=(list tank)]                            ::  error
      ==                                                ::
  ==                                                    ::
::                                                      ::
++  burg                                                ::  gonadic rule
  |*  [a=$+(* *) b=$+(* *)]                             ::  from and to
  $+([c=cafe d=a] (bolt b))                             ::
::                                                      ::
++  cafe                                                ::  live cache
  $:  p=(set calx)                                      ::  used
      q=(map ,* calx)                                   ::  cache
  ==                                                    ::
::                                                      ::
++  calm                                                ::  cache metadata
  $:  laz=@da                                           ::  last accessed
      dep=(set beam)                                    ::  dependencies
  ==                                                    ::
++  calx                                                ::  concrete cache line
  $%  [%hood p=calm q=(pair path cage) r=hood]          ::  compile to hood
      [%slap p=calm q=[p=vase q=twig] r=vase]           ::  slap
      [%twig p=calm q=(pair path cage) r=twig]          ::  compile to twig
  ==                                                    ::
++  task                                                ::  problem in progress
  $:  nah=duct                                          ::  cause
      kas=silk                                          ::  problem
      kig=[p=@ud q=(map ,@ud beam)]                     ::  blocks
  ==                                                    ::
--                                                      ::
|%                                                      ::
++  calf                                                ::  reduce calx
  |*  sem=*                                             ::  a typesystem hack
  |=  cax=calx
  ?+  sem  !!
    %twig  ?>(?=(%twig -.cax) r.cax)
    %slap  ?>(?=(%slap -.cax) r.cax)
  ==
::
++  calk                                                ::  cache lookup
  |=  a=cafe                                            ::
  |=  [b=@tas c=*]                                      ::
  ^-  [(unit calx) cafe]                                ::
  =+  d=(~(get by q.a) [b c])                           ::
  ?~  d  [~ a]                                          ::
  [d a(p (~(put in p.a) u.d))]                          ::
::                                                      ::
++  came                                                ::
  |=  [a=cafe b=calx]                                   ::  cache install
  ^-  cafe                                              ::
  a(q (~(put by q.a) [-.b q.b] b))                      ::
::                                                      ::
++  chub                                                ::  cache merge
  |=  [a=cafe b=cafe]                                   ::
  ^-  cafe                                              ::
  [(grom p.a p.b) (grum q.a q.b)]                       ::
::                                                      ::
++  colt                                                ::  reduce to save
  |=  lex=axle                                          ::
  ^-  axle
  %=    lex
      pol
    %-  ~(run by pol.lex)
    |=  bay=baby
    bay(jav ~)
  ==
::
++  fine  |*  [a=cafe b=*]                              ::  bolt from data
          [p=`cafe`a q=[%0 p=*(set beam) q=b]]          ::
++  flaw  |=([a=cafe b=(list tank)] [p=a q=[%2 p=b]])   ::  bolt from error
::
++  grom                                                ::  merge sets
  |*  [one=(set) two=(set)]
  ^+  one
  (~(gas in one) (~(tap in two) ~))                     ::  XX ugh
::
++  grum                                                ::  merge maps
  |*  [one=(map) two=(map)]
  ^+  one
  (~(gas by one) (~(tap by two) ~))                     ::  XX ugh
::
++  za                                                  ::  per event
  =|  $:  $:  $:  our=ship                              ::  computation owner
                  tea=wire                              ::  event place
                  hen=duct                              ::  event floor
              ==                                        ::
              $:  now=@da                               ::  event date
                  eny=@                                 ::  unique entropy
                  ska=$+(* (unit (unit)))               ::  system namespace
              ==                                        ::
              mow=(list move)                           ::  pending actions
          ==                                            ::
          bay=baby                                      ::  all owned state
      ==                                                ::
  |%
  ++  abet                                              ::  resolve
    ^-  [(list move) baby]
    [(flop mow) bay]
  ::
  ++  apex                                              ::  call
    |=  kus=(unit silk)
    ^+  +>
    ?~  kus
      =+  num=(need (~(get by dym.bay) hen))
      =+  tas=(need (~(get by q.tad.bay) num))
      amok:~(camo zo [num tas])
    =+  num=p.tad.bay
    ?>  !(~(has by dym.bay) hen)
    =:  p.tad.bay  +(p.tad.bay)
        dym.bay    (~(put by dym.bay) hen num)
      ==
    ~(exec zo [num `task`[hen u.kus 0 ~]])
  ::
  ++  axon                                              ::  take
    |=  [num=@ud tik=@ud sih=sign]
    ^+  +>
    ?-    -.+.sih
        %writ
      =+  tus=(~(get by q.tad.bay) num)
      ?~  tus
        ~&  [%ford-lost num]
        +>.$
      (~(resp zo [num u.tus]) tik p.+.sih)
    ==
  ::
  ++  zo
    |_  [num=@ud task]
    ++  abet  %_(..zo q.tad.bay (~(put by q.tad.bay) num +<+))
    ++  amok  
      %_  ..zo  
        q.tad.bay  (~(del by q.tad.bay) num)
        dym.bay    (~(del by dym.bay) nah)
      ==
    ++  camo                                            ::  stop requests
      ^+  .
      =+  kiz=(~(tap by q.kig) *(list ,[p=@ud q=beam]))
      |-  ^+  +>
      ?~  kiz  +>
      %=    $
          kiz  t.kiz
          mow  :_  mow
        :-  hen
        :^  %pass  [(scot %p our) (scot %ud num) (scot %ud p.i.kiz) ~]
          %c
        [%warp [our p.q.i.kiz] q.q.i.kiz ~]
      ==
    ::
    ++  camp                                            ::  request a file
      |=  [ren=care bem=beam]
      ^+  +>
      %=    +>
          kig  [+(p.kig) (~(put by q.kig) p.kig bem)]
          mow  :_  mow
        :-  hen
        :^  %pass  [(scot %p our) (scot %ud num) (scot %ud p.kig) ~]
          %c
        [%warp [our p.bem] q.bem [~ %& %x r.bem s.bem]]
      ==
    ::
    ++  clef                                            ::  cache a result
      |*  sem=*
      |*  [hoc=(bolt) fun=(burg)]
      ?-    -.q.hoc
          %2  hoc
          %1  hoc
          %0
        =^  cux  p.hoc  ((calk p.hoc) sem q.q.hoc)
        ?~  cux
          =+  nuf=(cope hoc fun)
          ?-    -.q.nuf
              %2  nuf
              %1  nuf
              %0
            :-  p=(came p.nuf `calx`[sem `calm`[now p.q.nuf] q.q.hoc q.q.nuf])
            q=q.nuf
          ==
        :-  p=p.hoc
        ^=  q
        :+  %0  p.q.hoc
        ((calf sem) u.cux)
      ==
    ::
    ++  coax                                            ::  bolt across
      |*  [hoc=(bolt) fun=(burg)]
      ?-  -.q.hoc
        %0  =+  nuf=$:fun(..+<- p.hoc)
            :-  p=p.nuf
            ^=  q
            ?-  -.q.nuf
              %0  [%0 p=(grom p.q.hoc p.q.nuf) q=[q.q.hoc q.q.nuf]]
              %1  q.nuf
              %2  q.nuf
            ==
        %1  =+  nuf=$:fun(..+<- p.hoc)
            :-  p=p.nuf
            ^=  q
            ?-  -.q.nuf
              %0  q.hoc
              %1  [%1 p=(grom p.q.nuf p.q.hoc)]
              %2  q.nuf
            ==
        %2  hoc
      ==
    ::
    ++  cool                                            ::  error caption
      |*  [cyt=trap hoc=(bolt)]
      ?.  ?=(%2 -.q.hoc)  hoc
      [p.hoc [%2 *cyt p.q.hoc]]
    ::
    ++  cope                                            ::  bolt along
      |*  [hoc=(bolt) fun=(burg)]
      ?-  -.q.hoc
        %2  hoc
        %1  hoc
        %0  =+  nuf=(fun p.hoc q.q.hoc)
            :-  p=p.nuf
            ^=  q
            ?-  -.q.nuf
              %2  q.nuf
              %1  q.nuf
              %0  [%0 p=(grom `_p.q.nuf`p.q.hoc p.q.nuf) q=q.q.nuf]
      ==   ==
    ::
    ++  coup                                            ::  toon to bolt
      |=  cof=cafe
      |*  [ton=toon fun=$+(* *)]
      :-  p=cof
      ^=  q
      ?-  -.ton
        %2  [%2 p=p.ton]
        %0  [%0 p=*(set beam) q=(fun p.ton)]
        %1  =-  ?-  faw
                  &  [%1 p=(turn p.faw |=(a=beam [a *(list tank)]))]
                  |  [%2 p=p.faw]
                ==
            ^=  faw
            |-  ^-  (each (list beam) (list tank))
            ?~  p.ton  [%& ~]
            =+  nex=$(p.ton t.p.ton)
            =+  pax=(path i.p.ton)
            =+  zis=(tome (path i.p.ton))
            ?~  zis
              [%| (smyt pax) ?:(?=(& -.nex) ~ p.nex)]
            ?-  -.nex
              &  [%& u.zis p.nex]
              |  nex
            ==
      ==
    ::
    ++  dash                                            ::  process cache
      |=  cof=cafe
      ^+  +>
      %_(+> jav.bay q.cof)
    ::
    ++  exec                                            ::  execute app
      ^+  ..zo
      ?:  !=(~ q.kig)  ..zo
      |-  ^+  ..zo
      =+  bot=(make [~ jav.bay] kas)
      =.  ..exec  (dash p.bot)
      ?-  -.q.bot
        %0  amok:(expo [%made %& p.q.bot q.q.bot])
        %2  amok:(expo [%made %| p.q.bot])
        %1  =+  zuk=(~(tap by p.q.bot) ~)
            =<  abet
            |-  ^+  ..exec
            ?~  zuk  ..exec
            =+  foo=`_..exec`(camp %x `beam`p.i.zuk)
            $(zuk t.zuk, ..exec foo)
      ==
    ::
    ++  expo                                            ::  return gift
      |=  gef=gift
      %_(+> mow :_(mow [hen %give gef]))
    ::
    ++  fade                                            ::  compile %hood
      |=  [cof=cafe kas=silk]
      ^-  (bolt hood)
      %.  [cof %hoon kas]
      (fado |=(a=path (ifix [gay gay] hall:(vang | a))))
    ::
    ++  fane                                            ::  compile %hoon
      |=  [cof=cafe kas=silk]
      ^-  (bolt twig)
      %.  [cof %hoon kas]
      (fado |=(a=path (ifix [gay gay] tall:(vang | a))))
    ::
    ++  fado                                            ::  compile by rule
      |*  lur=$+(path rule) 
      |=  [cof=cafe for=logo kas=silk]
      %+  (clef %twig)  (maid cof kas)
      ^-  (burg (pair path cage) twig)
      |=  [cof=cafe pay=(pair path cage)]
      ?.  |(=(for p.q.pay) =(%noun p.q.pay))
        (flaw cof [%leaf "source error: {<p.pay>} must be %{<(trip for)>}"])
      ?.  ?=(@ q.q.q.pay)
        (flaw cof [%leaf "source error: {<p.pay>} must be flat"]~)
      =+  vex=((full (lur p.pay)) [[1 1] (trip q.q.q.pay)])
      ?~  q.vex
        (flaw cof [%leaf "syntax error: {<p.p.vex>} {<q.p.vex>}"] ~)
      (fine cof p.u.q.vex)
    ::
    ++  gush                                            ::  sill to twig
      |=  [cof=cafe sil=sill]
      ^-  (bolt twig)
      ?+  -.sil  !!
        %dire  (fane cof [%done ~ [%atom [%atom %$] p.sil]])
        %dirt  (fine cof p.sil)
        %drag  (fane cof [%boil %hoon p.sil q.sil])
        %drug  %+  cope  (make cof p.sil)
               |=  [cof=cafe cay=cage]
               (fine cof (twig q.q.cay))
      ==
    ::
    ++  home                                            ::  source silk to path
      |=  kas=silk
      ^-  path
      ?+  -.kas  ~[(end 3 1 (scot %p (mug kas)))]
        %bake  (tope q.kas(s (welp r.kas s.q.kas)))
        %boil  (tope q.kas(s (welp r.kas s.q.kas)))
        %cast  $(kas r.kas)
        %dude  $(kas q.kas)
        %ride  ?+  -.q.kas  $(kas [%reef ~])
                 %drag  (tope p.q.kas)
                 %drug  $(kas p.q.kas)
               ==
      ==
    ++  kale                                            ::  mutate
      |=  [cof=cafe kas=silk muy=(list (pair wing silk))]
      ^-  (bolt cage)
      %+  cope
        |-  ^-  (bolt (list (pair wing vase)))
        ?~  muy  (fine cof ~)
        %+  cope  (make cof q.i.muy)
        |=  [cof=cafe cay=cage]
        %+  cope  ^$(muy t.muy)
        |=  [cof=cafe rex=(list (pair wing vase))]
        (fine cof [[p.i.muy q.cay] rex])
      |=  [cof=cafe yom=(list (pair wing vase))]
      %+  cope  (make cof kas)
      |=  [cof=cafe cay=cage]
      =+  ^=  vow
          %+  slop  q.cay
          |-  ^-  vase
          ?~  yom  [[%atom %n] ~]
          (slop q.i.yom $(yom t.yom))
      %+  cope
        %^  maim  cof  vow
        ^-  twig
        :+  %cncb  [%& 2]~
        =+  axe=3
        |-  ^-  (list (pair wing twig))
        ?~  yom  ~
        :-  [p.i.yom [%$ (peg axe 2)]]
        $(yom t.yom, axe (peg axe 3))
      |=  [cof=cafe vax=vase]
      (fine cof p.cay vax)
    ::
    ++  krab                                            ::  load to vase
      |=  [cof=cafe for=logo how=logo bem=beam rem=spur]
      ^-  (bolt vase)
      %+  cope  (fane cof %bake how bem rem)
      |=  [cof=cafe gen=twig]
      (maim cof pit gen)
    ::
    ++  lace                                            ::  load and check
      |=  [cof=cafe for=logo bem=beam rem=spur]
      ^-  (bolt (unit vase))
      =+  bek=`beak`[p.bem q.bem r.bem]
      %+  cope  (lend cof bem)
      |=  [cof=cafe arc=arch]
      ?^  q.arc
        (cope (liar cof bem) (lake for bek))
      ?:  (~(has by r.arc) %hook)
        %+  cope  (krab cof for %hook bem rem)
        |=  [cof=cafe vax=vase]
        %+  cope  ((lair for bem) cof vax)
        |=  [cof=cafe vax=vase]
        (fine cof ~ vax)
      ?:  (~(has by r.arc) %hoon)
        %+  cope  (krab cof for %hoon bem rem)
        (lake for bek)
      (fine cof ~)
    ::
    ++  lake                                            ::  check/coerce
      |=  [for=logo bek=beak]
      |=  [cof=cafe sam=vase]
      ^-  (bolt (unit vase))
      ?:  ?=(?(%gate %core %hoon %hook) for)
        (fine cof ~ sam)
      %+  cope  (make cof %boil %gate [[p.bek %main r.bek] /ref/[for]/sys] ~)
      |=  [cof=cafe cay=cage]
      %+  cope  (lane cof p.q.cay [%cnzy %$])
      |=  [cof=cafe ref=type]
      ?:  (~(nest ut ref) | p.sam)
        (fine cof ~ sam)
      %+  cope  (maul cof q.cay sam)
      |=  [cof=cafe pro=vase]
      (fine cof ~ pro)
    ::
    ++  lave                                            ::  validate
      |=  [cof=cafe for=logo sax=sack som=*]
      =+  lok=`case`[%da now]
      =+  ^=  own  ^-  ship
          =+  von=(ska %cy (tope [[p.sax %main lok] /core/ref/[for]/sys]))
          ?~(von q.sax p.sax)
      ((lake for [own %main lok]) cof [%noun som])
    ::
    ++  lair                                            ::  metaload
      |=  [for=logo bem=beam]
      |=  [cof=cafe vax=vase]
      ^-  (bolt vase)
      ?.  (~(nest ut -:!>(*silk)) | p.vax)
        (flaw cof (smyt (tope bem)) ~)
      %+  cope  (make cof ((hard silk) q.vax))
      |=  [cof=cafe cay=cage]
      (link cof for p.cay [p.bem q.bem r.bem] q.cay)
    ::
    ++  lane                                            ::  type infer
      |=  [cof=cafe typ=type gen=twig]
      %+  (coup cof)  (mule |.((~(play ut typ) gen)))
      |=(ref=type ref)
    ::
    ++  lend                                            ::  load arch
      |=  [cof=cafe bem=beam]
      ^-  (bolt arch)
      =+  von=(ska %cy (tope bem))
      ?~  von  [p=cof q=[%1 [bem ~] ~ ~]]
      (fine cof ((hard arch) (need u.von)))
    ::
    ++  liar                                            ::  load vase
      |=  [cof=cafe bem=beam]
      ^-  (bolt vase)
      =+  von=(ska %cx (tope bem))
      ?~  von
        [p=*cafe q=[%1 [[bem ~] ~ ~]]]
      ?~  u.von
        (flaw cof (smyt (tope bem)) ~)
      (fine cof ?^(u.u.von [%cell %noun %noun] [%atom %$]) u.u.von)
    ::
    ++  lily                                            ::  translation targets
      |=  [cof=cafe for=logo bek=beak]
      ^-  (bolt (list ,@tas))
      %+  cope
        %+  cope  (lend cof [p.bek %main r.bek] `path`~[%tan for %sys])
        |=  [cof=cafe arc=arch]
        (fine cof (turn (~(tap by r.arc) ~) |=([a=@tas b=~] a)))
      |=  [cof=cafe all=(list ,@tas)]
      (fine cof ?.(=(%hoon for) all [%hoot all]))
    ::
    ++  lima                                            ::  load at depth
      |=  [cof=cafe for=logo bem=beam rem=spur]
      ^-  (bolt (unit vase))
      %+  cope  (lend cof bem)
      |=  [cof=cafe arc=arch]
      ^-  (bolt (unit vase))
      ?:  (~(has by r.arc) for)
        (lace cof for bem(s [for s.bem]) rem)
      =+  haz=(turn (~(tap by r.arc) ~) |=([a=@tas b=~] a))
      ?~  haz  (fine cof ~)
      %+  cope  (lion cof for -.bem haz)
      |=  [cof=cafe wuy=(unit (list ,@tas))]
      ?~  wuy  (fine cof ~)
      ?>  ?=(^ u.wuy)
      %+  cope  (make cof %bake i.u.wuy bem rem)
      |=  [cof=cafe hoc=cage]
      %+  cope  (lope cof i.u.wuy t.u.wuy [p.bem q.bem r.bem] q.hoc)
      |=  [cof=cafe vax=vase]
      (fine cof ~ vax)
    ::
    ++  lime                                            ::  load beam
      |=  [cof=cafe for=logo bem=beam rem=spur]
      =+  [mob=bem mer=(flop rem)]
      |-  ^-  (bolt vase)
      %+  cope  (lima cof for mob (flop mer))
      |=  [cof=cafe vux=(unit vase)]
      ?^  vux  (fine cof u.vux)
      ?~  s.mob
        (flaw cof (smyt (tope bem)) ~)
      ^$(s.mob t.s.mob, mer [i.s.mob mer])
    ::
    ++  link                                            ::  translate
      |=  [cof=cafe too=logo for=logo bek=beak vax=vase]
      ^-  (bolt vase)
      ?:  =(too for)  (fine cof vax)
      ?:  |(=(%noun for) =(%$ for))
        %+  cope  ((lake too bek) cof vax)
        |=  [cof=cafe vux=(unit vase)]
        ?~  vux  (flaw cof [%leaf "ford: link {<too>}"]~)
        (fine cof u.vux)
      %+  cope  
        (make cof %boil %gate [[p.bek %main r.bek] /[too]/tan/[for]/sys] ~)
      |=  [cof=cafe cay=cage]
      (maul cof q.cay vax)
    ::
    ++  lion                                            ::  translation search
      |=  [cof=cafe too=@tas bek=beak fro=(list ,@tas)]
      ^-  (bolt (unit (list ,@tas)))
      =|  war=(set ,@tas)
      =<  -:(apex (fine cof fro))
      |%
      ++  apex
        |=  rof=(bolt (list ,@tas))
        ^-  [(bolt (unit (list ,@tas))) _+>]
        ?.  ?=(%0 -.q.rof)  [rof +>.$]
        ?~  q.q.rof
          [[p.rof [%0 p.q.rof ~]] +>.$]
        =^  orf  +>.$  (apse cof i.q.q.rof)
        ?.  ?=(%0 -.q.orf)
          [orf +>.$]
        ?~  q.q.orf
          $(cof p.orf, q.q.rof t.q.q.rof)
        [[p.orf [%0 (grom p.q.rof p.q.orf) q.q.orf]] +>.$]
      ::
      ++  apse
        |=  [cof=cafe for=@tas]
        ^-  [(bolt (unit (list ,@tas))) _+>]
        ?:  =(for too)
          [(fine cof [~ too ~]) +>.$]
        ?:  (~(has in war) for)  [(fine cof ~) +>]
        =.  war  (~(put in war) for)
        =^  hoc  +>.$  (apex (lily cof for bek))
        :_  +>.$
        %+  cope  hoc
        |=  [cof=cafe ked=(unit (list ,@tas))]
        (fine cof ?~(ked ~ [~ for u.ked]))
      --
    ::
    ++  lope                                            ::  translation pipe
      |=  [cof=cafe for=logo yaw=(list logo) bek=beak vax=vase]
      ^-  (bolt vase)
      ?~  yaw  (fine cof vax)
      %+  cope  (link cof i.yaw for bek vax)
      |=  [cof=cafe yed=vase]
      ^$(cof cof, for i.yaw, yaw t.yaw, vax yed)
    ::
    ++  maid                                            ::  make with path tag
      |=  [cof=cafe kas=silk]
      ^-  (bolt (pair path cage))
      %+  cope  (make cof kas)
      |=  [cof=cafe cay=cage]
      (fine cof (home kas) cay)
    ::
    ++  maim                                            ::  slap
      |=  [cof=cafe vax=vase gen=twig]
      ^-  (bolt vase)
      %+  (clef %slap)  (fine cof vax gen)
      |=  [cof=cafe vax=vase gen=twig]
      =+  puz=(mule |.((~(mint ut p.vax) [%noun gen])))
      ?-  -.puz
        |  (flaw cof p.puz)
        &  %+  (coup cof)  (mock [q.vax q.p.puz] (mole ska))
           |=  val=*
           `vase`[p.p.puz val]
      ==
    ::
    ++  make                                            ::  reduce silk
      |=  [cof=cafe kas=silk]
      ^-  (bolt cage)
      ::  ~&  [%make -.kas]
      ?-    -.kas
          ^
        %.  [cof p.kas q.kas]
        ;~  cope
          ;~  coax
            |=([cof=cafe p=silk q=silk] ^$(cof cof, kas p.kas))
            |=([cof=cafe p=silk q=silk] ^$(cof cof, kas q.kas))
          ==
        ::
          |=  [cof=cafe bor=cage heg=cage]  ^-  (bolt cage)
          [p=cof q=[%0 ~ [%$ (slop q.bor q.heg)]]]
        ==
      ::
          %bake
        %+  cool  |.(leaf/"ford: bake {<p.kas>} {<(tope q.kas)>}")
        %+  cope  (lima cof p.kas q.kas r.kas)
        |=  [cof=cafe vux=(unit vase)]
        ?~  vux
          (flaw cof (smyt (tope q.kas)) ~)
        (fine cof [p.kas u.vux])
      ::
          %boil
        %+  cool  |.(leaf/"ford: boil {<p.kas>} {<(tope q.kas)>} {<r.kas>}")
        %+  cope  (lime cof p.kas q.kas r.kas)
        |=  [cof=cafe vax=vase]
        (fine cof `cage`[p.kas vax])
      ::
          %brew
        ~&  %ford-brew
        %+  cool  |.(leaf/"ford: brew {<p.kas>} {<(tope q.kas)>} {<r.kas>}")
        %+  cope  (krab cof p.kas %hoon q.kas r.kas)
        |=  [cof=cafe vax=vase]
        (fine cof `cage`[p.kas vax])
      ::
          %call
        %+  cool  |.(leaf/"ford: call {<`@p`(mug kas)>}")
        %.  [cof p.kas q.kas]
        ;~  cope
          ;~  coax
            |=([cof=cafe p=silk q=silk] ^$(cof cof, kas p))
            |=([cof=cafe p=silk q=silk] ^$(cof cof, kas q))
          ==
        ::
          |=  [cof=cafe gat=cage sam=cage]
          (maul cof q.gat q.sam)
        ::
          |=  [cof=cafe vax=vase]
          (fine cof %noun vax)
        ==
      ::
          %cast
        %+  cool  |.(leaf/"ford: cast {<p.kas>} {<(tope q.kas ~)>}")
        %+  cope  $(kas r.kas)
        |=  [cof=cafe cay=cage]
        %+  cope  (link cof p.kas p.cay q.kas q.cay)
        |=  [cof=cafe vax=vase]
        (fine cof [p.kas vax])
      ::
          %done  [cof %0 p.kas q.kas]
          %dude  (cool |.(p.kas) $(kas q.kas))
          %dune
        ?~  q.kas  [cof [%2 [%leaf "no data"]~]]
        $(kas [%done p.kas u.q.kas])
      ::
          %mute  (kale cof p.kas q.kas)
          %plan  
        %+  cope  (main cof p.kas)
        |=  [cof=cafe vax=vase]
        (fine cof [%noun vax])
      ::
          %reef  (fine cof %noun pit)
          %ride
        %+  cool  |.(leaf/"ford: ride {<`@p`(mug kas)>}")
        %+  cope  $(kas p.kas)
        |=  [cof=cafe cay=cage]
        %+  cope  (gush cof q.kas)
        |=  [cof=cafe gen=twig]
        %+  cope  (maim cof q.cay gen)
        |=  [cof=cafe vax=vase]
        (fine cof %noun vax)
      ::
          %vale  
        %+  cool  |.(leaf/"ford: vale {<p.kas>} {<q.kas>} {<`@p`(mug r.kas)>}")
        %+  cope  (lave cof p.kas q.kas r.kas)
        |=  [cof=cafe vux=(unit vase)]
        ?~  vux
          (flaw cof [%leaf "invalid logos: {<[p.kas q.kas]>}"]~)
        (fine cof `cage`[p.kas u.vux])
      ==
    ::
    ++  maul                                            ::  slam
      |=  [cof=cafe gat=vase sam=vase]
      ^-  (bolt vase)
      =+  top=(mule |.((slit p.gat p.sam)))
      ?-  -.top
        |  (flaw cof p.top)
        &  %+  (coup cof)  (mong [q.gat q.sam] (mole ska))
           |=  val=*
           `vase`[p.top val]
      ==
    ::
    ++  plow                                            ::  true build
      |=  [cof=cafe pix=vase hyd=hood]
      =|  :*  rop=(map term twig) 
              bil=(map term (trel beam (set term) twig))
              ser=(map logo (map term vase))            ::  XX update for horn
          ==
      =<  apex
      |%
      ++  abet                                          ::   emit as vase
        |=  [gen=twig rex=vase]
        ^-  (bolt vase)
        %+  cope  acme
        |=  [cof=cafe lib=twig]
        %+  cope  (maim cof pix [%tsgr able lib])
        |=  [cof=cafe vax=vase]
        (maim cof ?~(ser vax (slop acta vax)) gen)
      ::
      ++  able                                          ::  assemble preamble
        ^-  twig
        ?~(rop [%$ 1] [%brcn (~(run by rop) |=(a=twig [%ash a]))])
      ::
      ++  acta                                          ::  assemble resources
        ^-  vase
        =<  apex
        |%  
        ++  apex
          ?~  ser  !!
          =+  top=(ayah p.n.ser (axel q.n.ser))
          ?~  l.ser
            ?~(r.ser top (slop top apex(ser r.ser)))
          =+  lef=apex(ser l.ser)
          ?~(r.ser (slop lef top) :(slop lef top apex(ser r.ser)))
        ::  
        ++  axel
          |=  ryz=(map term vase)
          ^=  vax  
          |-  ^-  vase
          ?~  ryz  !!
          =+  top=(ayah n.ryz)
          ?~  l.ryz
            ?~(r.ryz top (slop top $(ryz r.ryz)))
          =+  lef=$(ryz r.ryz)
          ?~(r.ryz (slop lef top) :(slop lef top $(ryz r.ryz)))
        ::
        ++  ayah
          |=  [cog=term vax=vase]
          [[%face cog p.vax] q.vax]
        --
      ::
      ++  acme                                          ::  libraries in order
        ^-  (bolt twig)
        %-  cope
        :_  |=  [cof=cafe cus=(list twig)]
            (fine cof [%tssg cus])
        =+  kop=(turn (~(tap by bil) ~) |=([term *] -))
        =|  [dun=(set term) cus=(list twig)]
        |-  ^-  (bolt (list twig))
        ?~  kop  (fine cof cus) 
        =+  cog=i.kop
        ?:  (~(has in dun) cog)  $(kop t.kop)
        =+  liv=`(set term)`[cog ~ ~]
        |-  ^-  (bolt (list twig))
        =+  zic=(need (~(get by bil) cog))
        =+  dez=`(list term)`(~(tap in q.zic) ~)
        |-  ^-  (bolt (list twig))
        ?~  dez
          ^^$(cus [p.zic cus], dun (~(put in dun) cog), kop t.kop)
        ?:  (~(has in dun) i.dez)
          $(dez t.dez)
        ?:  (~(has in liv) cog)
          (flaw cof [%leaf "build error: {<cog>} depends on itself}"])
        ^$(cog i.dez, liv (~(put in liv) cog), kop [i.kop kop])
      ::
      ++  aloe                                          ::  process all
        ^-  (bolt (trel vase twig ,_..aloe))
        %+  cope  body
        |=  [cof=cafe cus=(list twig) sel=_..aloe]
        =.  ..aloe  sel(cof cof)
        %+  cope  head
        |=  [cof=cafe sel=_..aloe]
        =.  ..aloe  sel(cof cof)
        %+  cope  butt
        |=  [cof=cafe sel=_..aloe]
        ::  =.  ..aloe  sel(cof cof)
        ::  %+  cope  eyes
        ::  |=  [cof=cafe pix=vase sel=_..aloe]
        ::  (fine cof [%tssg (flop cus)] pix sel(cof cof))
        (fine cof [%tssg (flop cus)] !>(~) sel(cof cof))
      ::
      ++  apex                                          ::  top level
        ^-  (bolt vase)
        %+  cope  aloe
        |=  [cof=cafe cus=(list twig) sel=_..aloe]
        (abet:sel(cof cof) cus)
      ::
      ++  body                                          ::  process body
        =+  cus=(list twig)
        |-  ^-  (bolt (pair (list twig) ,_..body))
        ?~  src.hyd
          (fine cof cus ..body)
        %+  cope  (wilt i.src.hyd)
        |=  [cof=cafe gen=twig sel=_..body]
        $(src.hyd t.src.hyd, cus [gen cus], ..body sel(cof cof))
      ::
      ++  butt                                          ::  process libraries
        =+  bol=(~(tap by lib.hyd) ~)
        |-  ^-  (bolt ,_..butt)
        ?~  bol  ..butt
        ?.  =+  olb=(~(get by bil) p.i.bol)
            ?~  olb  &
            =(`beam`p.u.olb `beam`q.i.bol)
          (flaw cof [%leaf "build error: {<p.i.bol>} {<p.u.olb>} {<q.i.bol>}]~)
        %+  cope  (wine q.i.bol)
        |=  [cof=cafe gen=twig dep=(set term) dah=hood]
        ^$(olb  
      ::
      ++  wilt                                          ::  process body entry
        |=  hop=hoop
        ^-  (bolt ,[p=twig q=_..wilt])
        ?+  -.hop  !!
          %code  (fine p.hop ..wilt)
          %hoon  (wine p.hop)
        ==
      ::
      ++  wind                                          ::  sub-hood, no deps
        |=  bem=beam 
        ^-  (bolt ,[p=twig r=_..wind])
        %+  cope  (fade cof %bake %hoon bem ~)
        |=  [cof=cafe dah=hood]
        %+  cope  aloe(hyd dah)
        |=  [cof=cafe cus=(list twig) sel=_..wind]
        (fine [%tssg (flop cus)] sel(hyd hyd, cof cof))
      ::
      ++  wine                                          ::  sub-hood, deps
        |=  bem=beam 
        ^-  (bolt ,[p=twig q=(set term) r=_..wind])
        %+  cope  (fade cof %bake %hoon bem ~)
        |=  [cof=cafe dah=hood]
        %+  cope  aloe(hyd dah, lib ~)
        |=  [cof=cafe cus=(list twig) sel=_..wind]
        %^    fine
            [%tssg (flop cus)]
          lib.sel
        sel(hyd hyd, lib (~(uni in lib.sel) lib), cof cof)
      --
    ::
    ++  resp
      |=  [tik=@ud rot=riot]
      ^+  ..zo
      ?>  (~(has by q.kig) tik)
      ?~  rot
        amok:(expo [%made %| (smyt (tope (need (~(get by q.kig) tik)))) ~])
      exec(q.kig (~(del by q.kig) tik))
    --
  --
--
.  ==
=|  axle
=*  lex  -
|=  [now=@da eny=@ ski=sled]                            ::  activate
^?                                                      ::  opaque core
|%                                                      ::
++  call                                                ::  request
  |=  [hen=duct hic=(hypo (hobo kiss))]
  ^-  [p=(list move) q=_..^$]
  =>  .(q.hic ?.(?=(%soft -.q.hic) q.hic ((hard kiss) p.q.hic)))
  =+  ska=(slod ski)
  =+  ^=  our  ^-  @p
      ?-  -.q.hic
        %exec  p.q.hic
      ==
  =+  ^=  bay  ^-  baby
      =+  buy=(~(get by pol.lex) our)
      ?~(buy *baby u.buy)
  =^  mos  bay
    abet:(~(apex za [[our ~ hen] [now eny ska] ~] bay) q.q.hic)
  [mos ..^$(pol (~(put by pol) our bay))]
::
++  doze
  |=  [now=@da hen=duct]
  ^-  (unit ,@da)
  ~
::
++  load                                                ::  highly forgiving
  |=  old=*
  =.  old  
      ?.  ?=([%0 *] old)  old                           ::  remove at 1
      :-  %1 
      |-  ^-  *
      ?~  +.old  ~
      ?>  ?=([n=[p=* q=[tad=* dym=* jav=*]] l=* r=*] +.old)
      :-  [p.n.+.old [tad.q.n.+.old dym.q.n.+.old ~]]
      [$(+.old l.+.old) $(+.old r.+.old)]
  =+  lox=((soft axle) old)
  ^+  ..^$
  ?~  lox
    ~&  %ford-reset
    ..^$
  ..^$(+>- u.lox)
::
++  scry
  |=  [fur=(unit (set monk)) ren=@tas who=ship syd=desk lot=coin tyl=path]
  ^-  (unit (unit (pair logo ,*)))
  ~
::
++  stay                                                ::  save w/o cache
  `axle`+>-.$(pol (~(run by pol) |=(a=baby [tad.a dym.a ~])))
::
++  take                                                ::  response
  |=  [tea=wire hen=duct hin=(hypo sign)]
  ^-  [p=(list move) q=_..^$]
  =+  ska=(slod ski)
  ?>  ?=([@ @ @ ~] tea)
  =+  :*  our=(need (slaw %p i.tea))
          num=(need (slaw %ud i.t.tea))
          tik=(need (slaw %ud i.t.t.tea))
      ==
  =+  bay=(need (~(get by pol.lex) our))
  =^  mos  bay
    abet:(~(axon za [[our tea hen] [now eny ska] ~] bay) num tik q.hin)
  [mos ..^$(pol (~(put by pol) our bay))]
--
