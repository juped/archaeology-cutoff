::
::::  /hoon/core/down/mar
  ::
/?    314
/-    *markdown
::
::::
  ::
//    /%/parse                       ::  inli donp parse
//    /%/rend                        ::  sing sung sang flat into-inner
::  ~%  %utyl  +>+>+>  ~
|_  don=down
++  grab                                                ::  convert from
  |%
  ++  md                                                ::  convert from %md
    =<  |=(src=@t (mark src))
    ~%  %utyl  ..is  ~
    ::~%  %utyl  +>+>+>+>  ~
    |%
    ++  mark
      ~/  %dawn
      |=  p=@t
      (normalize (rash p parse))
    --
  ++  noun  down                                        ::  clam from %noun
  --
::
++  grow                                                ::  convert into
  |%
  ++  hymn                                          ::  convert to %hymn
      ;html
        ;head:title:"Untitled"
        ;body
          ;*  (sing don)
        ==
      ==
  ++  psal                                          ::  convert to %psal
    ;div
      ;*  (sing don)
    ==
  ::  ++  react  psal
  --
--
