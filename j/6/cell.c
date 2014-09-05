/* j/6/cell.c
**
** This file is in the public domain.
*/
#include "all.h"


/* functions
*/
  u3_noun
  u3_cqf_cell(
                    u3_noun hed,
                    u3_noun tal)
  {
    if ( (c3__void == hed) || (c3__void == tal) ) {
      return c3__void;
    } else {
      return u3nt(c3__cell, u3k(hed), u3k(tal));
    }
  }
  u3_noun
  u3_cwf_cell(
                   u3_noun cor)
  {
    u3_noun hed, tal;

    if ( u3_no == u3_cr_mean(cor, u3_cv_sam_2, &hed, u3_cv_sam_3, &tal, 0) ) {
      return u3_cm_bail(c3__fail);
    } else {
      return u3_cqf_cell(hed, tal);
    }
  }
