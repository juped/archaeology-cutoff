!:
:::::::::   Appbug: a simple application.
::
|_  [hid=hide vat=[%0 p=@ud]]
++  poke
  |=  [ost=bone *]
  :_  +>(p.vat +(p.vat))
  :~  [ost %give %nice ~]
  ==
::
++  peek
  |=  [you=ship pax=path]
  :-  %hymn
  ^-  manx
  ;html
    ;head
      ;title: Appbug!
      ;script: appl = '{(trip app.hid)}'
    ==
    ;body
      ;p: Dude, a better answer is {<p.vat>}.
      ;button(onclick "bump()"): (Bump.)
      ;script
        ; var mess = 0;
        ;
        ; function bump() {
        ;   xhr = new XMLHttpRequest();
        ;   xhr.onload = function() { mess++; } 
        ;   xhr.open("PUT", "/tim/" + [user, port, mess].join("/"));
        ;   xhr.setRequestHeader("content-type", "text/json");
        ;   xhr.send(JSON.stringify({oryx: oryx, xyro: {appl: appl}}));
        ; }
      ==
    ==
  ==
--


