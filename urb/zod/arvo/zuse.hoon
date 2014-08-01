::
::  zuse (3), standard library (tang)
::
|%
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::  ::
::::              chapter 3b, Arvo libraries            ::::
::  ::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                section 3bA, lite number theory       ::
::
++  fu                                                  ::  modulo (mul p q)
  |=  a=[p=@ q=@]
  =+  b=?:(=([0 0] a) 0 (~(inv fo p.a) (~(sit fo p.a) q.a)))
  |%
  ++  dif
    |=  [c=[@ @] d=[@ @]]
    [(~(dif fo p.a) -.c -.d) (~(dif fo q.a) +.c +.d)]
  ::
  ++  exp
    |=  [c=@ d=[@ @]]
    :-  (~(exp fo p.a) (mod c (dec p.a)) -.d)
    (~(exp fo q.a) (mod c (dec q.a)) +.d)
  ::
  ++  out                                               ::  garner's formula
    |=  c=[@ @]
    %+  add
      +.c
    (mul q.a (~(pro fo p.a) b (~(dif fo p.a) -.c (~(sit fo p.a) +.c))))
  ::
  ++  pro
    |=  [c=[@ @] d=[@ @]]
    [(~(pro fo p.a) -.c -.d) (~(pro fo q.a) +.c +.d)]
  ::
  ++  sum
    |=  [c=[@ @] d=[@ @]]
    [(~(sum fo p.a) -.c -.d) (~(sum fo q.a) +.c +.d)]
  ::
  ++  sit
    |=  c=@
    [(mod c p.a) (mod c q.a)]
  --
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                section 3bB, cryptosuites             ::
::
++  crua                                                ::  cryptosuite A (RSA)
  ^-  acru
  =|  [mos=@ pon=(unit ,[p=@ q=@ r=[p=@ q=@] s=_*fu])]
  =>  |%
      ++  mx  (dec (met 0 mos))                         ::  bit length
      ++  dap                                           ::  OEAP decode
        |=  [wid=@ xar=@ dog=@]  ^-  [p=@ q=@]
        =+  pav=(sub wid xar)
        =+  qoy=(cut 0 [xar pav] dog)
        =+  dez=(mix (end 0 xar dog) (shaw %pad-b xar qoy))
        [dez (mix qoy (shaw %pad-a pav dez))]
      ::
      ++  pad                                           ::  OEAP encode
        |=  [wid=@ rax=[p=@ q=@] meg=@]  ^-  @
        =+  pav=(sub wid p.rax)
        ?>  (gte pav (met 0 meg))
        ^-  @
        =+  qoy=(mix meg (shaw %pad-a pav q.rax))
        =+  dez=(mix q.rax (shaw %pad-b p.rax qoy))
        (can 0 [p.rax dez] [pav qoy] ~)
      ::
      ++  pull  |=(a=@ (~(exp fo mos) 3 a))
      ++  push  |=(a=@ (~(exp fo mos) 5 a))
      ++  pump
        |=  a=@  ^-  @
        ?~  pon  !!
        (out.s.u.pon (exp.s.u.pon p.r.u.pon (sit.s.u.pon a)))
      ::
      ++  punt
        |=  a=@  ^-  @
        ?~  pon  !!
        (out.s.u.pon (exp.s.u.pon q.r.u.pon (sit.s.u.pon a)))
      --
  |%
  ++  as
    =>  |%
        ++  haul                                        ::  revealing haul
          |=  a=pass
          =+  [mag=(end 3 1 a) bod=(rsh 3 1 a)]
          ?>  =('a' mag)
          ..as(mos bod, pon ~)
        --
    ^?
    |%  ++  seal
          |=  [a=pass b=@ c=@]
          ^-  @
          =>  .(c (sign b c))
          =+  her=(haul a)
          =+  det=(lte (add 256 (met 0 c)) mx.her)
          =+  lip=?:(det c 0)
          =-  (add ?:(p.mav 0 1) (lsh 0 1 q.mav))
          ^=  mav  ^-  [p=? q=@]
          :-  det
          =+  dog=(pad mx.her [256 b] lip)
          =+  hog=(push.her dog)
          =+  ben=(en b c)
          ?:(det hog (jam hog ben))
        ++  sign
          |=  [a=@ b=@]  ^-  @
          =-  (add ?:(p.mav 0 1) (lsh 0 1 q.mav))
          ^=  mav  ^-  [p=? q=@]
          =+  det=(lte (add 128 (met 0 b)) mx)
          :-  det
          =+  hec=(shaf (mix %agis a) b)
          =+  dog=(pad mx [128 hec] ?:(det b 0))
          =+  hog=(pump dog)
          ?:(det hog (jam hog b))
        ++  sure
          |=  [a=@ b=@]
          ^-  (unit ,@)
          =+  [det==(0 (end 0 1 b)) bod=(rsh 0 1 b)]
          =+  gox=?:(det [p=bod q=0] ((hard ,[p=@ q=@]) (cue bod)))
          =+  dog=(pull p.gox)
          =+  pig=(dap mx 128 dog)
          =+  log=?:(det q.pig q.gox)
          ?.(=(p.pig (shaf (mix %agis a) log)) ~ [~ log])
        ++  tear
          |=  [a=pass b=@]
          ^-  (unit ,[p=@ q=@])
          =+  her=(haul a)
          =+  [det==(0 (end 0 1 b)) bod=(rsh 0 1 b)]
          =+  gox=?:(det [p=bod q=0] ((hard ,[p=@ q=@]) (cue bod)))
          =+  dog=(punt p.gox)
          =+  pig=(dap mx 256 dog)
          =+  ^=  cow
              ^-  (unit ,@)
              ?:  det
                [~ q.pig]
              (de p.pig q.gox)
          ?~  cow  ~
          =>  .(cow (sure:as.her p.pig u.cow))
          ?~  cow  ~
          [~ p.pig u.cow]
    --
  ::
  ++  de
    |+  [key=@ cep=@]  ^-  (unit ,@)
    =+  toh=(met 8 cep)
    ?:  (lth toh 2)
      ~
    =+  adj=(dec toh)
    =+  [hax=(end 8 1 cep) bod=(rsh 8 1 cep)]
    =+  msg=(mix (~(raw og (mix hax key)) (mul 256 adj)) bod)
    ?.  =(hax (shax (mix key (shax (mix adj msg)))))
      ~
    [~ msg]
  ::
  ++  dy  |+([a=@ b=@] (need (de a b)))
  ++  en
    |+  [key=@ msg=@]  ^-  @ux
    =+  len=(met 8 msg)
    =+  adj=?:(=(0 len) 1 len)
    =+  hax=(shax (mix key (shax (mix adj msg))))
    (rap 8 hax (mix msg (~(raw og (mix hax key)) (mul 256 adj))) ~)
  ::
  ++  ex  ^?
    |%  ++  fig  ^-  @uvH  (shaf %afig mos)
        ++  pac  ^-  @uvG  (end 6 1 (shaf %acod sec))
        ++  pub  ^-  pass  (cat 3 'a' mos)
        ++  sec  ^-  ring  ?~(pon !! (cat 3 'A' (jam p.u.pon q.u.pon)))
    --
  ::
  ++  nu
    =>  |%
        ++  elcm
          |=  [a=@ b=@]
          (div (mul a b) d:(egcd a b))
        ::
        ++  eldm
          |=  [a=@ b=@ c=@]
          (~(inv fo (elcm (dec b) (dec c))) a)
        ::
        ++  ersa
          |=  [a=@ b=@]
          [a b [(eldm 3 a b) (eldm 5 a b)] (fu a b)]
        --
    ^?
    |%  ++  com
          |=  a=@
          ^+  ^?(..nu)
          ..nu(mos a, pon ~)
        ::
        ++  pit
          |=  [a=@ b=@]
          =+  c=(rsh 0 1 a)
          =+  [d=(ramp c [3 5 ~] b) e=(ramp c [3 5 ~] +(b))]
          ^+  ^?(..nu)
          ..nu(mos (mul d e), pon [~ (ersa d e)])
        ::
        ++  nol
          |=  a=@
          ^+  ^?(..nu)
          =+  b=((hard ,[p=@ q=@]) (cue a))
          ..nu(mos (mul p.b q.b), pon [~ (ersa p.b q.b)])
    --
  --
++  bruw                                                ::  create keypair
  |=  [a=@ b=@]                                         ::  width seed
  ^-  acru
  (pit:nu:crua a b)
::
++  haul                                                ::  activate public key
  |=  a=pass
  ^-  acru
  =+  [mag=(end 3 1 a) bod=(rsh 3 1 a)]
  ?>  =('a' mag)
  (com:nu:crua bod)
::
++  weur                                                ::  activate secret key
  |=  a=ring
  ^-  acru
  =+  [mag=(end 3 1 a) bod=(rsh 3 1 a)]
  ?>  =('A' mag)
  (nol:nu:crua bod)
::
++  trua                                                ::  test rsa
  |=  msg=@tas
  ^-  @
  =+  ali=(bruw 1.024 (shax 'ali'))
  =+  bob=(bruw 1.024 (shax 'bob'))
  =+  tef=(sign:as.ali [0 msg])
  =+  lov=(sure:as.ali [0 tef])
  ?.  &(?=(^ lov) =(msg u.lov))
    ~|(%test-fail-sign !!)
  =+  key=(shax (shax (shax msg)))
  =+  sax=(seal:as.ali pub:ex.bob key msg)
  =+  tin=(tear:as.bob pub:ex.ali sax)
  ?.  &(?=(^ tin) =(key p.u.tin) =(msg q.u.tin))
    ~|(%test-fail-seal !!)
  msg
::
++  crub                                                ::  cryptosuite B (Ed)
  ^-  acru
  =|  [puc=pass sed=ring]
  =>  |%
      ++  dap                                           ::  OEAP decode
        |=  [wid=@ xar=@ dog=@]  ^-  [p=@ q=@]
        =+  pav=(sub wid xar)
        =+  qoy=(cut 0 [xar pav] dog)
        =+  dez=(mix (end 0 xar dog) (shaw %pad-b xar qoy))
        [dez (mix qoy (shaw %pad-a pav dez))]
      ::
      ++  pad                                           ::  OEAP encode
        |=  [wid=@ rax=[p=@ q=@] meg=@]  ^-  @
        =+  pav=(sub wid p.rax)
        ?>  (gte pav (met 0 meg))
        ^-  @
        =+  qoy=(mix meg (shaw %pad-a pav q.rax))
        =+  dez=(mix q.rax (shaw %pad-b p.rax qoy))
        (can 0 [p.rax dez] [pav qoy] ~)
      --
  |%
  ++  as
    =>  |%
        ++  haul                                        ::  revealing haul
          |=  a=pass
          !!
        --
    ^?
    |%  ++  seal
          |=  [a=pass b=@ c=@]
          ^-  @
          !!
        ++  sign
          |=  [a=@ b=@]  ^-  @
          !!
        ++  sure
          |=  [a=@ b=@]
          ^-  (unit ,@)
          !!
        ++  tear
          |=  [a=pass b=@]
          ^-  (unit ,[p=@ q=@])
          !!
    --
  ::
  ++  de
    |+  [key=@ cep=@]  ^-  (unit ,@)
    !!
  ::
  ++  dy
    |+  [a=@ b=@]  ^-  @
    !!
  ++  en
    |+  [key=@ msg=@]  ^-  @ux
    !!
  ::
  ++  ex  ^?
    |%  ++  fig  ^-  @uvH  (shaf %bfig puc)
        ++  pac  ^-  @uvG  (end 6 1 (shaf %acod sec))
        ++  pub  ^-  pass  (cat 3 'b' puc)
        ++  sec  ^-  ring  sed
    --
  ::
  ++  nu
    ^?
    |%  ++  com
          |=  a=@
          ^+  ^?(..nu)
          ..nu(sed ~, puc a)
        ::
        ++  pit
          |=  [a=@ b=@]
          ^+  ^?(..nu)
          ..nu(sed b, puc (puck:ed b))
        ::
        ++  nol
          |=  a=@
          ^+  ^?(..nu)
          ..nu(sed a, puc (puck:ed a))
    --
  --
++  brew                                                ::  create keypair
  |=  [a=@ b=@]                                         ::  width seed
  ^-  acru
  (pit:nu:crub a b)
::
++  hail                                                ::  activate public key
  |=  a=pass
  ^-  acru
  =+  [mag=(end 3 1 a) bod=(rsh 3 1 a)]
  ?>  =('b' mag)
  (com:nu:crub bod)
::
++  wear                                                ::  activate secret key
  |=  a=ring
  ^-  acru
  =+  [mag=(end 3 1 a) bod=(rsh 3 1 a)]
  ?>  =('b' mag)
  (nol:nu:crub bod)
::
++  trub                                                ::  test ed
  |=  msg=@tas
  ^-  @
  =+  ali=(brew 1.024 (shax 'ali'))
  =+  bob=(brew 1.024 (shax 'bob'))
  =+  tef=(sign:as.ali [0 msg])
  =+  lov=(sure:as.ali [0 tef])
  ?.  &(?=(^ lov) =(msg u.lov))
    ~|(%test-fail-sign !!)
  =+  key=(shax (shax (shax msg)))
  =+  sax=(seal:as.ali pub:ex.bob key msg)
  =+  tin=(tear:as.bob pub:ex.ali sax)
  ?.  &(?=(^ tin) =(key p.u.tin) =(msg q.u.tin))
    ~|(%test-fail-seal !!)
  msg
::
++  hmac                                                ::  HMAC-SHA1
  |=  [key=@ mes=@]
  =+  ip=(fil 2 64 0x36)
  =+  op=(fil 3 64 0x5c)
  =+  ^=  kex
      ?:  (gth (met 3 key) 64)
        (lsh 3 44 (shan (swap 3 key)))
      (lsh 3 (sub 64 (met 3 key)) (swap 3 key))
  =+  inn=(shan (swap 3 (cat 3 (swap 3 mes) (mix ip kex))))
  (shan (swap 3 (cat 3 inn (mix op kex))))
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                section 3bC, UTC                      ::  Gregorian only
::
++  dawn                                                ::  Jan 1 weekday
  |=  yer=@ud
  =+  yet=(sub yer 1)
  %-  mod  :_  7
  :(add 1 (mul 5 (mod yet 4)) (mul 4 (mod yet 100)) (mul 6 (mod yet 400)))
::
++  daws                                                ::  date weekday
  |=  yed=date
  %-  mod  :_  7
  (add (dawn y.yed) (sub (yawn [y.yed m.yed d.t.yed]) (yawn y.yed 1 1)))
::
++  deal                                                ::  to leap sec time
  |=  yer=@da
  =+  n=0
  =+  yud=(yore yer)
  |-  ^-  date
  ?:  (gte yer (add (snag n lef:yu) ~s1))
    (yore (year yud(s.t (add n s.t.yud))))
  ?:  &((gte yer (snag n lef:yu)) (lth yer (add (snag n lef:yu) ~s1)))
    yud(s.t (add +(n) s.t.yud))
  ?:  =(+(n) (lent lef:yu))
    (yore (year yud(s.t (add +(n) s.t.yud))))
  $(n +(n))
::
++  lead                                                ::  from leap sec time
  |=  ley=date
  =+  ler=(year ley)
  =+  n=0
  |-  ^-  @da
  =+  led=(sub ler (mul n ~s1))
  ?:  (gte ler (add (snag n les:yu) ~s1))
    led
  ?:  &((gte ler (snag n les:yu)) (lth ler (add (snag n les:yu) ~s1)))
    ?:  =(s.t.ley 60)
      (sub led ~s1)
    led
  ?:  =(+(n) (lent les:yu))
    (sub led ~s1)
  $(n +(n))
::
++  dust                                                ::  print UTC format
  |=  yed=date
  ^-  tape
  =+  wey=(daws yed)
  ;:  weld
      `tape`(snag wey (turn wik:yu |=(a=tape (scag 3 a))))
      ", "  ~(rud at d.t.yed)  " "
      `tape`(snag (dec m.yed) (turn mon:yu |=(a=tape (scag 3 a))))
      " "  (scag 1 ~(rud at y.yed))  (slag 2 ~(rud at y.yed))  " "
      ~(rud at h.t.yed)  ":"  ~(rud at m.t.yed)  ":"  ~(rud at s.t.yed)
      " "  "+0000"
  ==
::
++  stud                                                ::  parse UTC format
  |=  cud=tape
  ^-  (unit date)
  =-  ?~  tud  ~ 
      `[[%.y &3.u.tud] &2.u.tud &1.u.tud &4.u.tud &5.u.tud &6.u.tud ~]
  ^=  tud
  %+  rust  cud
  ;~  plug
    ;~(pfix (stun [5 5] next) dim:ag)
  ::
    %+  cook
      |=  a=tape
      =+  b=0
      |-  ^-  @
      ?:  =(a (snag b (turn mon:yu |=(a=tape (scag 3 a)))))
          +(b)
      $(b +(b))
    (ifix [ace ace] (star alf))
  ::
    ;~(sfix dim:ag ace)  
    ;~(sfix dim:ag col)
    ;~(sfix dim:ag col)  
    dim:ag  
    (cold ~ (star next))
  ==
::
++  unt                                                 ::  UGT to UTC time
  |=  a=@
  (div (sub a ~1970.1.1) (bex 64))
::
++  yu                                                  ::  UTC format constants
  |%
  ++  mon  ^-  (list tape)
    :~  "January"  "February"  "March"  "April"  "May"  "June"  "July"
        "August"  "September"  "October"  "November"  "December"
    ==
  ::
  ++  wik  ^-  (list tape)
    :~  "Sunday"  "Monday"  "Tuesday"  "Wednesday"  "Thursday"
        "Friday"  "Saturday"
    ==
  ::
  ++  les  ^-  (list ,@da)
    :~  ~2012.7.1  ~2009.1.1  ~2006.1.1  ~1999.1.1  ~1997.7.1  ~1996.1.1
        ~1994.7.1  ~1993.7.1  ~1992.7.1  ~1991.1.1  ~1990.1.1  ~1988.1.1
        ~1985.7.1  ~1983.7.1  ~1982.7.1  ~1981.7.1  ~1980.1.1  ~1979.1.1
        ~1978.1.1  ~1977.1.1  ~1976.1.1  ~1975.1.1  ~1974.1.1  ~1973.1.1
        ~1972.7.1
    ==
  ++  lef  ^-  (list ,@da)
    :~  ~2012.6.30..23.59.59   ~2008.12.31..23.59.58
        ~2005.12.31..23.59.57  ~1998.12.31..23.59.56
        ~1997.6.30..23.59.55   ~1995.12.31..23.59.54
        ~1994.6.30..23.59.53   ~1993.6.30..23.59.52
        ~1992.6.30..23.59.51   ~1990.12.31..23.59.50
        ~1989.12.31..23.59.49  ~1987.12.31..23.59.48
        ~1985.6.30..23.59.47   ~1983.6.30..23.59.46
        ~1982.6.30..23.59.45   ~1981.6.30..23.59.44
        ~1979.12.31..23.59.43  ~1978.12.31..23.59.42
        ~1977.12.31..23.59.41  ~1976.12.31..23.59.40
        ~1975.12.31..23.59.39  ~1974.12.31..23.59.38
        ~1973.12.31..23.59.37  ~1972.12.31..23.59.36
        ~1972.6.30..23.59.35
    ==
  --
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                section 3bD, JSON and XML             ::
::
++  moon                                                ::  mime type to text
  |=  myn=mite
  %+  rap
    3
  |-  ^-  tape
  ?~  myn  ~
  ?:  =(~ t.myn)  (trip i.myn)
  (weld (trip i.myn) `tape`['/' $(myn t.myn)])
::
++  poja                                                ::  parse JSON
  |%
  ++  apex                                              ::  JSON object
    ;~(pose abox obox)
  ++  valu                                              ::  JSON value
    %+  knee  *json  |.  ~+
    ;~  pfix  spac
      ;~  pose
        (cold ~ (jest 'null'))
        (jify %b bool)
        (jify %s stri)
        (cook |=(s=tape [%n p=(rap 3 s)]) numb)
        abox
        obox
      ==
    ==
  ::  JSON arrays
  ++  arra  (ifix [sel (ws ser)] (more (ws com) valu))
  ++  abox  (cook |=(elts=(list json) [%a p=elts]) arra)
  ::  JSON objects
  ++  pair  ;~((comp |=([k=@ta v=json] [k v])) ;~(sfix (ws stri) (ws col)) valu)
  ++  obje  (ifix [(ws kel) (ws ker)] (more (ws com) pair))
  ++  obox  (cook |=(s=(list ,[@ta json]) [%o p=(mo s)]) obje)
  ::  JSON booleans
  ++  bool  ;~(pose (cold & (jest 'true')) (cold | (jest 'false')))
  ::  JSON strings
  ++  stri
    (cook |=(s=(list ,@) (rap 3 s)) (ifix [doq doq] (star jcha)))
  ++  jcha                                               :: character in string
    ;~  pose
      esca
      ;~  pose
        :: Non-escape string characters
        (shim 32 33)
        (shim 35 91)
        (shim 93 126)
        (shim 128 255)
      ==
    ==
  ++  esca                                               :: Escaped character
    ;~  pfix  bas
      ;~  pose
        doq
        fas
        soq
        bas
        (cold 8 (just 'b'))
        (cold 9 (just 't'))
        (cold 10 (just 'n'))
        (cold 12 (just 'f'))
        (cold 13 (just 'r'))
        ;~(pfix (just 'u') (cook tuft qix:ab)) :: Convert 4-digit hex to UTF-8
      ==
    ==
  ::  JSON numbers
  ++  numb
    ;~  (comp twel)
      (mayb (piec hep))
      ;~  pose
        (piec (just '0'))
        ;~((comp twel) (piec (shim '1' '9')) digs)
      ==
      (mayb frac)
      (mayb expo)
    ==
  ++  digs  (star (shim '0' '9'))
  ++  expo                                               :: Exponent part
    ;~  (comp twel)
      (piec (mask "eE"))
      (mayb (piec (mask "+-")))
      digs
    ==
  ++  frac                                               :: Fractional part
    ;~  (comp twel)
      (piec dot)
      digs
    ==
  ::  whitespace
  ++  spac  (star (mask [`@`9 `@`10 `@`13 ' ' ~]))
  ++  ws  |*(sef=_rule ;~(pfix spac sef))
  ::  plumbing
  ++  jify  |*([t=@ta r=_rule] (cook |*([v=*] [t p=v]) r))
  ++  mayb  |*(bus=_rule ;~(pose bus (easy "")))
  ++  twel  |=([a=tape b=tape] (weld a b))
  ++  piec
    |*  bus=_rule
    (cook |=(a=@ [a ~]) bus)
  --
::
++  pojo                                                ::  print json
  |=  val=json
  ^-  tape
  ?~  val  "null"
  ?-    -.val
      %a
    ;:  weld
      "["
      =|  rez=tape
      |-  ^+  rez
      ?~  p.val  rez
      $(p.val t.p.val, rez :(weld rez ^$(val i.p.val) ?~(t.p.val ~ ",")))
      "]"
    ==
 ::
      %b  ?:(p.val "true" "false")
      %n  (trip p.val)
      %s
    ;:  welp
      "\""
      %+  reel
        (turn (trip p.val) jesc)
      |=([p=tape q=tape] (welp +<))
      "\""
    ==
      %o
    ;:  welp
      "\{"
      =+  viz=(~(tap by p.val) ~)
      =|  rez=tape
      |-  ^+  rez
      ?~  viz  rez
      %=    $
          viz  t.viz
          rez
        :(welp rez "\"" (trip p.i.viz) "\":" ^$(val q.i.viz) ?~(t.viz ~ ","))
      ==
      "}"
    ==
  ==
::
++  jo                                                  ::  json reparser
  =>  |%  ++  grub  (unit ,*) 
          ++  fist  $+(json grub)
      --
  |%
  ++  ar                                                ::  array as list
    |*  wit=fist
    |=  jon=json
    ?.  ?=([%a *] jon)  ~
    %-  zl
    |-  
    ?~  p.jon  ~
    [i=(wit i.p.jon) t=$(p.jon t.p.jon)]
  ::
  ++  at                                                ::  array as tuple
    |*  wil=(pole fist)
    |=  jon=json
    ?.  ?=([%a *] jon)  ~
    =+  raw=((at-raw wil) p.jon)
    ?.((za raw) ~ (some (zp raw)))
  ::
  ++  at-raw                                            ::  array as tuple
    |*  wil=(pole fist)
    |=  jol=(list json)
    ?~  wil  ~
    :-  ?~(jol ~ (-.wil i.jol))
    ((at-raw +.wil) ?~(jol ~ t.jol))
  ::
  ++  bo                                                ::  boolean
    |=(jon=json ?.(?=([%b *] jon) ~ [~ u=p.jon]))
  ::
  ++  bu                                                ::  boolean not
    |=(jon=json ?.(?=([%b *] jon) ~ [~ u=!p.jon]))
  ::
  ++  cu                                                ::  transform
    |*  [poq=$+(* *) wit=fist]
    |=  jon=json
    (bind (wit jon) poq)
  ::
  ++  da                                                ::  UTC date
    |=  jon=json
    ?.  ?=([%s *] jon)  ~
    (bind (stud (trip p.jon)) |=(a=date (year a)))
  ::
  ++  mu                                                ::  true unit
    |*  wit=fist
    |=  jon=json
    ?~(jon (some ~) (wit jon))
  ::
  ++  ne                                                ::  number as real
    |=  jon=json
    ^-  (unit ,@rd)
    !!
  ::
  ++  ni                                                ::  number as integer
    |=  jon=json 
    ?.  ?=([%n *] jon)  ~
    (slaw %ui (cat 3 '0i' p.jon))
  ::
  ++  no                                                ::  number as cord
    |=  jon=json
    ?.  ?=([%n *] jon)  ~
    (some p.jon)
  ::
  ++  of                                                ::  object as frond
    |*  wer=(pole ,[cord fist])
    |=  jon=json
    ?.  ?=([%o [@ *] ~ ~] jon)  ~
    |-
    ?~  wer  ~
    ?:  =(-.-.wer p.n.p.jon)  
      ((pe -.-.wer +.-.wer) q.n.p.jon)
    ((of +.wer) jon)
  ::
  ++  ot                                                ::  object as tuple
    |*  wer=(pole ,[cord fist])
    |=  jon=json
    ?.  ?=([%o *] jon)  ~
    =+  raw=((ot-raw wer) p.jon)
    ?.((za raw) ~ (some (zp raw)))
  ::
  ++  ot-raw                                            ::  object as tuple
    |*  wer=(pole ,[cord fist])
    |=  jom=(map ,@t json)
    ?~  wer  ~
    =+  ten=(~(get by jom) -.-.wer)
    [?~(ten ~ (+.-.wer u.ten)) ((ot-raw +.wer) jom)]
  ::
  ++  om                                                ::  object as map
    |*  wit=fist
    |=  jon=json
    ?.  ?=([%o *] jon)  ~
    %-  zm
    |-  
    ?~  p.jon  ~
    [n=[p=p.n.p.jon q=(wit q.n.p.jon)] l=$(p.jon l.p.jon) r=$(p.jon r.p.jon)]
  ::
  ++  pe                                                ::  prefix
    |*  [pre=* wit=fist]
    (cu |*(a=* [pre a]) wit)
  ::
  ++  sa                                                ::  string as tape
    |=  jon=json
    ?.(?=([%s *] jon) ~ (some (trip p.jon)))
  ::
  ++  so                                                ::  string as cord
    |=  jon=json
    ?.(?=([%s *] jon) ~ (some p.jon))
  ::
  ++  su                                                ::  parse string
    |*  sab=rule
    |=  jon=json
    ?.  ?=([%s *] jon)  ~
    (rush p.jon sab)
  ::
  ++  ul  |=(jon=json ?~(jon (some ~) ~))               ::  null
  ++  za                                                ::  full unit pole
    |*  pod=(pole (unit))
    ?~  pod  &
    ?~  -.pod  |
    (za +.pod)
  ::
  ++  zl                                                ::  collapse unit list
    |*  lut=(list (unit))
    ?.  |-  ^-  ?
        ?~(lut & ?~(i.lut | $(lut t.lut)))
      ~
    %-  some
    |-
    ?~  lut  ~
    [i=u:+.i.lut t=$(lut t.lut)]
  ::
  ++  zp                                                ::  unit tuple
    |*  but=(pole (unit))
    ?~  but  !!
    ?~  +.but  
      u:->.but
    [u:->.but (zp +.but)]
  ::
  ++  zt                                                ::  unit tuple
    |*  lut=(list (unit))
    ?:  =(~ lut)  ~
    ?.  |-  ^-  ?
        ?~(lut & ?~(i.lut | $(lut t.lut)))
      ~
    %-  some
    |-
    ?~  lut  !!
    ?~  t.lut  u:+.i.lut
    [u:+.i.lut $(lut t.lut)]
  ::
  ++  zm                                                ::  collapse unit map
    |*  lum=(map term (unit))
    ?.  |-  ^-  ?
        ?~(lum & ?~(q.n.lum | &($(lum l.lum) $(lum r.lum))))
      ~
    %-  some
    |-
    ?~  lum  ~
    [[p.n.lum u:+.q.n.lum] $(lum l.lum) $(lum r.lum)]
  --
::
++  joba
  |=  [p=@t q=json]
  ^-  json
  [%o [[p q] ~ ~]]
::
++  jobe
  |=  a=(list ,[p=@t q=json])
  ^-  json
  [%o (~(gas by *(map ,@t json)) a)]
::
++  jape
  |=  a=tape
  ^-  json
  [%s (crip a)]
::
++  jone
  |=  a=@
  ^-  json
  :-  %n
  ?:  =(0 a)  '0'
  (crip (flop |-(^-(tape ?:(=(0 a) ~ [(add '0' (mod a 10)) $(a (div a 10))])))))
::
++  jesc
  |=  a=@  ^-  tape
  ?.(=(10 a) [a ~] "\\n")
::
++  taco                                                ::  atom to octstream
  |=  tam=@  ^-  octs
  [(met 3 tam) tam]
::
++  tact                                                ::  tape to octstream
  |=  tep=tape  ^-  octs
  (taco (rap 3 tep))
::
++  tell                                                ::  wall to octstream
  |=  wol=wall  ^-  octs
  =+  buf=(rap 3 (turn wol |=(a=tape (crip (weld a `tape`[`@`10 ~])))))
  [(met 3 buf) buf]
::
++  txml                                                ::  string to xml
  |=  tep=tape  ^-  manx
  [[%$ [%$ tep] ~] ~]
::
++  xmla                                                ::  attributes to tape
  |=  [tat=mart rez=tape]
  ^-  tape
  ?~  tat  rez
  =+  ryq=$(tat t.tat)
  :(weld (xmln n.i.tat) "=\"" (xmle | v.i.tat '"' ?~(t.tat ryq [' ' ryq])))
::
++  xmle                                                ::  escape for xml
  |=  [unq=? tex=tape rez=tape]
  ?:  unq
    (weld tex rez)
  =+  xet=`tape`(flop tex)
  |-  ^-  tape
  ?~  xet  rez
  %=    $
    xet  t.xet
    rez  ?-  i.xet
           34  ['&' 'q' 'u' 'o' 't' ';' rez]
           38  ['&' 'a' 'm' 'p' ';' rez]
           39  ['&' '#' '3' '9' ';' rez]
           60  ['&' 'l' 't' ';' rez]
           62  ['&' 'g' 't' ';' rez]
           *   [i.xet rez]
         ==
  ==
::
++  xmln                                                ::  name to tape
  |=  man=mane  ^-  tape
  ?@  man  (trip man)
  (weld (trip -.man) `tape`[':' (trip +.man)])
::
++  xmll                                                ::  nodelist to tape
  |=  [unq=? lix=(list manx) rez=tape]
  |-  ^-  tape
  ?~  lix  rez
  (xmlt unq i.lix $(lix t.lix))
::
++  xmlt                                                ::  node to tape
  |=  [unq=? mex=manx rez=tape]
  ^-  tape
  ?:  ?=([%$ [[%$ *] ~]] g.mex)
    (xmle unq v.i.a.g.mex rez)
  =+  man=`mane`-.g.mex
  =.  unq  |(unq =(%script man) =(%style man))
  =+  tam=(xmln man)
  =+  end=:(weld "</" tam ">" rez)
  =+  bod=['>' (xmll unq c.mex :(weld "</" tam ">" rez))]
  =+  att=`mart`a.g.mex
  :-  '<'
  %+  weld  tam
  `_tam`?~(att bod [' ' (xmla att bod)])
::
++  xmlp                                                ::  xml parser
  |%
  ++  apex
    =+  spa=;~(pose comt whit)
    %+  knee  *manx  |.  ~+
    %+  ifix  [(star spa) (star spa)]
    ;~  pose
      %+  sear  |=([a=marx b=marl c=mane] ?.(=(c n.a) ~ (some [a b])))
        ;~(plug head (more (star comt) ;~(pose apex chrd)) tail)
      empt
    == 
  :: 
  ++  attr                                              ::  attribute
    %+  knee  *mart  |.  ~+ 
    %-  star
    ;~  pfix  (plus whit)
      ;~  plug  name  
        ;~  pfix  tis
          ;~  pose 
              (ifix [doq doq] (star ;~(less doq escp)))
              (ifix [soq soq] (star ;~(less soq escp)))
          ==  
        ==
      ==  
    ==
  ::
  ++  chrd                                              ::  character data
    %+  knee  *manx  |.  ~+
    %+  cook  |=(a=tape :/(a))
    (plus ;~(less soq doq ;~(pose (just `@`10) escp)))
  ::
  ++  comt  %+  ifix  [(jest '<!--') (jest '-->')]      ::  comments 
            (star ;~(less (jest '-->') ;~(pose whit prn)))
  ::
  ++  escp
    ;~  pose
      ;~(less gal gar pam prn)
      (cold '>' (jest '&gt;'))
      (cold '<' (jest '&lt;'))
      (cold '&' (jest '&amp;'))
      (cold '"' (jest '&quot;'))
      (cold '\'' (jest '&apos;'))
    ==
  ++  empt                                              ::  self-closing tag
    %+  ifix  [gal ;~(plug (stun [0 1] ace) (jest '/>'))] 
    ;~(plug ;~(plug name attr) (cold ~ (star whit)))  
  ::
  ++  head                                              ::  opening tag
    %+  knee  *marx  |.  ~+
    (ifix [gal gar] ;~(plug name attr))
  ::
  ++  name                                              ::  tag name 
    %+  knee  *mane  |.  ~+
    =+  ^=  chx
        %+  cook  crip 
        ;~  plug 
            ;~(pose cab alf) 
            (star ;~(pose cab dot alp))
        ==
    ;~(pose ;~(plug ;~(sfix chx col) chx) chx)
  ::
  ++  tail  (ifix [(jest '</') gar] name)               ::  closing tag
  ++  whit  (mask ~[`@`0x20 `@`0x9 `@`0xa])             ::  whitespace
  --
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                section 3bE, tree sync                ::
::
::
++  cure                                                ::  invert miso
  |=  mis=miso
  ?-  -.mis
    %del  [%ins p.mis]
    %ins  [%del p.mis]
    %mut  [%mut (limp p.mis)]
  ==
::
++  cosh                                                ::  locally rehash
  |=  ank=ankh
  ank(p dash:(zu ank))
::
++  cost                                                ::  new external patch
  |=  [bus=ankh ank=ankh]
  ^-  soba
  :-  [p.ank p.bus] 
  %-  flop
  myz:(dist:(zu ank) %c bus)
::
++  loth
  |=  [p=(map path ,*) s=(set path)]
  ^-  (set path)
  %+  roll  (~(tap by p) ~)
  |=  [[p=path *] q=_s]
  %.  p  %~  put  in  q
::
++  luth
  |=  [p=(map path ,*) q=(map path ,*)]                 ::  merge keysets
  ^-  (set path)
  %+  loth  p 
  %+  loth  q
  _(set path)
::
++  zaax                                              ::  p.blob
  |=  p=blob
  ^-  lobe
  ?-   -.p
     %delta  p.p
     %direct  p.p
     %indirect  p.p
  ==
::
++  qeel                                              ::  trim ankh
  |=  p=ankh
  ^-  ankz
  :-  0
  ^-  (map ,@ta ankz)
  %-  ~(tur by r.p)
  |=  [pat=@ta ank=ankh]
  ^-  ankz
  ^$(p ank)
::
++  ze  !:
  |_  [lim=@da dome rang]
  ++  zoal                                              ::  make yaki
    |=  [p=(list tako) q=(map path lobe) t=@da]
    ^-  yaki
    =+  ^=  has
        %^  cat  7  (sham [%yaki (roll p add) q t])
        (sham [%tako (roll p add) q t])
    [p q has t]
  ::
  ++  zaal                                              ::  grab blob
    |=  p=lobe                                          ::  (raw)
    ^-  blob
    (~(got by lat) p)
  ::
  ++  zaul                                              ::  grab blob
    |=  p=lobe                                          ::  ^-  *
    %-  zaru  
    (zaal p)
  ::
  ++  zaru                                              ::  grab blob
    |=  p=blob
    ?-   -.p
       %delta  (lump r.p (zaul q.p))
       %direct  q.p
       %indirect  q.p
    ==
  ::
  ++  zeol                                              ::  make blob delta
    |=  [p=lobe q=udon]
    ^-  blob
    =+  t=[%delta 0 p q]
    =+  z=(zaru t)
    =+  ^=  has
        %^  cat  7  (sham [%blob z])
        (sham [%lobe z])
    [%delta has p q]
  ::
  ++  zeul                                              ::  make blob
    |=  [p=* q=umph]
    ^-  blob
    [%direct (mug p) p q]
  ::
  ++  zamp                                              ::  grab yaki
    |=  p=tako
    ^-  yaki
    (need (~(get by hut) p))
  ::
  ++  zump                                              ::  blob umph [prep]
    |=  p=blob                                          ::  used in merge
    ^-  umph
    ?-   -.p
       %delta  p.r.p
       %direct  r.p
       %indirect  p.r.p
    ==
  ::
  ::
  ::
  ::
  ++  zerg                                                ::  fundamental diff op
    |=  [p=yaki q=yaki]
    ^-  (map path miso)
    %+  roll  (~(tap in (luth q.p q.q)) ~)
    |=  [pat=path yeb=(map path miso)]
    =+  leb=(~(get by q.p) pat)
    =+  lob=(~(get by q.q) pat)
    ?~  leb  (~(put by yeb) pat [%ins (zaul (need lob))])
    ?~  lob  (~(put by yeb) pat [%del (zaul (need leb))])
    ?:  =(u.leb u.lob)  yeb
    =+  veq=(zaal u.leb)
    =+  voq=(zaal u.lob)
    %+  ~(put by yeb)  pat
    :-  %mut  
    ?:  &(?=(%delta -.voq) =(u.leb q.voq))                ::  avoid diff
      r.voq
    =+  zeq=(zaru veq)
    =+  zoq=(zaru voq)
    ((diff (zump (zaal u.leb))) zeq zoq)
  ::
  ::
  ++  aeon                                              ::    aeon:ze
    |=  lok=case                                        ::  act count through
    ^-  (unit ,@ud)
    ?-    -.lok
        %da
      ?:  (gth p.lok lim)  ~
      |-  ^-  (unit ,@ud)
      ?:  =(0 let)  [~ 0]                               ::  avoid underflow
      ?:  %+  gte  p.lok 
          =<  t
          %-  ~(got by hut)
          %-  ~(got by hit)
          let
        [~ let]
      $(let (dec let))
    ::
        %tas  (~(get by lab) p.lok)
        %ud   ?:((gth p.lok let) ~ [~ p.lok])
    ==
  ::
  ++  ache                                              ::    ache:ze
    ^-  arch                                            ::  arch report
    :+  p.ank
      ?~(q.ank ~ [~ p.u.q.ank])
    |-  ^-  (map ,@ta ,~)
    ?~  r.ank  ~
    [[p.n.r.ank ~] $(r.ank l.r.ank) $(r.ank r.r.ank)]
  ::
  ++  zule                                            ::  reachable
    |=  p=tako
    ^-  (set tako)
    =+  y=(~(got by hut) p)
    =+  t=(~(put in _(set tako)) p)
    %+  roll  p.y
    |=  [q=tako s=_t]
    ?:  (~(has in s) q)                               ::  already done
      s                                               ::  hence skip
    (~(uni in s) ^$(p q))                             ::  otherwise traverse
  ::
  ++  garg                                            ::  object hash set
    |=  [b=(set lobe) a=(set tako)]                   ::  that aren't in b
    ^-  (set lobe)
    %+  roll  (~(tap in a) ~)
    |=  [tak=tako bar=(set lobe)]
    ^-  (set lobe)
    =+  yak=(need (~(get by hut) tak))
    %+  roll  (~(tap by q.yak) ~)
    |=  [[path lob=lobe] far=_bar]
    ^-  (set lobe)
    ?~  (~(has in b) lob)                             ::  don't need
      far
    =+  gar=(need (~(get by lat) lob))
    ?-  -.gar
      %direct  (~(put in far) lob)
      %delta  (~(put in $(lob q.gar)) lob)
      %indirect  (~(put in $(lob s.gar)) lob)
    ==
  ++  garf                                            ::  garg & repack
    |=  [b=(set lobe) a=(set tako)]
    ^-  [(set tako) (set lobe)]
    [a (garg b a)]
  ::
  ++  pack
    |=  [a=(unit tako) b=tako]                        ::  pack a through b
    ^-  [(set tako) (set lobe)]
    =+  ^=  sar 
        ?~  a  ~
        (zule r:(need (~(get by hut) u.a)))
    =+  yak=`yaki`(need (~(get by hut) b))
    %+  garf  (garg ~ sar)                            ::  get lobes
    |-  ^-  (set tako)                                ::  walk onto sar
    ?:  (~(has in sar) r.yak)
      ~
    =+  ber=`(set tako)`(~(put in `(set tako)`~) `tako`r.yak)
    %-  ~(uni in ber)
    ^-  (set tako)
    %+  roll  p.yak
    |=  [yek=tako bar=(set tako)]
    ^-  (set tako)
    ?:  (~(has in bar) yek)                           ::  save some time
      bar
    %-  ~(uni in bar)
    ^$(yak (need (~(get by hut) yek)))
  ::
  ++  hack                                            ::  trivial
    |=  [a=(set tako) b=(set lobe)]
    ^-  [(set yaki) (set blob)]
    :-  %-  sa  %+  turn  (~(tap by a) ~)
        |=  tak=tako
        (need (~(get by hut) tak))
    %-  sa  %+  turn  (~(tap by b) ~)
    |=  lob=lobe
    (need (~(get by lat) lob))
  ::
  ++  gack  !:                                        ::  gack a through b
    |=  [a=@ud b=@ud]
    ^-  [(map ,@ud tako) @ud (set yaki) (set blob)]
    :_  :-  b
        %-  hack  
        %+  pack  
          (~(get by hit) a)                           ::  if a not found, a=0
        %-  need  (~(get by hit) b)
    ^-  (map ,@ud tako)
    %-  mo  %+  skim  (~(tap by hit) ~)
    |=  [p=@ud *]
    &((gth p a) (lte p b))
  ::
  ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  ++  amor                                              ::    amor:ze
    |=  ren=?(%u %v %x %y %z)                           ::  endpoint query
    ^-  (unit ,*)
    ?-  ren
      %u  [~ `rang`+<+>.amor]
      %v  [~ `dome`+<+<.amor]
      %x  ?~(q.ank ~ [~ q.u.q.ank])
      %y  [~ ache]
      %z  [~ ank]
    ==
  ::
  ++  argo                                              ::    argo:ze
    |=  oan=@ud                                         ::  rewind to aeon
    ^+  +>
    ?:  =(let oan)  +>
    ?:  (gth oan let)  !!                               ::  don't have this version
    +>(ank (azel q:(need (~(get by hut) (need (~(get by hit) oan))))), let oan)
  ::
  ::::
  ++  aqel                                              ::   aqel:ze
  |=  [lag=(map path blob) sta=(map lobe blob)]         ::  fix lat
  ^-  [(map lobe blob) (map path lobe)]
  %+  roll  (~(tap by lag) ~)
  |=  [[pat=path bar=blob] [lut=_sta gar=(map path lobe)]]
  ?~  (~(has by lut) p.bar)
    [lut (~(put by gar) pat p.bar)]
  :-  (~(put by lut) p.bar bar)
  (~(put by gar) pat p.bar)
  ::
  ++  azal                                              ::   azal:ze
    |=  lar=(list ,[p=path q=miso])                     ::  store changes
    ^-  (map path blob)
    =+  ^=  hat                                         ::  current state
        ?:  =(let 0)                                    ::  initial commit
          ~                                             ::  has nothing
        =<  q
        %-  need  %-  ~(get by hut)
        %-  need  %-  ~(get by hit)
        let
    %-  |=  bar=(map path blob)                         ::  find unchanged
        =+  sar=(sa (turn lar |=([p=path *] p)))        ::  changed paths
        %+  roll  (~(tap by hat) ~)
        |=  [[pat=path gar=lobe] bat=_bar]
        ?:  (~(has in sar) pat)                         ::  has update
          bat
        (~(put by bat) pat (need (~(get by lat) gar)))  ::  use original
    %+  roll  lar
    |=  [[pat=path mys=miso] bar=(map path blob)]
    ^+  bar
    ?-    -.mys
        %ins                                            ::  insert if not exist
      ?:  (~(has by bar) pat)  !!                       ::
      ?:  (~(has by hat) pat)  !!                       ::
      (~(put by bar) pat (zeul p.mys %c))               ::  TODO content type?
        %del                                            ::  delete if exists
      ?.  |((~(has by hat) pat) (~(has by bar) pat))  !!
      (~(del by bar) pat)
        %mut                                            ::  mutate, must exist
      =+  ber=(~(get by bar) pat)
      ?~  ber
        =+  har=(~(get by hat) pat)
        ?~  har  !!
        %+  ~(put by bar)  pat
        (zeol u.har p.mys)
      %+  ~(put by bar)  pat
      (zeol p.u.ber p.mys)
    ==
  ++  azel                                              ::    azel:ze
    |=  hat=(map path lobe)                             ::  checkout commit
    ^-  ankh
    =<  ank  =<  dosh  %-  zu
    %+  roll  (~(tap by hat) ~)
    |=  [[pat=path bar=lobe] ank=ankh]
    ^-  ankh
    ?~  pat  [_cash [~ [_cash (zaul bar)]] `(map ,@ta ankh)`~]
    =+  nak=(~(get by r.ank) i.pat)
    %=  ank
      r  %+  ~(put by r.ank)  i.pat 
         $(pat t.pat, ank (fall nak _ankh))
    ==
  ::
  ++  azol                                              ::    azol:ze
    |=  [wen=@da par=(unit tako) lem=soba]              ::  forge yaki
    =+  ^=  per
        ?~  par  ~
        ~[u.par]
    =+  gar=(aqel (azal q.lem) lat)
    :-  %^  zoal  per  +.gar  wen                       ::  from existing diff
    -.gar                                               ::  fix lat
  ::
  ++  azul                                              ::    azul:ze
    |=  yak=yaki                                        ::  forge nori (ugly op)
    ^-  nori                                            ::  basically zerg w/ nori
    ?~  p.yak  !!                                       ::  no parent -> can't diff
    [%& [*cart (~(tap by (zerg (zamp i.p.yak) yak)) ~)]]::  diff w/ 1st parent
  ::
  ::  MERGE
  ::
  ++  zear                                            ::  reduce merge points
    |=  unk=(set yaki)                                ::  maybe need jet
    =|  gud=(set yaki)
    =+  ^=  zar
        ^-  (map tako (set tako))
        %+  roll  (~(tap in unk) ~)
        |=  [yak=yaki qar=(map tako (set tako))]
        (~(put by qar) r.yak (zule r.yak))
    |-  
    ^-  (set yaki)
    ?~  unk  gud
    =+  tek=`yaki`n.unk
    =+  bun=(~(del in `(set yaki)`unk) tek)
    ?:  %+  roll  (~(tap by (~(uni in gud) bun)) ~)   ::  only good + unknown
        |=  [tak=yaki god=?]
        ^-  ?
        ?.  god  god
        (~(has in (~(got by zar) r.tak)) tek)
      $(gud (~(put in gud) tek), unk bun)
    $(unk bun)
  ::
  ++  zeal                                            ::  merge points
    |=  [p=yaki q=yaki]                               ::  maybe need jet
    ^-  (set yaki)
    %-  zear
    =+  r=(zule r.p)
    |-  ^-  (set yaki)
    ?:  (~(has in r) q)  (~(put in _(set yaki)) q)    ::  done 
    %+  roll  p.q
    |=  [t=tako s=(set yaki)]
    ?:  (~(has in r) t)
      (~(put in s) (~(got by hut) t))                 ::  found
    (~(uni in s) ^$(q (~(got by hut) t)))             ::  traverse
  ::
  ::  merge logic
  ::
  ++  qael                                          ::  clean
    |=  wig=(urge)
    ^-  (urge)
    ?~  wig  ~
    ?~  t.wig  wig
    ?:  ?=(%& -.i.wig)
      ?:  ?=(%& -.i.t.wig)
        $(wig [[%& (add p.i.wig p.i.t.wig)] t.t.wig])
      [i.wig $(wig t.wig)]
    ?:  ?=(%| -.i.t.wig)
      $(wig [[%| (welp p.i.wig p.i.t.wig) (welp q.i.wig q.i.t.wig)] t.t.wig])
    [i.wig $(wig t.wig)]
  ::
  ++  qaul                                          ::  check no delete
    |=  wig=(urge)
    ^-  ?
    ?~  wig  %.y
    ?-    -.i.wig
      %&  %.n
      %|  ?:  =(p.i.wig 0) 
            $(wig t.wig)
          %.n
    ==
  ++  quax                                          ::  match conflict
    |=  [us=[ship desk] th=[ship desk] p=(urge) q=(urge) r=(list)]
    ^-  [p=[p=(list) q=(list)] q=[p=(urge) q=(urge) r=(list)]]
    =+  cas=(hard (list ,@t))
    =+  cat=(hard (urge ,@t))
    =+  mar=(qear (cat p) (cat q) (cas r))
    :-  :-  s.q.mar 
        (quis us th p.p.mar q.p.mar s.q.mar)        ::  annotation
    :-  p.q.mar
    :-  q.q.mar
    r.q.mar
  ++  quis                                          ::  annotate conflict
    |=  [us=[ship desk] th=[ship desk] p=(list ,@t) q=(list ,@t) r=(list ,@t)]
    ^-  (list ,@t)
    %-  zing
    ^-  (list (list ,@t))
    %-  flop
    ^-  (list (list ,@t))
    :-  :_  ~
        %^  cat  3  '<<<<<<<<<<<<' 
        %^  cat  3  ' '
        %^  cat  3  `@t`(scot %p -.us)
        %^  cat  3  '/'
        +.us
    :-  q
    :-  ~['------------']
    :-  r
    :-  ~['++++++++++++']
    :-  p
    :-  :_  ~
        %^  cat  3  '>>>>>>>>>>>>' 
        %^  cat  3  ' '
        %^  cat  3  `@t`(scot %p -.th)
        %^  cat  3  '/'
        +.th
    ~
  ::
  ++  qear                                          ::  match merge
    |=  [p=(urge ,@t) q=(urge ,@t) r=(list ,@t)]    ::  resolve conflict
    =|  s=[p=(list ,@t) q=(list ,@t)]               ::  p chunk
    =|  t=[p=(list ,@t) q=(list ,@t)]               ::  q chunk
    |-  ^-  [p=[p=(list ,@t) q=(list ,@t)] q=[p=(urge ,@t) q=(urge ,@t) r=(list ,@t) s=(list ,@t)]]
    ?~  p  [[q.s q.t] p q r p.s]                    ::  can't be conflict
    ?~  q  [[q.s q.t] p q r p.s]                    ::  can't be conflict
    ?-  -.i.p
      %&  ?>  ?=(%| -.i.q)                          ::  is possibly conflict
          ?:  (gte p.i.p (lent p.i.q))              ::  trivial resolve
            :::-  (weld p.s p.i.q)                    ::  extend to q
            :-  :-  (welp (flop (scag (lent p.i.q) r)) q.s)
                (welp q.i.q q.t)
            :-  ?:  =(p.i.p (lent p.i.q))  t.p
                [[%& (sub p.i.p (lent p.i.q))] t.p]
            :-  t.q
            :-  (flop (slag (lent p.i.q) r))
            (welp (flop (scag (lent p.i.q) r)) p.s)
          =+  tex=(flop (scag p.i.p r))
          ?~  t.p                                   ::  extend to end
            %=  $
              ::s  [(welp p.s tex) (welp q.s tex)]
              p  ~[[%| [tex tex]]]
              ::r  (slag p.i.p r)
            ==
          ?>  ?=(%| -.i.t.p)                        ::  fake skip
          %=  $
            ::s  [(welp p.s tex) (welp q.s tex)]
            p  [[%| [(welp p.i.t.p tex) (welp q.i.t.p tex)]] t.t.p]
            ::r  (slag p.i.p r)
          ==
      %|  ?-  -.i.q
             %&  =+  mar=$(p q, q p, s t, t s)      ::  swap recursion
                 [[q.p.mar p.p.mar] q.q.mar p.q.mar r.q.mar s.q.mar]
             %|  ?:  =((lent p.i.p) (lent p.i.q))   ::  perfect conflict
                   ?>  =(p.i.p p.i.q)               ::  sane conflict
                   :-  :-  (welp q.i.p q.s)
                       (welp q.i.q q.t)
                   :-  t.p 
                   :-  t.q 
                   :-  (scag (lent p.i.p) r)
                   (welp (flop (scag (lent p.i.p) r)) p.s)
                 ?.  (lth (lent p.i.p) (lent p.i.q))
                   =+  mar=$(p q, q p, s t, t s)    ::  swap recursion
                   [[q.p.mar p.p.mar] q.q.mar p.q.mar r.q.mar s.q.mar]
                 ?>  =((slag (sub (lent p.i.q) (lent p.i.p)) p.i.q) p.i.p)  ::  sane conflict
                 %=  $                              ::  extend p
                   p  t.p
                   p.s  (welp p.i.p p.s)
                   q.s  (welp q.i.p q.s)
                   p.t  (welp p.i.p p.s)            ::  subset of q
                   q.t  (welp q.i.q q.s)            ::  just consume all out
                   q  [[%| (scag (sub (lent p.i.q) (lent p.i.p)) p.i.q) ~] t.q]
                   r  (slag (lent p.i.p) r)
                 ==
             ==
      ==
  ++  qeal                                          ::  merge p,q
    |*  [us=[ship desk] th=[ship desk] pat=path p=miso q=miso r=(list) con=?]
    ^-  miso                                        ::  in case of conflict
    ~|  %qeal-fail
    ?>  ?=(%mut -.p)
    ?>  ?=(%mut -.q)
    ?>  ?=(%c -.q.p.p)
    ?>  ?=(%c -.q.p.q)
    =+  s=(qael p.q.p.p)
    =+  t=(qael p.q.p.q)
    :-  %mut
    :-  %c  ::  todo is this p.p.p?
    :-  %c
    |-  ^-  (urge)
    ::?~  s  ?:  (qual t)  t
    ::       ~|  %qail-conflict  !!
    ::?~  t  ?:  (qual s)  s
    ::       ~|  %qail-conflict  !!
    ?~  s  t
    ?~  t  s
    ?-    -.i.s
        %&
      ?-    -.i.t
          %&
        ?:  =(p.i.s p.i.t)
          [i.s $(s t.s, t t.t, r (slag p.i.s r))]
        ?:  (gth p.i.s p.i.t)
          [i.t $(t t.t, p.i.s (sub p.i.s p.i.t), r (slag p.i.t r))]
        [i.s $(s t.s, p.i.t (sub p.i.t p.i.s), r (slag p.i.s r))]
          %|
        ?:  =(p.i.s (lent p.i.t))
          [i.t $(s t.s, t t.t, r (slag p.i.s r))]
        ?:  (gth p.i.s (lent p.i.t))
          :-  i.t 
          $(t t.t, p.i.s (sub p.i.s (lent p.i.t)), r (slag (lent p.i.t) r))
        ?.  con  ~|  %quil-conflict  !!           ::  conflict
        ~&  [%quil-conflict-soft pat]
        =+  mar=(quax us th s t r)
        [[%| p.mar] $(s p.q.mar, t q.q.mar, r r.q.mar)]
      ==
        %|
      ?-    -.i.t
          %|
        ?.  con  ~|  %quil-conflict  !!
        ~&  [%quil-conflict-soft pat]
        =+  mar=(quax us th s t r)
        [[%| p.mar] $(s p.q.mar, t q.q.mar, r r.q.mar)]
          %&
        ?:  =(p.i.t (lent p.i.s))
          [i.s $(s t.s, t t.t, r (slag p.i.t r))]
        ?:  (gth p.i.t (lent p.i.s))
          [i.s $(s t.s, p.i.t (sub p.i.t (lent p.i.s)), r (slag (lent p.i.s) r))]
        ?.  con  ~|  %quil-conflict  !!
        ~&  [%quil-conflict-soft pat]
        =+  mar=(quax us th s t r)
        [[%| p.mar] $(s p.q.mar, t q.q.mar, r r.q.mar)]
      ==
    ==
  ++  quil                                          ::  merge p,q
    |=  [us=[ship desk] th=[ship desk] pat=path p=(unit miso) q=(unit miso) r=(unit (list)) con=?]
    ^-  (unit miso)
    ?~  p  q                                        ::  trivial
    ?~  q  p                                        ::  trivial
    ?.  ?=(%mut -.u.p)
      ~|  %quil-conflict  !!
    ?.  ?=(%mut -.u.q)
      ~|  %quil-conflict  !!
    %-  some
    %^  qeal  us  th
    :^  pat  u.p  u.q                               ::  merge p,q
    :-  %-  need  r
    con
  ::
  ++  meld                                          ::  merge p,q from r
    |=  [p=yaki q=yaki r=yaki con=? us=[ship desk] th=[ship desk]]
    ^-  (map path blob)
    =+  s=(zerg r p)
    =+  t=(zerg r q)
    =+  lut=(luth s t)
    %-  |=  res=(map path blob)                        ::  add old
        ^-  (map path blob)
        %-  ~(uni by res)
        %-  mo
        %+  turn  
          %+  skip  (~(tap by q.r) ~)                  ::  loop through old
          |=  [pat=path bar=lobe]  ^-  ?
          (~(has in lut) pat)                          ::  skip updated
        |=  [pat=path bar=lobe]  ^-  [path blob]
        [pat (zaal bar)]                               ::  lookup objects
    %+  roll  (~(tap in (luth s t)) ~)
    |=  [pat=path res=(map path blob)]
    =+  ^=  v
        %-  need
        %^  quil  us  th
        :-  pat
        :+  (~(get by s) pat)
          (~(get by t) pat)
        :_  con
        %-  %-  lift  lore
        %-  %-  lift  %-  hard  ,@                     ::  for %c
        %-  %-  lift  zaul
        %-  ~(get by q.r)
        pat
    ?-    -.v
        %del  res                                      ::  no longer exists
        %ins                                           ::  new file
      %+  ~(put by res)  pat 
      %+  zeul  p.v  %c                                ::  TODO content type?
        %mut                                           ::  patch from r
      %+  ~(put by res)  pat
      %-  zeul
      :_  %c
      %+  lump  p.v
      %-  zaul
      %-  ~(got by q.r)  pat
    ==
  ::
  ::  merge types
  ::
  ++  mate                                          ::  merge p,q
    |=  con=?                                       ::  %mate, %meld
    |=  [p=yaki q=yaki us=[ship desk] th=[ship desk]]
    ^-  (map path blob)
    =+  r=(~(tap in (zeal p q)) ~)
    ?~  r
      ~|(%mate-no-ancestor !!)
    ?:  =(1 (lent r))
      (meld p q i.r con us th)
    ~|(%mate-criss-cross !!)
  ::
  ++  keep                                          ::  %this
    |=  [p=yaki q=yaki [ship desk] [ship desk]]
    ^-  (map path blob)
    %+  roll  (~(tap by q.p) ~)
    |=  [[pat=path lob=lobe] zar=(map path blob)]
    ^-  (map path blob)
    (~(put by zar) pat (zaal lob))
  ::
  ++  drop                                          ::  %that
    |=  [p=yaki q=yaki r=[ship desk] s=[ship desk]]
    ^-  (map path blob)
    (keep q p r s)
  ::
  ++  forge                                         ::  %forge
    |=  [p=yaki q=yaki s=[ship desk] t=[ship desk]]
    ^-  (map path blob)
    =+  r=(~(tap in (zeal p q)) ~)
    ?~  r
      ~|(%forge-no-ancestor !!)
    %-  |=  [r=yaki lut=(map lobe blob) hat=(map tako yaki)]
        =.  lat  lut
        =.  hut  hat
        (meld p q r & s t)                        ::  fake merge
    %+  roll  t.r                                   ::  fake ancestor
    |=  [par=yaki [for=_i.r lut=_lat hat=_hut]]
    =.  lat  lut
    =+  ^=  far
        ^-  (map path lobe)
        %-  ~(tur by (forge par for s t))
        |=  [k=path v=blob]  (zaax v)
    =+  u=(zoal [r.par r.for ~] far `@da`0)           ::  fake yaki
    :-  u
    :_  (~(put by hat) r.u u)
    =<  -
    %-  aqel
    :_  ~
    %-  ~(tur by q.u)
    |=  [path k=lobe]
    (zaal k)
  ::
  ::  actual merge
  ::
  ++  merge
    |=  [us=[ship desk] th=[ship desk]]
    |=  [p=yaki q=yaki r=@da s=$+([yaki yaki [ship desk] [ship desk]] (map path blob))]
    ^-  [yaki (map path blob)]
    =+  u=(s p q us th)
    =+  ^=  t
        ^-  (map path lobe)
        %+  roll  (~(tap by u) ~)
        |=  [[pat=path bar=blob] yeb=(map path lobe)]
        (~(put by yeb) pat (zaax bar))
    :_  u
    (zoal [r.p r.q ~] t r)
  ::
  ++  strat                                             ::  merge strat
    |=  gem=?(%meld %mate %that %this)
    ?-  gem
      %meld  (mate %.y)
      %mate  (mate %.n)
      %this  keep
      %that  drop
    ==
  ::
  ++  auld                                              ::    auld:ze
    |=  [gem=germ who=ship des=desk sab=saba now=@da]   ::  construct merge
    ^-  (unit (unit mizu))                              ::::::
    =+  for=s.sab                                       ::  foreign dome
    =+  mer=(merge [who des] [p.sab q.sab])
    ?-  gem
        %init                                           ::  force fine
          ?.  =(let 0)                                  ::  hell no
            !!
          =+  hot=(~(put by _(map ,@ud tako)) 1 (~(got by hit.for) let.for))
          [~ [~ [1 hot hut lat]]]                       ::  trivial
        %fine
          =+  der=(~(got by hit.for) let.for)
          =+  owr=(~(got by hit) let)
          ?:  =(der owr)
            [~ ~]
          ?.  (~(has in (zule der)) owr)
            ~                                          ::  not a fast forward
          ~&  [%merge-fine p.sab q.sab]
          [~ [~ [let.for hit.for hut lat]]]
        ?(%mate %that %this %meld)
          =+  foreign-head=(~(got by hut) (~(got by hit.for) let.for))
          =+  our-head=(~(got by hut) (~(got by hit) let))
          ?:  &(|(=(gem %mate) =(gem %meld)) (~(has in (zule r.foreign-head)) r.our-head))
            $(gem %fine)                               ::  use fast forward
          ?:  =(r.foreign-head r.our-head)
            [~ ~]                                      ::  up to date
          =+  gar=(mer foreign-head our-head now (strat gem))
          =+  yak=-.gar
          =+  hek=+.gar
          =.  lat  -:(aqel hek ~)                      ::  add new blobs
          =.  hut  (~(put by _(map tako yaki)) r.yak yak)
          =.  let  +(let)
          =.  hit  (~(put by _(map ,@ud tako)) let r.yak)
          [~ [~ [let hit hut lat]]]
    ==
  ::
  ++  auto                                              ::    auto:ze
    |=  mun=mood                                        ::  read at point
    ^-  (unit)
    ?:  ?=(%v p.mun)
      [~ `dome`+<+<.auto]
    ?:  &(?=(%w p.mun) !?=(%ud -.q.mun))
      ?^(r.mun ~ [~ let])
    ?:  ?=(%w p.mun)
      =+  ^=  yak
          %-  ~(got by hut)
          %-  ~(got by hit)
          let
      ?^(r.mun ~ [~ [t.yak (azul yak)]])
      ::?>  ?=(^ hit)  ?^(r.mun ~ [~ i.hit])              ::  what do?? need [@da nori]
    (amor(ank ank:(deny:(zu ank) r.mun)) p.mun)
  ::
  ++  aver                                              ::    aver:ze
    |=  mun=mood                                        ::  direct read
    ^-  (unit (unit ,*))
    =+  nao=(aeon q.mun)
    ?~(nao ~ [~ (avid u.nao mun)])
  ::
  ++  avid                                              ::    avid:ze
    |=  [oan=@ud mun=mood]                              ::  seek and read
    ^-  (unit)
    ?:  &(?=(%w p.mun) !?=(%ud -.q.mun))                ::  NB only for speed
      ?^(r.mun ~ [~ oan])
    (auto:(argo oan) mun)
  ::
  ++  equi                                              ::  test paths
    |=  [p=(map path lobe) q=(map path lobe)]
    ^-  ?
    %-  |=  qat=?
        ?.  qat  %.n
        %+  roll  (~(tap by q) ~)
        |=  [[pat=path lob=lobe] eq=?]
        ^-  ?
        ?.  eq  %.n
        (~(has by p) pat)
    %+  roll  (~(tap by p) ~)
    |=  [[pat=path lob=lobe] eq=?]
    ^-  ?
    ?.  eq  %.n
    =+  zat=(~(get by q) pat)
    ?~  zat  %.n
    =((zaul u.zat) (zaul lob))
  ::
  ++  axel                                              ::    axel:ze
    |=  [wen=@da lem=nori]                              ::  edit
    ^+  +>
    ?-  -.lem
      &  =+  ^=  yet 
             %+  azol  wen
             ?:  =(let 0)                               ::  initial import
               [~ q.lem]
             [(some r:(need (~(get by hut) (need (~(get by hit) let))))) q.lem]
         =+  yak=-.yet
         =.  lat  +.yet                                 ::  merge objects
         ?.  |(=(0 let) !=((lent p.yak) 1) !(equi q.yak q:(need (~(get by hut) (need (~(get by hit) let))))))
           +>.$                                         ::  silently ignore
         =:  let  +(let)
             hit  (~(put by hit) +(let) r.yak)
             hut  (~(put by hut) r.yak yak)
         ==
         +>.$(ank (azel q.yak))
      |  +>.$(lab ?<((~(has by lab) p.lem) (~(put by lab) p.lem let)))
    ==
  ::
  ++  axon                                              ::    axon:ze
    |=  nyp=soba                                        ::  apply changes
    ^+  +>
    +>(ank ank:(durn:(zu ank) nyp))
  --
::
++  zu  !:                                              ::  filesystem
  |=  ank=ankh                                          ::  filesystem state
  =|  myz=(list ,[p=path q=miso])                       ::  changes in reverse
  =|  ram=path                                          ::  reverse path into
  |%
  ++  dash                                              ::  local rehash
    ^-  cash
    %+  mix  ?~(q.ank 0 p.u.q.ank)
    =+  axe=1
    |-  ^-  cash
    ?~  r.ank  _@
    ;:  mix
      (shaf %dash (mix axe (shaf %dush (mix p.n.r.ank p.q.n.r.ank))))
      $(r.ank l.r.ank, axe (peg axe 2))
      $(r.ank r.r.ank, axe (peg axe 3))
    ==
  ::
  ++  dosh  %_(. p.ank dash)                            ::  rehash and save
  ++  dose                                              ::  ascend
    |=  [lol=@ta kan=ankh]
    ^+  +>
    ?>  &(?=(^ ram) =(lol i.ram))
    %=    +>
        ram  t.ram
        ank
      ?:  =([0 ~ ~] ank)
        ?.  (~(has by r.kan) lol)  kan
        kan(r (~(del by r.kan) lol))
      kan(r (~(put by r.kan) lol ank))
    ==
  ::
  ++  deaf                                              ::  add change
    |=  mis=miso
    ^+  +>
    +>(myz [[(flop ram) mis] myz])
  ::
  ++  dent                                              ::  descend
    |=  lol=@ta
    ^+  +>
    =+  you=(~(get by r.ank) lol)
    +>.$(ram [lol ram], ank ?~(you [*cash ~ ~] u.you))
  ::
  ++  deny                                              ::  descend recursively
    |=  way=path
    ^+  +>
    ?~(way +> $(way t.way, +> (dent i.way)))
  ::
  ++  dest                                              ::  write over
    |=  [pum=umph val=(unit ,[p=cash q=*])]
    ^+  +>
    ?~  q.ank
      ?~  val  +>
      (deaf %ins q.u.val)
    ?~  val
      (deaf %del q.u.q.ank)
    ?:  =(q.u.val q.u.q.ank)  +>
    (deaf %mut ((diff pum) q.u.q.ank q.u.val))
  ::
  ++  dist                                              ::  modify tree
    |=  [pum=umph bus=ankh]
    ^+  +>
    =.  +>  (dest pum q.bus)
    =+  [yeg=(~(tap by r.ank) ~) gey=(~(tap by r.bus) ~)]
    =.  +>.$
      |-  ^+  +>.^$
      ?~  yeg  +>.^$
      ?:  (~(has by r.bus) p.i.yeg)  $(yeg t.yeg)
      $(yeg t.yeg, myz myz:dirk(ank q.i.yeg, ram [p.i.yeg ram]))
    |-  ^+  +>.^$
    ?~  gey  +>.^$
    $(gey t.gey, myz myz:^$(bus q.i.gey, +> (dent p.i.gey)))
  ::
  ++  dirk                                              ::  rm -r
    |-  ^+  +
    =.  +  ?~(q.ank + (deaf %del q.u.q.ank))
    =+  dyr=(~(tap by r.ank) ~)
    |-  ^+  +.^$
    ?~  dyr  +.^$
    =.  +.^$  dirk:(dent p.i.dyr)
    $(dyr t.dyr)
  ::
  ++  drum                                              ::  apply effect
    |=  [pax=path mis=miso]
    ^+  +>
    ?^  pax
      dosh:(dose:$(pax t.pax, +> (dent i.pax)) i.pax ank)
    ~|  %clay-fail
    ?-    -.mis
        %del
      ?>  &(?=(^ q.ank) =(q.u.q.ank p.mis))
      +>.$(p.ank (mix p.u.q.ank p.ank), q.ank ~)
    ::
        %ins
      ?>  ?=(~ q.ank)
      =+  sam=(sham p.mis)
      +>.$(p.ank (mix sam p.ank), q.ank [~ sam p.mis])
    ::
        %mut
      ?>  ?=(^ q.ank)
      =+  nex=(lump p.mis q.u.q.ank)
      =+  sam=(sham nex)
      +>.$(p.ank :(mix sam p.u.q.ank p.ank), q.ank [~ sam nex])
    ==
  ::
  ++  dune                                              ::  apply
    |-  ^+  +
    ?~  myz  +
    =>  .(+ (drum p.i.myz q.i.myz))
    $(myz ?>(?=(^ myz) t.myz))
  ::
  ++  durn                                              ::  apply forward
    |=  nyp=soba
    ^+  +>
    ?:  =([0 0] p.nyp)
      dune(myz q.nyp)
    =>  ?:  =(p.ank p.p.nyp)  .
        ~&  [%durn-in-wrong p.ank p.p.nyp]
        .
    =.  +>  dune(myz q.nyp)
    =>  ?:  =(p.ank q.p.nyp)  .
        ~&  [%durn-out-wrong p.ank q.p.nyp]
        .
    +>
  --
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                section 3bF, names etc                ::
::
++  clan                                                ::  ship to rank
  |=  who=ship  ^-  rank
  =+  wid=(met 3 who)
  ?:  (lte wid 1)   %czar
  ?:  =(2 wid)      %king
  ?:  (lte wid 4)   %duke
  ?:  (lte wid 8)   %earl
  ?>  (lte wid 16)  %pawn
::
++  deft                                                ::  import url path
  |=  rax=(list ,@t)
  |-  ^-  pork
  ?~  rax
    [~ ~]
  ?~  t.rax
    =+  den=(trip i.rax)
    =+  ^=  vex
      %-  %-  full
          ;~(plug sym ;~(pose (stag ~ ;~(pfix dot sym)) (easy ~)))
      [[1 1] (trip i.rax)]
    ?~  q.vex
      [~ [i.rax ~]]
    [+.p.u.q.vex [-.p.u.q.vex ~]]
  =+  pok=$(rax t.rax)
  :-  p.pok
  [i.rax q.pok]
::
++  fain                                                ::  path restructure
  |=  [hom=path raw=path]
  =+  bem=(need (tome raw))
  =+  [mer=(flop s.bem) moh=(flop hom)]
  |-  ^-  (pair beam path)
  ?~  moh  
    [bem(s hom) (flop mer)]
  ?>  &(?=(^ mer) =(i.mer i.moh))
  $(mer t.mer, moh t.moh)
::
++  fest                                                ::  web synthesizer
  |=  [hom=path raw=path]
  |*  yax=$+(epic *)
  (yax (fuel (fain hom raw)))
::
++  folk                                                ::  silk construction
  |=  [hom=path raw=path]
  |*  yox=$+((pair beam path) *)
  (yox (fain hom raw))
::
++  fuel                                                ::  parse fcgi
  |=  [bem=beam but=path]
  ^-  epic
  ?>  ?=([%web @ *] but)
  =+  dyb=(slay i.t.but)
  ?>  ?&  ?=([~ %many *] dyb)
          ?=([* * *] p.u.dyb)
          ::  ?=([%$ %tas *] i.p.u.dyb)
          ?=([%many *] i.p.u.dyb)
          ?=([%blob *] i.t.p.u.dyb)
      ==
  =+  ced=((hard cred) p.i.t.p.u.dyb)
  ::  =+  nep=q.p.i.p.u.dyb
  =+  ^=  nyp  ^-  path
      %+  turn  p.i.p.u.dyb
      |=  a=coin  ^-  @ta
      ?>  ?=([%$ %ta @] a)
      ?>(((sane %ta) q.p.a) q.p.a)
  =+  ^=  gut  ^-  (list ,@t)
      %+  turn  t.t.p.u.dyb
      |=  a=coin  ^-  @t
      ?>  ?=([%$ %t @] a)
      ?>(((sane %t) q.p.a) q.p.a)
  =+  ^=  quy
      |-  ^-  (list ,[p=@t q=@t])
      ?~  gut  ~
      ?>  ?=(^ t.gut)
      [[i.gut i.t.gut] $(gut t.t.gut)]
  :*  (~(gas by *(map cord cord)) quy)
      ced
      -.bem
      t.t.but
      nyp
  ==

::
++  gist                                                ::  convenient html
  |=  [hom=path raw=path]
  |=  yax=$+(epic marl)
  %-  (fest hom raw)
  |=  piq=epic
  ^-  manx
  =+  ^=  sip                                           ::  skip blanks
      |=  mal=marl
      ?~(mal ~ ?.(|(=(:/(~) i.mal) =(:/([10 ~]) i.mal)) mal $(mal t.mal)))
  =+  zay=`marl`(yax piq)
  =.  zay  (sip zay)
  =+  ^=  twa
      |-  ^-  [p=marl q=marl]
      ?~  zay  [~ ~]
      ?:  ?=([[[%head *] *] *] zay)
        [c.i.zay ?:(?=([[[%body *] *] ~] t.zay) c.i.t.zay t.zay)]
      ?:  ?=([[[%title *] *] *] zay)
        [[i.zay ~] t.zay]
      [~ zay]
  [/html [/head (sip p.twa)] [/body (sip q.twa)] ~]
::
++  urle                                                ::  URL encode
  |=  tep=tape
  ^-  tape
  %-  zing
  %+  turn  tep
  |=  tap=char
  =+  xen=|=(tig=@ ?:((gte tig 10) (add tig 55) (add tig '0')))
  ?:  ?|  &((gte tap 'a') (lte tap 'z'))
          &((gte tap 'A') (lte tap 'Z'))
          &((gte tap '0') (lte tap '9'))
          =('.' tap)
          =('-' tap)
          =('~' tap)
          =('_' tap)
      ==
    [tap ~]
  ['%' (xen (rsh 0 4 tap)) (xen (end 0 4 tap)) ~]
::
++  urld                                                ::  URL decode
  |=  tep=tape
  ^-  (unit tape)
  ?~  tep  [~ ~]
  ?:  =('%' i.tep)
    ?.  ?=([@ @ *] t.tep)  ~
    =+  nag=(mix i.t.tep (lsh 3 1 i.t.t.tep))
    =+  val=(rush nag hex:ag)
    ?~  val  ~
    =+  nex=$(tep t.t.t.tep)
    ?~(nex ~ [~ [`@`u.val u.nex]])
  =+  nex=$(tep t.tep)
  ?~(nex ~ [~ i.tep u.nex])
++  sifo                                                ::  64-bit encode
  |=  tig=@
  ^-  tape
  =+  poc=(mod (sub 3 (mod (met 3 tig) 3)) 3)
  =+  pad=(lsh 3 poc (swap 3 tig))
  =+  ^=  ska
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  =+  ^=  sif
      %-  flop
      |-  ^-  tape
      ?~  pad
        ~
      =+  d=(end 0 6 pad)
      [(snag d ska) $(pad (rsh 0 6 pad))]
  (weld (scag (sub (lent sif) poc) sif) (trip (fil 3 poc '=')))
::
++  earl                                                ::  local purl to tape
  |=  [who=@p pul=purl]
  ^-  purl
  pul(q.q [(rsh 3 1 (scot %p who)) q.q.pul])
::
++  earn                                                ::  purl to tape
  |=  pul=purl
  ^-  tape
  =<  apex
  |%
  ++  apex
    ^-  tape
    :(weld head "/" body tail)
  ::
  ++  body
    |-  ^-  tape
    ?~  q.q.pul
      ?~(p.q.pul ~ ['.' (trip u.p.q.pul)])
    =+  seg=(trip i.q.q.pul)
    ?:(=(~ t.q.q.pul) seg (weld seg `tape`['/' $(q.q.pul t.q.q.pul)]))
  ::
  ++  head
    ^-  tape
    ;:  weld
      ?:(&(p.p.pul !=([& /localhost] r.p.pul)) "https://" "http://")
    ::
      ?-  -.r.p.pul
        |  (trip (rsh 3 1 (scot %if p.r.p.pul)))
        &  =+  rit=(flop p.r.p.pul)
           |-  ^-  tape
           ?~(rit ~ (weld (trip i.rit) ?~(t.rit "" `tape`['.' $(rit t.rit)])))
      ==
    ::
      ?~(q.p.pul ~ `tape`[':' (trip (rsh 3 2 (scot %ui u.q.p.pul)))])
    ==
  ::
  ++  tail
    ^-  tape
    ?:  =(~ r.pul)  ~
    :-  '?'
    |-  ^-  tape
    ?~  r.pul  ~
    ;:  weld
      (trip p.i.r.pul)
      "="
      (trip q.i.r.pul)
      ?~(t.r.pul ~ `tape`['&' $(r.pul t.r.pul)])
    ==
  --
::
++  epur                                                ::  url/header parser
  |%
  ++  apat                                              ::  2396 abs_path
    %+  cook  deft
    (ifix [fas ;~(pose fas (easy ~))] (more fas smeg))
  ++  auri
    %+  cook
      |=  a=purl
      ?.(=([& /localhost] r.p.a) a a(p.p &))
    ;~  plug
      ;~  plug
        %+  sear
          |=  a=@t
          ^-  (unit ,?)
          ?+(a ~ %http [~ %|], %https [~ %&])
        ;~(sfix scem ;~(plug col fas fas))
        thor
      ==
      ;~(plug ;~(pose apat (easy *pork)) yque)
    ==
  ++  cock                                              ::  cookie
    (most ;~(plug sem ace) ;~(plug toke ;~(pfix tis tosk)))
  ++  dlab                                              ::  2396 domainlabel
    %+  sear
      |=  a=@ta
      ?.(=('-' (rsh 3 a (dec (met 3 a)))) [~ u=a] ~)
    %+  cook  cass
    ;~(plug aln (star alp))
  ::
  ++  fque  (cook crip (plus pquo))                     ::  normal query field
  ++  fquu  (cook crip (star pquo))                     ::  optional field
  ++  pcar  ;~(pose pure pesc psub col pat)             ::  2396 path char
  ++  pcok  ;~  pose                                    ::  cookie char
              (just `@`0x21)
              (shim 0x23 0x2b)
              (shim 0x2d 0x3a)
              (shim 0x3c 0x5b)
              (shim 0x5d 0x7e)
            ==
  ++  pesc  ;~(pfix cen mes)                            ::  2396 escaped
  ++  pold  (cold ' ' (just '+'))                       ::  old space code
  ++  pque  ;~(pose pcar fas wut)                       ::  3986 query char
  ++  pquo  ;~(pose pure pesc pold)                     ::  normal query char
  ++  pure  ;~(pose aln hep dot cab sig)                ::  2396 unreserved
  ++  psub  ;~  pose                                    ::  3986 sub-delims
              zap  buc  pam  soq  pel  per
              tar  lus  com  sem  tis
            ==
  ++  ptok  ;~  pose                                    ::  2616 token
              aln  zap  hax  buc  cen  pam  soq  tar  lus
              hep  dot  ket  cab  tec  bar  sig
            ==
  ++  scem                                              ::  2396 scheme
    %+  cook  cass
    ;~(plug alf (star ;~(pose aln lus hep dot)))
  ::
  ++  smeg  (cook crip (plus pcar))                     ::  2396 segment
  ++  tock  (cook crip (plus pcok))                     ::  6265 cookie-value
  ++  tosk  ;~(pose tock (ifix [doq doq] tock))         ::  6265 cookie-value
  ++  toke  (cook crip (plus ptok))                     ::  2616 token
  ++  thor                                              ::  2396 host/port
    %+  cook  |*(a=[* *] [+.a -.a])
    ;~  plug
      thos
      ;~(pose (stag ~ ;~(pfix col dim:ag)) (easy ~))
    ==
  ++  thos                                              ::  2396 host, no local
    ;~  plug
      ;~  pose
        %+  stag  %&
        %+  sear                                        ::  LL parser weak here
          |=  a=(list ,@t)
          =+  b=(flop a)
          ?>  ?=(^ b)
          =+  c=(end 3 1 i.b)
          ?.(&((gte c 'a') (lte c 'z')) ~ [~ u=b])
        (most dot dlab)
      ::
        %+  stag  %|
        =+  tod=(ape:ag ted:ab)
        %+  bass  256
        ;~(plug tod (stun [3 3] ;~(pfix dot tod)))
      ==
    ==
  ++  yque                                              ::  query ending
    ;~  pose
      ;~(pfix wut yquy)
      (easy ~)
    ==
  ++  yquy                                              ::  query
    ;~  pose                                            ::  proper query
      %+  more
        ;~(pose pam sem)
      ;~(plug fque ;~(pose ;~(pfix tis fquu) (easy '')))
    ::
      %+  cook                                          ::  funky query
        |=(a=tape [[%$ (crip a)] ~])
      (star pque)
    ==
  ++  zest                                              ::  2616 request-uri
    ;~  pose
      (stag %& (cook |=(a=purl a) auri))
      (stag %| ;~(plug apat yque))
    ==
  --
::
++  feel                                                ::  simple file write
  |=  [pax=path val=*]
  ^-  miso
  =+  dir=((hard arch) .^(%cy pax))
  ?~  q.dir  [%ins val]
  :-  %mut
  ^-  udon
  [%a %a .^(%cx pax) val]
::
++  file                                                ::  simple file load
  |=  pax=path
  ^-  (unit)
  =+  dir=((hard arch) .^(%cy pax))
  ?~(q.dir ~ [~ .^(%cx pax)])
::
++  foal                                                ::  high-level write
  |=  [pax=path val=*]
  ^-  toro
  ?>  ?=([* * * *] pax)
  [i.t.pax [%& [*cart [[t.t.t.pax (feel pax val)] ~]]]]
::
++  fray                                                ::  high-level delete
  |=  pax=path
  ^-  toro
  ?>  ?=([* * * *] pax)
  [i.t.pax [%& [*cart [[t.t.t.pax [%del .^(%cx pax)]] ~]]]]
::
++  furl                                                ::  unify changes
  |=  [one=toro two=toro] 
  ^-  toro
  ~|  %furl
  ?>  ?&  =(p.one p.two)                                ::  same path
          &(?=(& -.q.one) ?=(& -.q.two))                ::  both deltas
      ==
  [p.one [%& [*cart (weld q.q.q.one q.q.q.two)]]]
::
++  glam
  |=  zar=@p  ^-  tape
  %+  snag  zar
  ^-  (list tape)
  :~  "Tianming"  "Pepin the Short"  "Haile Selassie"  "Alfred the Great"
      "Tamerlane"  "Pericles"  "Talleyrand"  "Yongle"  "Seleucus"
      "Uther Pendragon"  "Louis XVI"  "Ahmad Shāh Durrānī"  "Constantine"
      "Wilhelm I"  "Akbar"  "Louis XIV"  "Nobunaga"  "Alexander VI"
      "Philippe II"  "Julius II"  "David"  "Niall Noígíallach"  "Kublai Khan"
      "Öz Beg Khan"  "Ozymandias"  "Ögedei Khan"  "Jiang Jieshi"  "Darius"
      "Shivaji"  "Qianlong"  "Bolesław I Chrobry"  "Tigranes"  "Han Wudi"
      "Charles X"  "Naresuan"  "Frederick II"  "Simeon"  "Kangxi"
      "Suleiman the Magnificent"  "Pedro II"  "Genghis Khan"  "Laozi"
      "Porfirio Díaz"  "Pakal"  "Wu Zetian"  "Garibaldi"  "Matthias Corvinus"
      "Leopold II"  "Leonidas"  "Sitting Bull"  "Nebuchadnezzar II"
      "Rhodes"  "Henry VIII"  "Attila"  "Catherine II"  "Chulalongkorn"
      "Uthmān"  "Augustus"  "Faustin"  "Chongde"  "Justinian"
      "Afonso de Albuquerque"  "Antoninus Pius"  "Cromwell"  "Innocent X"
      "Fidel"  "Frederick the Great"  "Canute"  "Vytautas"  "Amina"
      "Hammurabi"  "Suharto"  "Victoria"  "Hiawatha"  "Paul V"  "Shaka"
      "Lê Thánh Tông"  "Ivan Asen II"  "Tiridates"  "Nefertiti"  "Gwangmu"
      "Ferdinand & Isabella"  "Askia"  "Xuande"  "Boris Godunov"  "Gilgamesh"
      "Maximillian I"  "Mao"  "Charlemagne"  "Narai"  "Hanno"  "Charles I & V"
      "Alexander II"  "Mansa Musa"  "Zoe Porphyrogenita"  "Metternich"
      "Robert the Bruce"  "Pachacutec"  "Jefferson"  "Solomon"  "Nicholas I"
      "Barbarossa"  "FDR"  "Pius X"  "Gwanggaeto"  "Abbas I"  "Julius Caesar"
      "Lee Kuan Yew"  "Ranavalona I"  "Go-Daigo"  "Zenobia"  "Henry V"
      "Bảo Đại"  "Casimir III"  "Cyrus"  "Charles the Wise"  "Sandrokottos"
      "Agamemnon"  "Clement VII"  "Suppiluliuma"  "Deng Xiaoping"
      "Victor Emmanuel"  "Ajatasatru"  "Jan Sobieski"  "Huangdi"  "Xuantong"
      "Narmer"  "Cosimo de' Medici"  "Möngke Khan"  "Stephen Dušan"  "Henri IV"
      "Mehmed Fatih"  "Conn Cétchathach"  "Francisco Franco"  "Leo X"
      "Kammu"  "Krishnadevaraya"  "Elizabeth I"  "Norton I"  "Washington"
      "Meiji"  "Umar"  "TR"  "Peter the Great"  "Agustin I"  "Ashoka"
      "William the Conqueror"  "Kongolo Mwamba"  "Song Taizu"
      "Ivan the Terrible"  "Yao"  "Vercingetorix"  "Geronimo"  "Rurik"
      "Urban VIII"  "Alexios Komnenos"  "Maria I"  "Tamar"  "Bismarck"
      "Arthur"  "Jimmu"  "Gustavus Adolphus"  "Suiko"  "Basil I"  "Montezuma"
      "Santa Anna"  "Xerxes"  "Beyazıt Yıldırım"  "Samudragupta"  "James I"
      "George III"  "Kamehameha"  "Francesco Sforza"  "Trajan"
      "Rajendra Chola"  "Hideyoshi"  "Cleopatra"  "Alexander"
      "Ashurbanipal"  "Paul III"  "Vespasian"  "Tecumseh"  "Narasimhavarman"
      "Suryavarman II"  "Bokassa I"  "Charles Canning"  "Theodosius"
      "Francis II"  "Zhou Wen"  "William Jardine"  "Ahmad al-Mansur"
      "Lajos Nagy"  "Theodora"  "Mussolini"  "Samuil"  "Osman Gazi"
      "Kim Il-sung"  "Maria Theresa"  "Lenin"  "Tokugawa"  "Marcus Aurelius"
      "Nzinga Mbande"  "Edward III"  "Joseph II"  "Pulakesi II"  "Priam"
      "Qin Shi Huang"  "Shah Jahan"  "Sejong"  "Sui Wendi"  "Otto I"
      "Napoleon III"  "Prester John"  "Dido"  "Joao I"  "Gregory I"
      "Gajah Mada"  "Abd-ar Rahmān III"  "Taizong"  "Franz Josef I"
      "Nicholas II"  "Gandhi"  "Chandragupta II"  "Peter III"
      "Oba Ewuare"  "Louis IX"  "Napoleon"  "Selim Yavuz"  "Shun"
      "Hayam Wuruk"  "Jagiełło"  "Nicaule"  "Sargon"  "Saladin"  "Charles II"
      "Brian Boru"  "Da Yu"  "Antiochus III"  "Charles I"
      "Jan Pieterszoon Coen"  "Hongwu"  "Mithridates"  "Hadrian"  "Ptolemy"
      "Benito Juarez"  "Sun Yat-sen"  "Raja Raja Chola"  "Bolivar"  "Pius VII"
      "Shapur II"  "Taksin"  "Ram Khamhaeng"  "Hatshepsut"  "Alī"  "Matilda"
      "Ataturk"
  ==
::
++  glon
  |=  lag=lang
  ^-  (unit tape)
  ?+  lag  ~
    %aa  [~ "Afar"]
    %ab  [~ "Abkhazian"]
    %ae  [~ "Avestan"]
    %af  [~ "Afrikaans"]
    %ak  [~ "Akan"]
    %am  [~ "Amharic"]
    %an  [~ "Aragonese"]
    %ar  [~ "Arabic"]
    %as  [~ "Assamese"]
    %av  [~ "Avaric"]
    %ay  [~ "Aymara"]
    %az  [~ "Azerbaijani"]
    %ba  [~ "Bashkir"]
    %be  [~ "Belarusian"]
    %bg  [~ "Bulgarian"]
    %bh  [~ "Bihari"]
    %bi  [~ "Bislama"]
    %bm  [~ "Bambara"]
    %bn  [~ "Bengali"]
    %bo  [~ "Tibetan"]
    %br  [~ "Breton"]
    %bs  [~ "Bosnian"]
    %ca  [~ "Catalan"]
    %ce  [~ "Chechen"]
    %ch  [~ "Chamorro"]
    %co  [~ "Corsican"]
    %cr  [~ "Cree"]
    %cs  [~ "Czech"]
    %cu  [~ "Slavonic"]
    %cv  [~ "Chuvash"]
    %cy  [~ "Welsh"]
    %da  [~ "Danish"]
    %de  [~ "German"]
    %dv  [~ "Maldivian"]
    %dz  [~ "Dzongkha"]
    %ee  [~ "Ewe"]
    %el  [~ "Greek"]
    %en  [~ "English"]
    %eo  [~ "Esperanto"]
    %es  [~ "Spanish"]
    %et  [~ "Estonian"]
    %eu  [~ "Basque"]
    %fa  [~ "Persian"]
    %ff  [~ "Fulah"]
    %fi  [~ "Finnish"]
    %fj  [~ "Fijian"]
    %fo  [~ "Faroese"]
    %fr  [~ "French"]
    %fy  [~ "Frisian"]
    %ga  [~ "Irish Gaelic"]
    %gd  [~ "Scottish Gaelic"]
    %gl  [~ "Galician"]
    %gn  [~ "Guarani"]
    %gu  [~ "Gujarati"]
    %gv  [~ "Manx"]
    %ha  [~ "Hausa"]
    %he  [~ "Hebrew"]
    %hi  [~ "Hindi"]
    %ho  [~ "Hiri Motu"]
    %hr  [~ "Croatian"]
    %ht  [~ "Haitian Creole"]
    %hu  [~ "Hungarian"]
    %hy  [~ "Armenian"]
    %hz  [~ "Herero"]
    %ia  [~ "Interlingua"]
    %id  [~ "Indonesian"]
    %ie  [~ "Occidental"]
    %ig  [~ "Igbo"]
    %ii  [~ "Nuosu"]
    %ik  [~ "Inupiaq"]
    %io  [~ "Ido"]
    %is  [~ "Icelandic"]
    %it  [~ "Italian"]
    %iu  [~ "Inuktitut"]
    %ja  [~ "Japanese"]
    %jv  [~ "Javanese"]
    %ka  [~ "Georgian"]
    %kg  [~ "Kongo"]
    %ki  [~ "Kikuyu"]
    %kj  [~ "Kwanyama"]
    %kk  [~ "Kazakh"]
    %kl  [~ "Kalaallisut"]
    %km  [~ "Central Khmer"]
    %kn  [~ "Kannada"]
    %ko  [~ "Korean"]
    %kr  [~ "Kanuri"]
    %ks  [~ "Kashmiri"]
    %ku  [~ "Kurdish"]
    %kv  [~ "Komi"]
    %kw  [~ "Cornish"]
    %ky  [~ "Kyrgyz"]
    %la  [~ "Latin"]
    %lb  [~ "Luxembourgish"]
    %lg  [~ "Ganda"]
    %li  [~ "Limburgish"]
    %ln  [~ "Lingala"]
    %lo  [~ "Lao"]
    %lt  [~ "Lithuanian"]
    %lu  [~ "Luba-Katanga"]
    %lv  [~ "Latvian"]
    %mg  [~ "Malagasy"]
    %mh  [~ "Marshallese"]
    %mi  [~ "Maori"]
    %mk  [~ "Macedonian"]
    %ml  [~ "Malayalam"]
    %mn  [~ "Mongolian"]
    %mr  [~ "Marathi"]
    %ms  [~ "Malay"]
    %mt  [~ "Maltese"]
    %my  [~ "Burmese"]
    %na  [~ "Nauru"]
    %nb  [~ "Norwegian Bokmål"]
    %nd  [~ "North Ndebele"]
    %ne  [~ "Nepali"]
    %ng  [~ "Ndonga"]
    %nl  [~ "Dutch"]
    %nn  [~ "Norwegian Nynorsk"]
    %no  [~ "Norwegian"]
    %nr  [~ "South Ndebele"]
    %nv  [~ "Navajo"]
    %ny  [~ "Chichewa"]
    %oc  [~ "Occitan"]
    %oj  [~ "Ojibwa"]
    %om  [~ "Oromo"]
    %or  [~ "Oriya"]
    %os  [~ "Ossetian"]
    %pa  [~ "Punjabi"]
    %pi  [~ "Pali"]
    %pl  [~ "Polish"]
    %ps  [~ "Pashto"]
    %pt  [~ "Portuguese"]
    %qu  [~ "Quechua"]
    %rm  [~ "Romansh"]
    %rn  [~ "Rundi"]
    %ro  [~ "Romanian"]
    %ru  [~ "Russian"]
    %rw  [~ "Kinyarwanda"]
    %sa  [~ "Sanskrit"]
    %sc  [~ "Sardinian"]
    %sd  [~ "Sindhi"]
    %se  [~ "Northern Sami"]
    %sg  [~ "Sango"]
    %si  [~ "Sinhala"]
    %sk  [~ "Slovak"]
    %sl  [~ "Slovenian"]
    %sm  [~ "Samoan"]
    %sn  [~ "Shona"]
    %so  [~ "Somali"]
    %sq  [~ "Albanian"]
    %sr  [~ "Serbian"]
    %ss  [~ "Swati"]
    %st  [~ "Sotho"]
    %su  [~ "Sundanese"]
    %sv  [~ "Swedish"]
    %sw  [~ "Swahili"]
    %ta  [~ "Tamil"]
    %te  [~ "Telugu"]
    %tg  [~ "Tajik"]
    %th  [~ "Thai"]
    %ti  [~ "Tigrinya"]
    %tk  [~ "Turkmen"]
    %tl  [~ "Tagalog"]
    %tn  [~ "Tswana"]
    %to  [~ "Tonga"]
    %tr  [~ "Turkish"]
    %ts  [~ "Tsonga"]
    %tt  [~ "Tatar"]
    %tw  [~ "Twi"]
    %ty  [~ "Tahitian"]
    %ug  [~ "Uighur"]
    %uk  [~ "Ukrainian"]
    %ur  [~ "Urdu"]
    %uz  [~ "Uzbek"]
    %ve  [~ "Venda"]
    %vi  [~ "Vietnamese"]
    %vo  [~ "Volapük"]
    %wa  [~ "Walloon"]
    %wo  [~ "Wolof"]
    %xh  [~ "Xhosa"]
    %yi  [~ "Yiddish"]
    %yo  [~ "Yoruba"]
    %za  [~ "Zhuang"]
    %zh  [~ "Chinese"]
    %zu  [~ "Zulu"]
  ==
::
++  gnow
  |=  [who=@p gos=gcos]  ^-  @t
  ?-    -.gos
      %czar                 (rap 3 '|' (rap 3 (glam who)) '|' ~)
      %king                 (rap 3 '_' p.gos '_' ~)
      %earl                 (rap 3 ':' p.gos ':' ~)
      %pawn                 ?~(p.gos %$ (rap 3 '.' u.p.gos '.' ~))
      %duke
    ?:  ?=(%anon -.p.gos)  %$
    %+  rap  3
    ^-  (list ,@)
    ?-    -.p.gos
        %punk  ~['"' q.p.gos '"']
        ?(%lord %lady)
      =+  ^=  nad
          =+  nam=`name`s.p.p.gos
          %+  rap  3
          :~  p.nam
              ?~(q.nam 0 (cat 3 ' ' u.q.nam))
              ?~(r.nam 0 (rap 3 ' (' u.r.nam ')' ~))
              ' '
              s.nam
          ==
      ?:(=(%lord -.p.gos) ~['[' nad ']'] ~['(' nad ')'])
    ==
  ==
::
++  hunt                                                ::  first of unit dates
  |=  [one=(unit ,@da) two=(unit ,@da)]
  ^-  (unit ,@da)
  ?~  one  two
  ?~  two  one
  ?:((lth u.one u.two) one two)
::
++  meat                                                ::  kite to .^ path
  |=  kit=kite
  ^-  path
  [(cat 3 'c' p.kit) (scot %p r.kit) s.kit (scot (dime q.kit)) t.kit]
::
++  mojo                                                ::  compiling load
  |=  [pax=path src=*]
  ^-  (each twig (list tank))
  ?.  ?=(@ src)
    [%| ~[[leaf/"musk: malformed: {<pax>}"]]]
  =+  ^=  mud
      %-  mule  |.
      ((full vest) [1 1] (trip src))
  ?:  ?=(| -.mud)  mud
  ?~  q.p.mud
    :~  %|
        leaf/"musk: syntax error: {<pax>}"
        leaf/"musk: line {<p.p.p.mud>}, column {<q.p.p.mud>}"
    ==
  [%& p.u.q.p.mud]
::
++  mole                                                ::  new to old sky
  |=  ska=$+(* (unit (unit)))
  |=  a=*
  ^-  (unit)
  =+  b=(ska a)
  ?~  b  ~
  ?~  u.b  ~
  [~ u.u.b]
::
++  much                                                ::  constructing load
  |=  [pax=path src=*]
  ^-  gank
   =+  moj=(mojo pax src)
  ?:  ?=(| -.moj)  moj
  (mule |.((slap !>(+>.$) `twig`p.moj)))
::
++  musk                                                ::  compiling apply
  |=  [pax=path src=* sam=vase]
  ^-  gank
  =+  mud=(much pax src)
  ?:  ?=(| -.mud)  mud
  (mule |.((slam p.mud sam)))
::
++  numb                                                ::  ship display name?
  |=  [him=@p now=@da]  ^-  @t
  =+  yow=(scot %p him)
  =+  woy=((hard ,@t) .^(%a yow %name (scot %da now) ~))
  ?:  =(%$ woy)  yow
  (cat 3 yow (cat 3 ' ' woy))
::
++  saxo                                                ::  autocanon
  |=  who=ship
  ^-  (list ship)
  ?:  (lth who 256)  [who ~]
  [who $(who (sein who))]
::
++  sein                                                ::  autoboss
  |=  who=ship  ^-  ship
  =+  mir=(clan who)
  ?-  mir
    %czar  who
    %king  (end 3 1 who)
    %duke  (end 4 1 who)
    %earl  (end 5 1 who)
    %pawn  `@p`0
  ==
::
++  tame
  |=  hap=path
  ^-  (unit kite)
  ?.  ?=([@ @ @ @ *] hap)  ~
  =+  :*  hyr=(slay i.hap)
          fal=(slay i.t.hap)
          dyc=(slay i.t.t.hap)
          ved=(slay i.t.t.t.hap)
          ::  ved=(slay i.t.hap)
          ::  fal=(slay i.t.t.hap)
          ::  dyc=(slay i.t.t.t.hap)
          tyl=t.t.t.t.hap
      ==
  ?.  ?=([~ %$ %tas @] hyr)  ~
  ?.  ?=([~ %$ %p @] fal)  ~
  ?.  ?=([~ %$ %tas @] dyc)  ~
  ?.  ?=(^ ved)  ~
  =+  his=`@p`q.p.u.fal
  =+  [dis=(end 3 1 q.p.u.hyr) rem=(rsh 3 1 q.p.u.hyr)]
  ?.  ?&(?=(%c dis) ?=(?(%v %w %x %y %z) rem))  ~
  [~ rem (case p.u.ved) q.p.u.fal q.p.u.dyc tyl]
::
++  tome                                                ::  parse path
  |=  pax=path
  ^-  (unit beam)
  ?.  ?=([* * * *] pax)  ~
  %+  biff  (slaw %p i.pax)
  |=  who=ship
  %+  biff  (slaw %tas i.t.pax)
  |=  dex=desk
  %+  biff  (slay i.t.t.pax)
  |=  cis=coin
  ?.  ?=([%$ case] cis)  ~
  `(unit beam)`[~ [who dex `case`p.cis] (flop t.t.t.pax)]
::
++  tope                                                ::  beam to path
  |=  bem=beam
  ^-  path
  [(scot %p p.bem) q.bem (scot r.bem) (flop s.bem)]
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                section 3bG, Arvo models              ::
::
++  acru                                                ::  asym cryptosuite
          $_  ^?  |%                                    ::  opaque object
          ++  as  ^?                                    ::  asym ops
            |%  ++  seal  |=([a=pass b=@ c=@] _@)       ::  encrypt to a
                ++  sign  |=([a=@ b=@] _@)              ::  certify as us
                ++  sure  |=([a=@ b=@] *(unit ,@))      ::  authenticate from us
                ++  tear  |=  [a=pass b=@]              ::  accept from a 
                          *(unit ,[p=@ q=@])            ::
            --                                          ::
          ++  de  |+([a=@ b=@] *(unit ,@))              ::  symmetric de, soft
          ++  dy  |+([a=@ b=@] _@)                      ::  symmetric de, hard
          ++  en  |+([a=@ b=@] _@)                      ::  symmetric en
          ++  ex  ^?                                    ::  export
            |%  ++  fig  _@uvH                          ::  fingerprint
                ++  pac  _@uvG                          ::  default passcode
                ++  pub  *pass                          ::  public key
                ++  sec  *ring                          ::  private key
            --
          ++  nu  ^?                                    ::  reconstructors
             |%  ++  pit  |=([a=@ b=@] ^?(..nu))        ::  from [width seed]
                 ++  nol  |=(a=@ ^?(..nu))              ::  from naked ring
                 ++  com  |=(a=@ ^?(..nu))              ::  from naked pass
            --
          --
++  agon  (map ,[p=ship q=desk] ,[p=@ud q=@ud r=waks])  ::  mergepts
++  ankh                                                ::  fs node (new)
          $:  p=cash                                    ::  recursive hash
              q=(unit ,[p=cash q=*])                    ::  file
              r=(map ,@ta ankh)                         ::  folders
          ==                                            ::
++  ankz  ,[p=@ (map ,@ta ankz)]                        ::  trimmed ankh
++  apex  ,[p=@uvI q=(map ,@ta ,@uvI) r=(map ,@ta ,~)]  ::  node report (old)
++  ball  ,@uw                                          ::  statement payload
++  bait  ,[p=skin q=@ud r=dove]                        ::  fmt nrecvd spec
++  bath                                                ::  convo per client
          $:  sop=shed                                  ::  not stalled
              raz=(map path race)                       ::  statements inbound
              ryl=(map path rill)                       ::  statements outbound
          ==                                            ::
++  beam  ,[[p=ship q=desk r=case] s=path]              ::  global name
++  beak  ,[p=ship q=desk r=case]                       ::  garnish with beak
++  bird                                                ::  packet in travel
          $:  gom=soap                                  ::  message identity
              mup=@ud                                   ::  pktno in msg
              nux=@ud                                   ::  xmission count
              lys=@da                                   ::  last sent
              pac=rock                                  ::  packet data
          ==                                            ::
++  blob  $%  [%delta p=lobe q=lobe r=udon]             ::  delta on q
              [%direct p=lobe q=* r=umph]               ::
              [%indirect p=lobe q=* r=udon s=lobe]      ::
          ==                                            ::
++  boat  ,[(list slip) tart]                           ::  user stage
++  boon                                                ::  fort output
          $%  [%beer p=ship q=@uvG]                     ::  gained ownership
              [%coke p=sock q=soap r=cape s=duct]       ::  message result
              [%mead p=lane q=rock]                     ::  accept packet
              [%milk p=sock q=soap r=*]                 ::  accept message
              [%ouzo p=lane q=rock]                     ::  transmit packet
              [%wine p=sock q=tape]                     ::  notify user
          ==                                            ::
++  bowl  ,[p=(list gift) q=(unit boat)]                ::  app product
++  bray  ,[p=life q=(unit life) r=ship s=@da]          ::  our parent us now
++  brow  ,[p=@da q=@tas]                               ::  browser version
++  buck  ,[p=mace q=will]                              ::  all security data
++  cake  ,[p=sock q=skin r=@]                          ::  top level packet
++  cape                                                ::  end-to-end result
          $?  %good                                     ::  delivered
              %dead                                     ::  rejected
          ==                                            ::
++  cart  ,[p=cash q=cash]                              ::  hash change
++  care  ?(%u %v %w %x %y %z)                          ::  clay submode
++  case                                                ::  ship desk case spur
          $%  [%da p=@da]                               ::  date
              [%tas p=@tas]                             ::  label
              [%ud p=@ud]                               ::  number
          ==                                            ::
++  cash  ,@uvH                                         ::  ankh hash
++  clot                                                ::  symmetric record
          $:  yed=(unit ,[p=hand q=code])               ::  outbound
              heg=(map hand code)                       ::  proposed
              qim=(map hand code)                       ::  inbound
          ==                                            ::
++  coal  ,*                                            ::  untyped vase
++  code  ,@uvI                                         ::  symmetric key
++  cone                                                ::  reconfiguration
          $%  [& p=twig]                                ::  transform
              [| p=(list ,@tas)]                        ::  alter
          ==                                            ::
++  chum  ,@uvI                                         ::  hashed passcode
++  claw                                                ::  startup chain
          $:  joy=(unit coal)                           ::  local context
              ran=(unit coal)                           ::  arguments
              pux=(unit path)                           ::  execution path
              jiv=(unit coal)                           ::  app configuration
              kyq=(unit coal)                           ::  app customization
              gam=(unit coal)                           ::  app image
          ==                                            ::
++  clip  (each ,@if ,@is)                              ::  client IP
++  cred                                                ::  credential
          $:  hut=hoot                                  ::  client host
              aut=(jug ,@tas ,@t)                       ::  client identities
              orx=oryx                                  ::  CSRF secret
              acl=(unit ,@t)                            ::  accept-language
              cip=(each ,@if ,@is)                      ::  client IP
              cum=(map ,@tas ,*)                        ::  custom dirt
          ==                                            ::
++  cuff                                                ::  permissions
          $:  p=(unit (set monk))                       ::  readers
              q=(set monk)                              ::  authors
          ==                                            ::
++  deed  ,[p=@ q=step r=?]                             ::  sig, stage, fake?
++  dome                                                ::  project state
          $:  ang=agon                                  ::  pedigree
              ank=ankh                                  ::  state
              let=@ud                                   ::  top id
              hit=(map ,@ud tako)                       ::  changes by id
              lab=(map ,@tas ,@ud)                      ::  labels
          ==                                            ::
++  dore                                                ::  foreign contact
          $:  wod=road                                  ::  connection to
              wyl=will                                  ::  inferred mirror
              caq=clot                                  ::  symmetric key state
          ==                                            ::
++  dove  ,[p=@ud q=(map ,@ud ,@)]                      ::  count hash 13-blocks
++  epic                                                ::  FCGI parameters
          $:  qix=(map ,@t ,@t)                         ::  query
              ced=cred                                  ::  client credentials
              bek=beak                                  ::  path prefix
              but=path                                  ::  ending
              nyp=path                                  ::  request model
          ==                                            ::
++  flap  ,@uvH                                         ::  network packet id
++  flow                                                ::  packet connection
          $:  rtt=@dr                                   ::  decaying avg rtt
              wid=@ud                                   ::  logical wdow msgs
          ==                                            ::
++  fort                                                ::  formal state
          $:  %0                                        ::  version
              gad=duct                                  ::  client interface
              hop=@da                                   ::  network boot date
              ton=town                                  ::  security
              zac=(map ship corn)                       ::  flows by server
          ==                                            ::
++  frog  ,[p=@da q=nori]                               ::  time and change
++  gank  (each vase (list tank))                       ::  abstract result
++  gift                                                ::  one-way effect
          $%  [%$ p=vase]                               ::  trivial output
              [%cc p=(unit case)]                       ::  change case
              [%ck p=@tas]                              ::  change desk
              [%cs p=path]                              ::  change spur
              [%de p=@ud q=tank]                        ::  debug/level
              [%ex p=(unit vase) q=lath]                ::  exec/patch
            ::[%fd p=vase]                              ::  fundamental down
            ::[%fo p=vase]                              ::  fundamental forward
            ::[%fu p=vase]                              ::  fundamental up
              [%ha p=tank]                              ::  single error
              [%ho p=(list tank)]                       ::  multiple error
              [%la p=tank]                              ::  single statement
              [%lo p=(list tank)]                       ::  multiple statement
              [%mu p=type q=(list)]                     ::  batch emit
              [%mx p=(list gift)]                       ::  batch gift
              [%ok p=@ta q=nori]                        ::  save changes
              [%og p=@ta q=mizu]                        ::  save direct
              [%sc p=(unit skit)]                       ::  stack library
              [%sp p=(list lark)]                       ::  spawn task(s)
              [%sq p=ship q=@tas r=path s=*]            ::  send request
              [%sr p=ship q=path r=*]                   ::  send response
              [%te p=(list ,@t)]                        ::  dump lines
              [%th p=@ud q=love]                        ::  http response
              [%tq p=path q=hiss]                       ::  http request
              [%va p=@tas q=(unit vase)]                ::  set/clear variable
              [%xx p=curd]                              ::  return card
              [%xy p=path q=curd]                       ::  push card
              [%xz p=[p=ship q=term] q=ship r=mark s=zang]
              [%zz p=path q=path r=curd]                ::
          ==                                            ::
++  zang                                                ::  XX evil hack
          $%  [%backlog p=path q=?(%da %dr %ud) r=@]    ::
              [%hola p=path]                            ::
              $:  %mess  p=path                         ::
                $=  q                                   ::
              $%  [%do p=@t]                            ::  act
                  [%exp p=@t q=tank]                    ::  code
                  [%say p=@t]                           ::  speak
          ==  ==  ==                                    ::
++  gilt  ,[@tas *]                                     ::  presumed gift
++  gens  ,[p=lang q=gcos]                              ::  general identity
++  germ  ?(%init %fine %that %this %mate %meld)        ::  merge style
++  gcos                                                ::  id description
          $%  [%czar ~]                                 ::  8-bit ship
              [%duke p=what]                            ::  32-bit ship
              [%earl p=@t]                              ::  64-bit ship
              [%king p=@t]                              ::  16-bit ship
              [%pawn p=(unit ,@t)]                      ::  128-bit ship
          ==                                            ::
++  goad                                                ::  common note
          $%  [%eg p=riot]                              ::  simple result
              [%gr p=mark q=*]                          ::  gall rush/rust
              [%hp p=httr]                              ::  http response
              ::  [%ht p=@ud q=scab r=cred s=moth]          ::  http request
              [%it p=~]                                 ::  interrupt event
              [%lq p=ship q=path r=*]                   ::  client request
              [%ly p=newt q=tape]                       ::  lifecycle event
              [%ow p=cape]                              ::  one-way reaction
              [%rt p=(unit)]                            ::  roundtrip response
              [%up p=@t]                                ::  prompt response
              [%wa ~]                                   ::  alarm
          ==                                            ::
++  goal                                                ::  app request
          $%  [%$ p=type]                               ::  open for input
              [%do p=vase q=vase]                       ::  call gate sample
              [%eg p=kite]                              ::  single request
              [%es p=ship q=desk r=rave]                ::  subscription
              [%gr ~]                                   ::  gall response
              [%ht p=(list rout)]                       ::  http server
              [%hp ~]                                   ::  http response
              [%lq p=@tas]                              ::  listen for service
              [%ow ~]                                   ::  one-way reaction
              [%rt ~]                                   ::  roundtrip response
              [%up p=prod]                              ::  user prompt
              [%wa p=@da]                               ::  alarm
          ==                                            ::
++  govt  path                                          ::  country/postcode
++  hand  ,@uvH                                         ::  hash of code
++  hart  ,[p=? q=(unit ,@ud) r=host]                   ::  http sec/port/host
++  hate  ,[p=purl q=@p r=moth]                         ::  semi-cooked request
++  heir  ,[p=@ud q=mess r=(unit love)]                 ::  status/headers/data
++  hiss  ,[p=purl q=moth]                              ::  outbound request
++  hist  ,[p=@ud q=(list ,@t)]                         ::  depth texts
++  hole  ,@t                                           ::  session identity
++  hoot  ,[p=? q=(unit ,@ud) r=host]                   ::  secure/port/host
++  hort  ,[p=(unit ,@ud) q=host]                       ::  http port/host
++  host  $%([& p=(list ,@t)] [| p=@if])                ::  http host
++  httq                                                ::  raw http request
          $:  p=meth                                    ::  method
              q=@t                                      ::  unparsed url
              r=(list ,[p=@t q=@t])                     ::  headers
              s=(unit octs)                             ::  body
          ==                                            ::
++  httr  ,[p=@ud q=mess r=(unit octs)]                 ::  raw http response
++  httx                                                ::  encapsulated http
          $:  p=?                                       ::  https?
              q=clip                                    ::  source IP
              r=httq                                    ::
          ==                                            ::
++  kite  ,[p=care q=case r=ship s=desk t=spur]         ::  parsed global name
++  json                                                ::  normal json value
          $|  ~                                         ::  null
          $%  [%a p=(list json)]                        ::  array
              [%b p=?]                                  ::  boolean
              [%o p=(map ,@t json)]                     ::  object
              [%n p=@ta]                                ::  number
              [%s p=@ta]                                ::  string
          ==                                            ::
++  jsot                                                ::  strict json top
          $%  [%a p=(list json)]                        ::  array
              [%o p=(map ,@t json)]                     ::  object
          ==                                            ::
++  lamb                                                ::  short path
          $%  [& p=@tas]                                ::  auto
              [| p=twig]                                ::  manual
          ==                                            ::
++  lane                                                ::  packet route
          $%  [%if p=@da q=@ud r=@if]                   ::  IP4/public UDP/addr
              [%is p=@ud q=(unit lane) r=@is]           ::  IPv6 w/alternates
              [%ix p=@da q=@ud r=@if]                   ::  IPv4 provisional
          ==                                            ::
++  lang  ,@ta                                          ::  IETF lang as code
++  lark  ,[p=(unit ,@tas) q=lawn]                      ::  parsed command
++  lass  ?(%0 %1 %2)                                   ::  power increment
++  lath  $%                                            ::  pipeline stage
              [%0 p=lass q=lamb r=(list cone) s=twig]   ::  command
              [%1 p=twig]                               ::  generator
              [%2 p=twig]                               ::  filter
          ==                                            ::
++  lawn  (list lath)                                   ::
++  lice  ,[p=ship q=buck]                              ::  full license
++  life  ,@ud                                          ::  regime number
++  lint  (list rock)                                   ::  fragment array
++  lobe  ,@                                            ::  blob ref
++  love  $%                                            ::  http response
              [%ham p=manx]                             ::  html node
              [%mid p=mite q=octs]                      ::  mime-typed data
              [%raw p=httr]                             ::  raw http response
              [%wan p=wain]                             ::  text lines
              [%zap p=@ud q=(list tank)]                ::  status/error
          ==                                            ::
++  luge  ,[p=mark q=*]                                 ::  fully typed content
++  maki  ,[p=@ta q=@ta r=@ta s=path]                   ::
++  mace  (list ,[p=life q=ring])                       ::  private secrets
++  marv  ?(%da %tas %ud)                               ::  release form
++  math  (map ,@t (list ,@t))                          ::  semiparsed headers
++  meal                                                ::  payload
          $%  [%back p=cape q=flap r=@dr]               ::  acknowledgment
              [%bond p=life q=path r=@ud s=*]           ::  message
              [%carp p=@ q=@ud r=@ud s=flap t=@]        ::  skin/inx/cnt/hash
              [%fore p=ship q=(unit lane) r=@]          ::  forwarded packet
          ==                                            ::
++  mess  (list ,[p=@t q=@t])                           ::  raw http headers
++  meta                                                ::  path metadata
          $%  [& q=@uvI]                                ::  hash
              [| q=(list ,@ta)]                         ::  dir
          ==                                            ::
++  meth                                                ::  http methods
          $?  %conn                                     ::  CONNECT
              %delt                                     ::  DELETE
              %get                                      ::  GET
              %head                                     ::  HEAD
              %opts                                     ::  OPTIONS
              %post                                     ::  POST
              %put                                      ::  PUT
              %trac                                     ::  TRACE
          ==                                            ::
++  mite  (list ,@ta)                                   ::  mime type
++  miso                                                ::  ankh delta
          $%  [%del p=*]                                ::  delete
              [%ins p=*]                                ::  insert
              [%mut p=udon]                             ::  mutate
          ==                                            ::
++  mizu  ,[p=@u q=(map ,@ud tako) r=rang]              ::  new state
++  moar  ,[p=@ud q=@ud]                                ::  normal change range
++  moat  ,[p=case q=case]                              ::  change range
++  mood  ,[p=care q=case r=path]                       ::  request in desk
++  moth  ,[p=meth q=math r=(unit octs)]                ::  http operation
++  name  ,[p=@t q=(unit ,@t) r=(unit ,@t) s=@t]        ::  first mid/nick last
++  newt  ?(%boot %kick %mess %slay %wake)              ::  lifecycle events
++  nose                                                ::  response, kernel
          $?  [%$ p=(unit ,[p=tutu q=(list)])]          ::  standard input
              goad                                      ::
          ==                                            ::
++  note                                                ::  response, user
          $?  [%$ p=(unit ,[p=type q=(list)])]          ::  standard input
              [%do p=vase]                              ::  execution result
              goad                                      ::
          ==                                            ::
++  nori                                                ::  repository action
          $%  [& q=soba]                                ::  delta
              [| p=@tas]                                ::  label
          ==                                            ::
++  octs  ,[p=@ud q=@]                                  ::  octet-stream
++  oryx  ,@t                                           ::  CSRF secret
++  corn                                                ::  flow by server
          $:  hen=duct                                  ::  admin channel
              nys=(map flap bait)                       ::  packets incoming
              olz=(map flap cape)                       ::  packets completed
              wab=(map ship bath)                       ::  relationship
          ==                                            ::
++  pact  path                                          ::  routed path
++  pail  ?(%none %warm %cold)                          ::  connection status
++  plan  (trel view (pair ,@da (unit ,@dr)) path)      ::  subscription
++  plea  ,[p=@ud q=[p=? q=@t]]                         ::  live prompt
++  pork  ,[p=(unit ,@ta) q=(list ,@t)]                 ::  fully parsed url
++  pred  ,[p=@ta q=@tas r=@ta ~]                       ::  proto-path
++  prod  ,[p=prom q=tape r=tape]                       ::  prompt
++  prom  ?(%text %pass %none)                          ::  format type
++  purl  ,[p=hart q=pork r=quay]                       ::  parsed url
++  putt                                                ::  outgoing message
          $:  ski=snow                                  ::  sequence acked/sent
              wyv=(list rock)                           ::  packet list XX gear
          ==                                            ::
++  pyre                                                ::  cascade stash
          $:  p=(map ,[p=path q=path r=coal] coal)      ::  by path
              q=(map ,[p=path q=@uvI r=coal] coal)      ::  by source hash
              r=(map ,[p=* q=coal] coal)                ::  by (soft) twig
          ==                                            ::
++  quay  (list ,[p=@t q=@t])                           ::  parsed url query
++  quri                                                ::  request-uri
          $%  [& p=purl]                                ::  absolute
              [| p=pork q=quay]                         ::  relative
          ==                                            ::
++  race                                                ::  inbound stream
          $:  did=@ud                                   ::  filled sequence
              bum=(map ,@ud ,%dead)                     ::
              mis=(map ,@ud ,[p=cape q=flap r=(unit)])  ::  misordered
          ==                                            ::
++  rank  ?(%czar %king %duke %earl %pawn)              ::  ship width class
++  rang  $:  hut=(map tako yaki)                       ::
              lat=(map lobe blob)                       ::
          ==                                            ::
++  rant                                                ::  namespace binding
          $:  p=[p=care q=case r=@tas]                  ::  clade release book
              q=path                                    ::  spur
              r=*                                       ::  data
          ==                                            ::
++  rave                                                ::  general request
          $%  [& p=mood]                                ::  single request
              [| p=moat]                                ::  change range
          ==                                            ::
++  rill                                                ::  outbound stream
          $:  sed=@ud                                   ::  sent
              san=(map ,@ud duct)                       ::  outstanding
          ==                                            ::
++  riot  (unit rant)                                   ::  response/complete
++  road                                                ::  secured oneway route
          $:  exp=@da                                   ::  expiration date
              lun=(unit lane)                           ::  route to friend
              lew=will                                  ::  will of friend
          ==                                            ::
++  rock  ,@uvO                                         ::  packet
++  rout  ,[p=(list host) q=path r=oryx s=path]         ::  http route (new)
++  rump  ,[p=care q=case r=@tas s=path]                ::  relative path
++  saba  ,[p=ship q=@tas r=moar s=dome]                ::  patch/merge
++  sack  ,[p=ship q=ship]                              ::  incoming [our his]
++  sufi                                                ::  domestic host
          $:  hoy=(list ship)                           ::  hierarchy
              val=wund                                  ::  private keys
              law=will                                  ::  server will
              seh=(map hand ,[p=ship q=@da])            ::  key cache
              hoc=(map ship dore)                       ::  neighborhood
          ==                                            ::
++  salt  ,@uv                                          ::  entropy
++  seal                                                ::  auth conversation
          $:  whu=(unit ship)                           ::  client identity
              pul=purl                                  ::  destination url
              wit=?                                     ::  wait for partner
              foy=(unit ,[p=ship q=hole])               ::  partner to notify
              pus=(unit ,@ta)                           ::  password
          ==                                            ::
++  sect  ?(%black %blue %red %orange %white)           ::  banner
++  shed                                                ::  packet flow
          $:  $:  rtt=@dr                               ::  smoothed rtt
                  rto=@dr                               ::  retransmit timeout
                  rtn=(unit ,@da)                       ::  next timeout
                  rue=(unit ,@da)                       ::  last heard from
              ==                                        ::
              $:  nus=@ud                               ::  number sent
                  nif=@ud                               ::  number live
                  nep=@ud                               ::  next expected
                  caw=@ud                               ::  logical window
                  cag=@ud                               ::  congest thresh
              ==                                        ::
              $:  diq=(map flap ,@ud)                   ::  packets sent
                  pyz=(map soup ,@ud)                   ::  message/unacked
                  puq=(qeu ,[p=@ud q=soul])             ::  packet queue
              ==                                        ::
          ==                                            ::
++  skit  ,[p=(unit ,@ta) q=(list ,@ta) r=(list ,@ta)]  ::  tracking path
++  skin  ?(%none %open %fast %full)                    ::  encoding stem
++  slip  ,[p=path q=goal]                              ::  traceable request
++  snow  ,[p=@ud q=@ud r=(set ,@ud)]                   ::  window exceptions
++  soap  ,[p=[p=life q=life] q=path r=@ud]             ::  statement id
++  soup  ,[p=path q=@ud]                               ::  new statement id
++  soul                                                ::  packet in travel
          $:  gom=soup                                  ::  message identity
              nux=@ud                                   ::  xmission count
              liv=?                                     ::  deemed live
              lys=@da                                   ::  last sent
              pac=rock                                  ::  packet data
          ==                                            ::
++  soba  ,[p=cart q=(list ,[p=path q=miso])]           ::  delta
++  sock  ,[p=ship q=ship]                              ::  outgoing [from to]
++  spur  path                                          ::  ship desk case spur
++  step  ,[p=bray q=gens r=pass]                       ::  identity stage
++  tako  ,@                                            ::  yaki ref
++  tart  $+([@da path note] bowl)                      ::  process core
++  taxi  ,[p=lane q=rock]                              ::  routed packet
++  tick  ,@ud                                          ::  process id
++  toro  ,[p=@ta q=nori]                               ::  general change
++  town                                                ::  all security state
          $:  lit=@ud                                   ::  imperial modulus
              any=@                                     ::  entropy
              urb=(map ship sufi)                       ::  all keys and routes
              fak=?                                     ::
          ==                                            ::
++  tube  ,[p=@ta q=@ta r=@ta s=path]                   ::  canonical path
++  tutu  ,*                                            ::  presumed type
++  yaki  ,[p=(list tako) q=(map path lobe) r=tako t=@da] ::  commit
++  view  ?(%u %v %w %x %y %z)                          ::  view mode
++  waks  (map path woof)                               ::  list file states
++  what                                                ::  logical identity
          $%  [%anon ~]                                 ::  anonymous
              [%lady p=whom]                            ::  female person ()
              [%lord p=whom]                            ::  male person []
              [%punk p=sect q=@t]                       ::  opaque handle ""
          ==                                            ::
++  whom  ,[p=@ud q=govt r=sect s=name]                 ::  year/govt/id
++  woof  $|  %know                                     ::  udon transform
              [%chan (list $|(@ud [p=@ud q=@ud]))]      ::
++  wund  (list ,[p=life q=ring r=acru])                ::  mace in action
++  will  (list deed)                                   ::  certificate
++  worm  ,*                                            ::  vase of tart
++  zuse  %314                                          ::  hoon/zuse kelvin
--
