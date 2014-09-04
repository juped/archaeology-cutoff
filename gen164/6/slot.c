/* j/6/slot.c
**
** This file is in the public domain.
*/
#include "all.h"


/* functions
*/
  u2_noun
  u2_cqf_slot(u2_atom axe, u2_noun vax)
  {
    u2_noun fag = u2_cr_at(axe, u2t(vax));

    fprintf(stderr, "slot axe %d\r\n", axe);

    if ( u2_none == fag ) {
      return u2_cm_bail(c3__exit);
    }
    else {
      u2_noun typ = u2_cqfu_peek(
    }
    c3_w i_w, met_w = c3_min(u2_cr_met(3, axe), u2_cr_met(3, vax));

    if ( u2_no == _slot_fiz(axe, vax) ) {
      return u2_no;
    }
    for ( i_w = 0; i_w < met_w; i_w++ ) {
      c3_y axe_y = u2_cr_byte(i_w, axe);
      c3_y vax_y = u2_cr_byte(i_w, vax);

      if ( (axe_y >= 'A') && (axe_y <= 'Z') ) axe_y = 0;
      if ( (vax_y >= 'A') && (vax_y <= 'Z') ) vax_y = 0;

      if ( axe_y && vax_y && (axe_y != vax_y) ) {
        return u2_no;
      }
    }
    return u2_yes;
  }

  u2_noun
  u2_cwe_slot(u2_noun cor)
  {
    u2_noun axe, vax;

    if ( (u2_no == u2_cr_mean(cor, u2_cv_sam_2, &axe, u2_cv_sam_3, &vax, 0)) ||
         (u2_no == u2ud(axe)) ||
         (u2_no == u2du(vax)) )
    {
      return u2_cm_bail(c3__fail);
    } else {
      return u2_cqf_slot(axe, vax);
    }
  }
