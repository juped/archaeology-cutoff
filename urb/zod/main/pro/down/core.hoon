::
::::  /hoon/core/down/pro
  ::
/?  314
/-  markdown
=+  markdown
!:
::::
  ::
|_  don=down
++  grab                                                ::  convert from
  |%  
  ++  md                                                ::  convert from %md
    |=  src=@t
    =<  (mark (trip src))
    |%
    ++  mark
      |=  p=tape
      (scan p apex)
    ::
    ++  apex                                            :: markdown parser
      |=  tub=nail
      ^-  (like down)
      =+  sep=(sepa tub)
      ?~  q.sep  [p.sep ~]
      :-  p.sep  
      %-  some  :_  [p.sep ~] 
      (turn p.u.q.sep |=(a=tape (scan a blos)))
    ::
    ++  base  %+  stag  %par 
      ;~  plug 
        (stag %tex (plus ;~(pose prn eol))) 
        (easy ~)
      ==
    ::
    ++  blos                                            ::  block element
      %+  knee  *barb  |.  ~+
      ;~  pose 
        head  quot  lasd  horz 
        code  codf  html  para  base
      ==
    ::
    ++  brek  (stag %cut (cold ~ ;~(plug fas fas)))    ::  line break
    ++  chrd  ;~(pose escp prn (cold ' ' eol))          ::  shin character data
    ++  code                                            ::  code block
      %+  stag  %pre
      %-  full
      %-  plus
      ;~  pfix  (stun [4 4] ace)
        ;~  pose 
          %+  cook  welp 
            ;~(plug (plus prn) (cold "\0a" eol))
          (full (plus prn))
        ==
      ==
    ::
    ++  codf                                            ::  fenced code block 
      %+  stag  %pre
      %-  full  
      %+  ifix  
      [;~(plug tec tec tec eol) ;~(plug tec tec tec)]
        %-  plus
          ;~  pose 
            %+  cook  welp 
              ;~(plug (plus prn) (cold "\0a" eol))
            (full (plus ;~(less ;~(plug tec tec tec) prn)))
          ==
    ::
    ++  cods                                            ::  code shin
      %+  stag  %cod
      =+  chx=;~(pose (cold ' ' eol) prn)
      ;~  pose
        %+  ifix  [(jest '```') (jest '```')]  
          (plus ;~(less (jest '```') chx))
        %+  ifix  [(jest '``') (jest '``')] 
          (plus ;~(less (jest '``') chx))
        (ifix [tec tec] (plus ;~(less tec chx)))
      ==
    ::
    ++  dont                                            ::  control chars
      ;~  pose  tar  tec  cab  sel
        ;~(plug sig sig) 
        ;~(plug fas fas)
      ==
    ++  spas                                            ::  all shin elements
      |*  res=_rule
      %-  plus 
      ;~  pose   emph   stri   link 
        brek  cods  (text res)
      ==
    ::
    ++  eol  (just `@`10)                               ::  newline
    ++  emph                                            ::  emphasis
      %+  knee  *shin  |.  ~+
      %+  stag  %emp
      =+  inn=(plus ;~(pose cods stri link (text fail)))
      ;~  pose
        (ifix [(jest '***') (jest '***')] (stag %both inn))
        (ifix [(jest '**_') (jest '_**')] (stag %both inn))
        (ifix [(jest '*__') (jest '__*')] (stag %both inn))
        (ifix [(jest '_**') (jest '**_')] (stag %both inn))
        (ifix [(jest '__*') (jest '*__')] (stag %both inn))
        (ifix [(jest '___') (jest '___')] (stag %both inn))
        (ifix [(jest '**') (jest '**')] (stag %bold inn))
        (ifix [(jest '__') (jest '__')] (stag %bold inn))
        (ifix [tar tar] (stag %bent inn))
        (ifix [cab cab] (stag %bent inn))
      ==
    ::
    ++  escp                                             ::  escapable chars
      ;~  pose
        (cold '`' (jest '\\`'))
        (cold '*' (jest '\\*'))
        (cold '#' (jest '\\#'))
        (cold '-' (jest '\\-'))
        (cold '.' (jest '\\.'))
        (cold '{' (jest '\\{'))
        (cold '}' (jest '\\}'))
        (cold '[' (jest '\\['))
        (cold ']' (jest '\\]'))
        (cold '\\' (jest '\\\\'))
      ==
    ::
    ++  head                                            ::  header
      %+  stag  %had
      =+  ^=  hed
          ;~  pose
            ;~  plug 
              ;~(pfix wits (spas hax)) 
              (cook some (ifix [;~(plug (star hax) sel hax) ser] (plus alp)))
            ==
            (ifix [wits (star hax)] ;~(plug (spas hax) (easy ~)))
          ==
      =+  ^=  sed
          ;~  pose
            ;~  plug 
              (spas ;~(pose eol sel))
              (cook some (ifix [;~(plug sel hax) ser] (plus alp)))
            ==
            ;~(plug (spas eol) (easy ~))
          ==
      %-  full
        ;~  pose
          ;~  pfix  (jest '######')  (stag 6 hed)  ==
          ;~  pfix  (jest '#####')   (stag 5 hed)  ==
          ;~  pfix  (jest '####')    (stag 4 hed)  ==
          ;~  pfix  (jest '###')     (stag 3 hed)  ==
          ;~  pfix  (jest '##')      (stag 2 hed)  ==
          ;~  pfix  (jest '#')       (stag 1 hed)  ==
          (stag 1 (ifix [wits ;~(plug eol (plus tis))] sed))
          (stag 2 (ifix [wits ;~(plug eol (plus hep))] sed))
        ==
    ::
    ++  horz                                            ::  horizontal rule
      %+  stag  %hot
      %+  cold  ~  
      %-  full
      ;~  pose 
        ;~(plug (stun [0 3] ace) hep wits hep wits hep (star ;~(pose hep wite)))
        ;~(plug (stun [0 3] ace) tar wits tar wits tar (star ;~(pose tar wite)))
        ;~(plug (stun [0 3] ace) cab wits cab wits cab (star ;~(pose cab wite)))
      ==
    ::
    ++  html  (stag %hem apex:xmlp)                    ::  html barb
    ++  lasd                                            ::  top level list
      %+  stag  %lit
      %-  full
        ;~  pose
          (stag & (lisd ;~(plug (star nud) dot)))
          (stag | (lisd hep))
          (stag | (lisd tar))
          (stag | (lisd lus))
        ==
    ::
    ++  lisd                                            ::  list funk
      |*  bus=_rule
      |=  tub=nail
      ^-  (like down)
      =+  chx=;~(plug (plus prn) (cold "\0a" eol))
      =-  ?~  q.pre  pre
          :-  p.pre  %-  some 
          [(turn `wall`p.u.q.pre |=(a=tape [%lie (scan a apex)])) [p.pre ~]]
      ^=  pre  %.  tub
      %+  most  ;~(pose ;~(plug wits eol) (easy ~))
      %+  cook  |=(a=wall `tape`(zing a))               :: XX core dump w/o cast
      ;~  plug
        %+  cook  zing
        ;~  pose
          (full ;~(pfix bus ace ;~(plug (plus prn) (easy ~))))
          ;~(pfix bus ace ;~(plug (plus prn) (cold "\0a" eol) (easy ~)))
        ==
        %-  star
        ;~  pose
          ;~(plug ;~(sfix eol ace ace) (cook welp chx))
          ;~(pfix ace ace (cook welp chx))
          (full ;~(pfix ace ace (plus prn)))
        ==
      ==
    ::
    ++  link                                            ::  link element
      %+  knee  *shin  |.  ~+
      %+  stag  %lin
      ;~  plug
        (ifix [sel ser] (plus ;~(pose emph stri cods (text ser))))
        ;~  pose
          %+  ifix  [pel per]
          ;~  plug  
            ;~(sfix (cook zing (most eol (plus ;~(less ace prn)))) ace)
            (cook some (ifix [doq doq] (plus ;~(less doq ;~(pose prn eol)))))
          ==
          %+  ifix  [pel per] 
          ;~(plug (cook zing (most eol (plus ;~(less per prn)))) (easy ~))
        ==
      ==
    ::
    ++  para  (stag %par (full (spas fail)))           ::  paragraph
    ++  quot                                            ::  blockquotes
      %+  stag  %quo 
      %-  full
      |=  tub=nail
      ^-  (like down)
      =-  ?~  q.pre
            [p.pre ~]
          (apex [[1 1] (welp p.u.q.pre q.q.u.q.pre)])
      ^=  pre  %.  tub  
      %+  cook  |=(a=wall `tape`(zing a))  
      %-  plus
      ;~  pfix  ;~(pose ;~(plug gar ace) gar)
        ;~  pose 
          (cook welp ;~(plug (star prn) (cold "\0a" eol))) 
          (full (star prn))
        ==
      ==
    ::
    ++  sepa                                            ::  separate barbs
      %+  knee  *wall  |.  ~+
      =+  lin=;~(plug eol wits eol)
      %+  ifix  [(star whit) (star whit)]
      %+  more  ;~(plug eol wits (more wits eol))
        ;~  pose
          (sepl (cold "-" hep))
          (sepl (cold "*" tar))
          (sepl (cold "+" lus))
          (sepl (cook welp ;~(plug (star nud) (cold "." dot))))
          (plus ;~(less lin ;~(pose prn ;~(simu ;~(plug eol prn) eol))))
        ==
    ::
    ++  sepl                                            ::  separate list
      |*  bus=_rule
      %+  cook  zing
      %+  most  ;~(pose ;~(plug wits eol) (easy ~))
      %+  cook  |=(a=wall `tape`(zing a))
      ;~  plug
        %+  cook  |=(a=wall `tape`(zing a))
        ;~  pose
          ;~(plug bus (cold " " ace) (plus prn) (cold "\0a" eol) (easy ~))
          (full ;~(plug bus (cold " " ace) (plus prn) (easy ~)))
        ==
      %-  star
        ;~  pose
          ;~  pfix  wits
            ;~  plug   eol   ace   ace 
              (cook welp ;~(plug (plus prn) (cold "\0a" eol)))
            ==
          ==
          ;~(plug ace ace (cook welp ;~(plug (plus prn) (cold "\0a" eol))))
          (full ;~(plug ace ace (plus prn)))
        ==
      ==
    ::
    ++  stri                                            ::  strikethrough text 
      %+  stag  %ike
      %+  ifix   [(jest '~~') (jest '~~')] 
      (plus ;~(pose emph cods link (text fail)))
    ::
    ++  text  |*(res=_rule (stag %tex (plus ;~(less ;~(pose res dont) chrd))))
    ++  whit  (mask ~[`@`0x20 `@`0x9 `@`0xa])           ::  whitespace w/nl
    ++  wite  (mask ~[`@`0x20 `@`0x9])                  ::  whitespace
    ++  wits  (star wite)  
    --
  ::
  ++  noun                                              ::  convert from %noun
    |=  src=*
    ^+  +>+
    +>+(don (down src))
  --
::
++  grow                                                ::  convert into
  |%
  ++  html                                              ::  convert into %heml
    =<  :(appd '<html><body>' (abet don) '</body></html>')
    |%
    ++  abet
      |=(don=down (crip (xmll | (apex don) ~)))
    ++  appd
      |=  [p=@ q=@]
      ^-  @
      (cat 3 p q)
    ::
    ++  apex  |=(don=down (turn don |=(bol=barb (blok bol))))
    ++  blok
      |=  bol=barb
      ^-  manx
      ?-  bol
        [%had *]  
            :_  (turn q.bol sank)
            [(cat 3 'h' (scot %ud p.bol)) ?~(r.bol ~ [[%id u.r.bol] ~])]
        [%par *]  [[%p ~] (turn p.bol sank)]
        [%hot *]  [[%hr ~] ~]
        [%pre *]  [[%pre ~] ~[[[%$ [[%$ (zing p.bol)] ~]] ~]]]
        [%quo *]  [[%blockquote ~] (apex p.bol)]
        [%lie *]  [[%li ~] (apex p.bol)]
        [%lit *]  ?:  =(& p.bol)  [[%ol ~] (apex q.bol)]
                   [[%ul ~] (apex q.bol)]
        [%hem *]  p.bol
      ==
    ::
    ++  sank
      |=  san=shin
      ^-  manx
      ?-  san
        [%tex *]  [[%$ [[%$ p.san] ~]] ~]
        [%cut *]  [[%br ~] ~]
        [%ike *]  [[%del ~] (turn p.san ..$)]
        [%cod *]  [[%pre ~] ~[[[%$ [[%$ p.san] ~]] ~]]]
        [%emp *]  
          ?:  =(%bent p.san)  [[%em ~] (turn q.san ..$)]
          ?:  =(%bold p.san)  [[%strong ~] (turn q.san ..$)]
          [[%em ~] ~[[[%strong ~] (turn q.san ..$)]]]
        [%lin *]  
          ?~  r.san  [[%a ~[[%href q.san]]] (turn p.san ..$)]
          [[%a ~[[%href q.san] [%title u.r.san]]] (turn p.san ..$)]
      ==
    --
  --
--
