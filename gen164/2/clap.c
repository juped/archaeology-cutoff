/* j/2/clap.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"

/* functions
*/
  u2_weak                                                         //  transfer
  u2_cqb_clap(u2_noun a,                                    //  retain
                    u2_noun b,                                    //  retain
                    u2_noun c)                                    //  retain
  {
    if ( 0 == a ) {
      return u2k(b);
    }
    else if ( 0 == b ) {
      return u2k(a);
    }
    else {
      return u2nc(0, u2_cn_slam_on(u2k(c), u2nc(u2k(u2t(a)), u2k(u2t(b)))));
    }
  }
  u2_noun                                                         //  transfer
  u2_cwb_clap(u2_noun cor)                                   //  retain
  {
    u2_noun a, b, c;

    if ( u2_no == u2_cr_mean(cor, u2_cv_sam_2, &a,
                               u2_cv_sam_6, &b,
                               u2_cv_sam_7, &c, 0) ) {
      return u2_cm_bail(c3__exit);
    } else {
      return u2_cqb_clap(a, b, c);
    }
  }
