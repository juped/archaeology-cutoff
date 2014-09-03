/* j/2/snag.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"

/* functions
*/
  u2_noun
  u2_cqb_snag(u2_atom a,
                    u2_noun b)
  {
    if ( u2_ne(u2_co_is_cat(a)) ) {
      return u2_cm_bail(c3__fail);
    }
    else {
      c3_w len_w = a;

      while ( len_w ) {
        if ( u2_no == u2du(b) ) {
          return u2_cm_bail(c3__exit);
        }
        b = u2t(b);
        len_w--;
      }
      if ( u2_no == u2du(b) ) {
        return u2_cm_bail(c3__exit);
      }
      return u2k(u2h(b));
    }
  }
  u2_noun
  u2_cwb_snag(u2_noun cor)
  {
    u2_noun a, b;

    if ( (u2_no == u2_cr_mean(cor, u2_cv_sam_2, &a, u2_cv_sam_3, &b, 0)) ||
         (u2_no == u2ud(a)) )
    {
      return u2_cm_bail(c3__exit);
    } else {
      return u2_cqb_snag(a, b);
    }
  }
