::
::::
  ::
/=    gas  /$  fuel
::
/=    talk-body  /:  /===/pub=/talk/body  /!elem/
/=    talk-nav   /:  /===/pub=/talk/nav   /!elem/
/=    tree-body  /:  /===/pub=/tree/body  /elem/
/=    tree-nav   /:  /===/pub=/tree/nav   /!elem/
::
=+  ^=  type  (fall (~(get by qix.gas) %type) 'tree')
=+  ^=  body  ?:  =(type 'tree')  tree-body  talk-body
=+  ^=  nav   ?:  =(type 'tree')  tree-nav   talk-nav
::
^-  manx
::
;html
  ;head
    ;title: Bootstrap Test - ~2016.1
    ;meta(name "viewport", content "width=device-width, initial-scale=1");
    ;link(rel "stylesheet", href "/lib/css/fonts.css");
    ;link(rel "stylesheet", href "/lib/css/bootstrap.css");
    ;script(src "//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.js");
  ==
  ;body
    ;div.container.nav
      ;+  nav
    ==
    ;div.container
      ;div.row
        ;div.col-md-10.col-md-offset-2.body
          ;+  body
        ==
      ==
    ==
    ;script(type "text/javascript"):'''
                                    $(function() {
                                      $('.navbar-toggler').click(function() {
                                          $('.navbar-toggler').toggleClass('open')
                                          $('.ctrl').toggleClass('open')
                                          if($('.navbar-toggler').hasClass('show'))
                                            $('.menu.depth-1').toggleClass('open')
                                        })
                                      $('.room').click(
                                        function() {
                                          $('.menu.depth-2').toggleClass('open')
                                          })
                                    })
                                    '''
  ==
==
