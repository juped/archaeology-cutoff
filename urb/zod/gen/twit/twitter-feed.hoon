::  Display twitter feed
::
::::  /hook/core/twitter-feed/app
  ::
/+    sh-utils
!:
::
::::  ~fyr
  ::
|_  [hide ~]
++  stat  ,[id=@u who=@ta now=@da txt=@t]
++  rens
:-  %cat
  |=(stat rose/[": " `~]^~[leaf/"{<now>} @{(trip who)}" leaf/(trip txt)])
++  peer  ,_`.
++  poke--args  
  |=  [ost=bone his=ship who=span ~]
  %.(+< (add-subs [[our /twit] our /user/[who]] ,_`+>.$))
::
++  posh-twit-feed 
  (args-into-gate . |=(a=(list stat) tang/(turn a rens)))
:: ++  pour  |*([ost=@ * sih=[@ ^]] :_(+>.$ [ost %give +.sih]~))
--
