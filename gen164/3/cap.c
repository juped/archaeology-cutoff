/* j/3/cap.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"

/* functions
*/
  u2_noun
  u2_cqc_cap(
                   u2_atom a)
  {
    c3_w met_w = u2_cr_met(0, a);

    if ( met_w < 2 ) {
      return u2_cm_bail(c3__exit);
    }
    else if ( (1 == u2_cr_bit((met_w - 2), a)) ) {
      return 3;
    } else {
      return 2;
    }
  }
  u2_noun
  u2_cwc_cap(
                  u2_noun cor)
  {
    u2_noun a;

    if ( (u2_none == (a = u2_cr_at(u2_cv_sam, cor))) ||
         (u2_no == u2ud(a)) )
    {
      return u2_cm_bail(c3__exit);
    } else {
      return u2_cqc_cap(a);
    }
  }

