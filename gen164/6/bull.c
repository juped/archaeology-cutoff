/* j/6/bull.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"

/* functions
*/
  u2_noun                                                         //  transfer
  j2_mby(Pt6, bull)(
                    u2_noun bid,                                  //  retain
                    u2_noun der)                                  //  retain
  {
    if ( (c3__void == der) ||
         (c3__void == u2t(u2t(u2t(bid)))) )
    {
      return c3__void;
    }
    else return u2nt
      (c3__bull, u2k(bid), u2k(der));
  }
  u2_noun                                                         //  transfer
  j2_mb(Pt6, bull)(
                   u2_noun cor)                                   //  retain
  {
    u2_noun bid, der;

    if ( u2_no == u2_cr_mean(cor, u2_cv_sam_2, &bid, u2_cv_sam_3, &der, 0) ) {
      return u2_cm_bail(c3__fail);
    } else {
      return j2_mby(Pt6, bull)(bid, der);
    }
  }

/* structures
*/
  u2_ho_jet
  j2_mbj(Pt6, bull)[] = {
    { ".2", c3__hevy, j2_mb(Pt6, bull), Tier6_a, u2_none, u2_none },
    { }
  };
