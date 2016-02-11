/+    oauth2
::
::::
  ::
|%
++  user-state  ,[ber=token ref=refresh]:oauth2
++  suffix-email
  %+  cook  welp
  ;~  plug
    (star ;~(less pat prn))
    ;~(pose (plus prn) (easy "@gmail.com"))
  ==
::
++  auth-usr
  |=  usr=iden
  =+  lon=(fall (slaw %t usr) usr)
  =<  .(state-usr &)
  %-  oauth2
  =-  [[`/com/google/accounts /o/oauth2/v2/auth -] /oauth2/v4/token]
  :~  login-hint/?~(lon '' (crip (rash lon suffix-email)))
      access-type/%offline
      response-type/%code
  ==
--
!:
::::
  ::
|_  [bal=(bale keys:oauth2) user-state]
++  auth-re  ~(. (re:auth .) ref |=(a=_ref +>(ref a)))
++  auth  ~(. (auth-usr usr.bal) bal ~&((scopes 'userinfo.email' 'plus.me' ~) (scopes 'userinfo.email' 'plus.me' ~)))
++  scopes
  =+  scope=|=(b=@ta (endpoint:oauth2 dom.bal /auth/[b]))
  |=(a=(list ,@ta) ['https://mail.google.com' (turn a |=(b=@ta (crip (earn (scope b)))))])
::
++  out  (out-fix-expired:auth-re (out-math:auth ber))
++  res  |=(a=httr ~&(a/a ((res-handle-refreshed:auth-re save-access res-give:auth) a)))
++  save-access  |=(a=cord:[token:oauth2] +>(ber a))
::
++  in  
  |=  a=quay
  ~&  got-quay/a
  (in-code:auth a)
++  bak  |=(a=httr ~&(bak/a ((bak-save-tokens:auth-re save-access) a)))
++  upd  *user-state
::
--
