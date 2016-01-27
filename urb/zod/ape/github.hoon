::  This is a command-line ui for the %gh Github driver.
::
::  Usage:
::    :github &path /read-unauth{/endpoint}
::    :github &path /read-auth{/endpoint}
::    :github &path /listen/{owner}/{repo}/{events...}
::
/-  gh
!:
=>  |%
    ++  diff-result
      $%  [%gh-issue issues:gh]
          [%gh-issue-comment issue-comment:gh]
      ==
    --
|_  [hid=bowl *]
++  poke-path
  |=  pax=path
  :_  +>.$  :_  ~
  [ost.hid %peer /into-the-mist [our.hid %gh] scry/x/pax]
++  diff-gh-issues
  |=  [way=wire issues:gh]
  %-  %-  slog  :~
        leaf/"in repository {(trip login.owner.repository)}/{(trip name.repository)}:"
        leaf/"{(trip login.sender)} {(trip -.action)} issue #{<number.issue>} {<title.issue>}"
        ?+    -.action  *tank
            ?(%assigned %unassigned)
          leaf/"to {(trip login.assignee.action)}"
            ?(%labeled %unlabeled)
          leaf/"with {(trip name.label.action)}"
        ==
      ==
  [~ +>.$]
++  diff-gh-issue-comment
  |=  [way=wire issue-comment:gh]
  %-  %-  slog  :~
        leaf/"in repository {(trip login.owner.repository)}/{(trip name.repository)}:"
        leaf/"{(trip login.sender)} commented on issue #{<number.issue>} {<title.issue>}:"
        leaf/(trip body.comment)
      ==
  [~ +>.$]
++  peek
  |=  [ren=@tas tyl=path]
  ^-  (unit (unit (pair mark ,*)))
  ``noun/[ren tyl]
--
