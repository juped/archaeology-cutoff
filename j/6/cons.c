/* j/6/cons.c
**
** This file is in the public domain.
*/
#include "all.h"


/* functions
*/
  u3_noun
  u3_cqf_cons(
                    u3_noun vur,
                    u3_noun sed)
  {
    u3_noun p_vur, p_sed;

    if ( u3_yes == u3_cr_p(vur, 1, &p_vur) &&
         u3_yes == u3_cr_p(sed, 1, &p_sed) ) {
      return u3nt(1,
                          u3k(p_vur),
                          u3k(p_sed));
    }
    else if ( u3_yes == u3_cr_p(vur, 0, &p_vur) &&
              u3_yes == u3_cr_p(sed, 0, &p_sed) &&
              !(u3_yes == u3_cr_sing(1, p_vur)) &&
              !(u3_yes == u3_cr_sing(p_vur, p_sed)) &&
              (0 == u3_cr_nord(p_vur, p_sed)) )
    {
      u3_atom fub = u3_cqa_div(p_vur, 2);
      u3_atom nof = u3_cqa_div(p_sed, 2);

      if ( u3_yes == u3_cr_sing(fub, nof) ) {
        u3z(nof);

        return u3nc(0, fub);
      }
      else {
        u3z(fub);
        u3z(nof);
      }
    }
    return u3nc(u3k(vur), u3k(sed));
  }
  u3_noun
  u3_cwf_cons(
                   u3_noun cor)
  {
    u3_noun vur, sed;

    if ( u3_no == u3_cr_mean(cor, u3_cv_sam_2, &vur, u3_cv_sam_3, &sed, 0) ) {
      return u3_cm_bail(c3__fail);
    } else {
      return u3_cqf_cons(vur, sed);
    }
  }
