/* j/2/reel.c
**
** This file is in the public domain.
*/
#include "all.h"


/* functions
*/
  u3_noun
  u3_cqb_reel(
                    u3_noun a,
                    u3_noun b)
  {
    if ( 0 == a ) {
      return u3k(u3_cr_at(u3_cv_sam_3, b));
    }
    else if ( u3_no == u3du(a) ) {
      return u3_cm_bail(c3__exit);
    }
    else {
      u3_noun gim = u3k(u3h(a));
      u3_noun hur = u3_cqb_reel(u3t(a), b);

      return u3_cn_slam_on(u3k(b), u3nc(gim, hur));
    }
  }
  u3_noun
  u3_cwb_reel(
                   u3_noun cor)
  {
    u3_noun a, b;

    if ( u3_no == u3_cr_mean(cor, u3_cv_sam_2, &a, u3_cv_sam_3, &b, 0) ) {
      return u3_cm_bail(c3__exit);
    } else {
      return u3_cqb_reel(a, b);
    }
  }
