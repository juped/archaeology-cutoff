/* j/6/bull.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"

/* functions
*/
  u2_noun
  u2_cqf_bull(
                    u2_noun bid,
                    u2_noun der)
  {
    if ( (c3__void == der) ||
         (c3__void == u2t(u2t(u2t(bid)))) )
    {
      return c3__void;
    }
    else return u2nt
      (c3__bull, u2k(bid), u2k(der));
  }
  u2_noun
  u2_cwf_bull(
                   u2_noun cor)
  {
    u2_noun bid, der;

    if ( u2_no == u2_cr_mean(cor, u2_cv_sam_2, &bid, u2_cv_sam_3, &der, 0) ) {
      return u2_cm_bail(c3__fail);
    } else {
      return u2_cqf_bull(bid, der);
    }
  }
