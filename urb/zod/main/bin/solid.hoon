!:
::  /=main=/bin/solid/hoon
::
=>  .(- `[who=@p how=path]`-)
|=  [est=time eny=@uw]
|=  arg=*
=+  ^=  lok  ^-  case
    ?:  =(~ arg)  [%da est]
    ?>  =(~ +.arg)
    ((hard case) -.arg)
=+  cav=(scot (dime lok))
=+  top=`path`[(scot %p who) %arvo cav ~]
=+  pax=`path`(weld top `path`[%hoon ~])
~&  %solid-start
=+  gen=(reck pax)
~&  %solid-parsed
=+  ken=q:(~(mint ut %noun) %noun gen)
~&  %solid-compiled
=+  ^=  all
    =+  all=.*(0 ken)
    =+  ^=  vay  ^-  (list ,[p=@tas q=@tas])
        :~  [%$ %zuse]
            [%f %ford]
            [%a %ames]
            [%b %batz]
            [%c %clay]
            [%d %dill]
            [%e %eyre]
            [%g %gall]
        ==
    |-  ^+  all
    ?~  vay  all
    =+  pax=(weld top `path`[q.i.vay ~])
    =+  txt=((hard ,@) .^(%cx (weld pax `path`[%hoon ~])))
    =+  sam=[est `ovum`[[%gold ~] [%veer p.i.vay pax txt]]]
    ~&  [%solid-veer i.vay]
    =+  gat=.*(all .*(all [0 42]))
    =+  nex=+:.*([-.gat [sam +>.gat]] -.gat)
    $(vay t.vay, all nex)
:_  ~  :_  ~
::  ~&  %solid-jamming
::  =+  pac=(jam [ken all])
::  ~&  %solid-finished
::  [%xx %save [%urbit %pill ~] pac]
[%xx %sage [%urbit %pill ~] [ken all]]
