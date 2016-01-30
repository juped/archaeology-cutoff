::    Subtree match finder
::
::::  /hook/hymn/match
  ::
/=  gas  /$  fuel                                       ::  get request info
/=  src  /:  /%/  /hoon/                                ::  current source file
::
::::  ~sondel-forsut
  ::
|%
++  conv  $&  [conv conv]
              [%0 @ub]
::
++  expr  $|  @tas
              (list expr)
--
::
::::
  ::
=+  `nock`*conv  :: extraneous typecheck
|%
++  build-from
  |=  [hay=expr man=expr]
  =|  axe=(list ?(%0 %1))                               ::  axis acummulator
  |-  ^-  (unit conv)
  ?:  =(man hay)
    [~ u=[%0 (join axe)]]
  ?@  hay  ~                                            ::  fail if hay is atom
  =+  top=$(hay -.hay, axe [%0 axe])
  ?^  top
    top                                                 ::  cell is success
  =+  bot=$(hay +.hay, axe [%1 axe])
  ?^  bot
    bot
  ?@  man                                               ::  descend unless atom
    ~
  =+  car=$(man -.man)
  ?~  car
    ~                                                   ::  lost head is failure
  =+  cdr=$(man +.man)
  ?~  cdr
    ~
  [~ u=[u.car u.cdr]]
::
++  join
  |=  axe=(list ?(%0 %1))  
  ^-  axis
  %+  reel  axe  |=  [a=?(%0 %1) b=_1]
  (add a (lsh 0 1 b))
::
++  fetch                                               ::  (unit expr) by term
  ;~  biff  
        ~(get by qix.gas)                               ::  get from query string
      slay                                              ::  parse as coin
    |=  con=coin
    ^-  (unit expr)
    ?-    -.con
        %$                                              ::  single atom
      ?.  ?=(%tas p.p.con)  ~
      [~ u=q.p.con]                                     ::  (some) if is term
        %blob                                           ::  noun literal, ignore
      ~
        %many                                           ::  list of coin
      (zl:jo (turn p.con ..$))                          ::  when-for
    ==
  ==
++  print  |=(a=expr ~(ram re (rend a)))
++  rend
  |=  a=expr
  ^-  tank
  ?~  a  [%leaf "()"]
  ?@  a  [%leaf (trip a)]
  [%rose [" " "(" ")"] (turn `(list expr)`a ..$)]
--
!:
::::
  ::
^-  manx
=+  hay=(fall (fetch %hay) %bad-expr)
=+  man=(fall (fetch %man) %bad-expr)
=+  res=(build-from hay man)
;html
  ;head
    ;title: Match
    ;*  =-  (turn `wall`- |=(a=tape ;script(type "text/javascript", src a);))
        :~  "//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js"
            "//cdnjs.cloudflare.com/ajax/libs/codemirror/4.3.0/codemirror.js"
            "/lib/syntax/hoon.js"
        ==
    ;link(rel "stylesheet", href "//cdnjs.cloudflare.com/ajax/libs/".
      "codemirror/4.3.0/codemirror.min.css");
    ;style:'''
           .CodeMirror {
             height: 100%
           }
           .cm-s-default .cm-atom {color: #70f}
           .cm-s-default .cm-operator {color: #097}
           
           #err {
             background: #fdd;
             display: none;
           }
           '''
  ==
  ;body
    ;h3: Tree transform generator
    ;p
      ; Problem and solution found 
      ;a/"http://michaelblume.tumblr.com/post/97793328216": here
    ==
    ;pre
      ; .=  ';{input#man(onchange "change()", value (print man))}
      ; .*  ';{input#hay(onchange "change()", value (print hay))}
      ;-  ?~  res  "!!  ::  no route"
          <u.res>
    ==
    ;p#err
      ; Malformed expression: a-z and - in identifiers, whitespace, and
      ; matched () are allowed
    ==
    ;script(type "text/ls")  ;-  %-  trip
      '''
      encode = (exp)->
        pars = (lev, str)->
          | str is /^\s+/  =>  pars lev, str - /^\s+/
          | str is /^[a-z-]+/
              tail = pars lev, str - (term = /^[a-z-]+/)
              if tail => {tail, tail.rest, lev, atom: str.match term .0 }
          | str is /^\(/
              head = pars lev+1, str - /./
              if head?rest?
                tail = pars lev, head.rest
                if tail => {head, tail, tail.rest, lev}
          | str is /^\)/ and lev > 0  =>  {lev, rest: str - /./}
          | str is '' and lev is 0  =>  true
          | _  =>  null

        esc = (lev)->
          unless lev > 1  =>  '_'
          else '~' * (2 ^ (lev - 2)) + '-'
        enc = (obj)->
          cab = esc obj?lev
          cabb = esc obj?lev + 1
          switch
          | !obj  =>  ''
          | !obj.tail  =>  cab
          | obj.atom  =>  obj.atom + cab + enc obj.tail
          | obj.head  =>  '.' + cabb + (enc obj.head) + cab + enc obj.tail

        (enc pars 0 exp) - /__$/

      @change = ->
        hav = (encode hay.value); mav   = (encode man.value)
        if hav and mav
          $ err .slideUp!
          window.location = 
            (window.location + '') - /\?.*/ + "?hay=#hav&man=#mav"
        else $ err .slideDown!
      '''
    ==
    ;script(src "//cdnjs.cloudflare.com/ajax/libs/".
      "livescript/1.2.0/livescript.min.js");
::    ;button(onclick "$(err).slideUp()");
    ;h3: Demo source
    ;textarea#src: {(trip src)}
    ;script:'''
            CodeMirror.fromTextArea(src, {lineNumbers:true, readOnly:true})
            '''
  ==
==
