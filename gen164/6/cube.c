/* j/6/cube.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"

/* functions
*/
  u2_noun                                                         //  transfer
  u2_cqf_cube(
                    u2_noun dil,                                  //  retain
                    u2_noun goq)                                  //  retain
  {
    if ( c3__void == goq ) {
      return c3__void;
    }
    else return u2nt
      (c3__cube, u2k(dil), u2k(goq));
  }
  u2_noun                                                         //  transfer
  u2_cwf_cube(
                   u2_noun cor)                                   //  retain
  {
    u2_noun dil, goq;

    if ( u2_no == u2_cr_mean(cor, u2_cv_sam_2, &dil, u2_cv_sam_3, &goq, 0) ) {
      return u2_cm_bail(c3__fail);
    } else {
      return u2_cqf_cube(dil, goq);
    }
  }
