/* j/6/look.c
**
** This file is in the public domain.
*/
#include "all.h"


/* internals
*/
  static u3_noun
  _look_in(
           u3_noun cog,
           u3_noun dab,
           u3_atom axe)
  {
    if ( u3_nul == dab ) {
      return u3_nul;
    }
    else {
      u3_noun n_dab, l_dab, r_dab;

      u3_cr_trel(dab, &n_dab, &l_dab, &r_dab);
      if ( c3n == u3du(n_dab) ) {
        return u3_cm_bail(c3__fail);
      }
      else {
        u3_noun pn_dab = u3h(n_dab);
        u3_noun qn_dab = u3t(n_dab);

        if ( (u3_nul == l_dab) && (u3_nul == r_dab) ) {
          if ( (c3y == u3du(qn_dab)) &&
               (c3y == u3_cr_sing(cog, pn_dab)) ) {
            return u3nt(u3_nul,
                                u3k(axe),
                                u3k(qn_dab));
          }
          else {
            return u3_nul;
          }
        }
        else if ( (u3_nul == l_dab) ) {
          if ( (c3y == u3du(qn_dab)) &&
               (c3y == u3_cr_sing(cog, pn_dab)) ) {
            return u3nt(u3_nul,
                                u3_cqc_peg(axe, 2),
                                u3k(qn_dab));
          }
          else {
            if ( c3y == u3_cqc_gor(cog, pn_dab) ) {
              return u3_nul;
            }
            else {
              u3_noun pro;

              axe = u3_cqc_peg(axe, 3);
              pro = _look_in(cog, r_dab, axe);
              u3z(axe);
              return pro;
            }
          }
        }
        else if ( (u3_nul == r_dab) ) {
          if ( (c3y == u3du(qn_dab)) &&
               (c3y == u3_cr_sing(cog, pn_dab)) ) {
            return u3nt(u3_nul,
                                u3_cqc_peg(axe, 2),
                                u3k(qn_dab));
          }
          else {
            if ( c3y == u3_cqc_gor(cog, pn_dab) ) {
              u3_noun pro;

              axe = u3_cqc_peg(axe, 3);
              pro = _look_in(cog, l_dab, axe);
              u3z(axe);
              return pro;
            }
            else {
              return u3_nul;
            }
          }
        }
        else {
          if ( (c3y == u3du(qn_dab)) &&
               (c3y == u3_cr_sing(cog, pn_dab)) ) {
            return u3nt(u3_nul,
                                u3_cqc_peg(axe, 2),
                                u3k(qn_dab));
          }
          else {
            if ( c3y == u3_cqc_gor(cog, pn_dab) ) {
              u3_noun pro;

              axe = u3_cqc_peg(axe, 6);
              pro = _look_in(cog, l_dab, axe);
              u3z(axe);
              return pro;
            }
            else {
              u3_noun pro;

              axe = u3_cqc_peg(axe, 7);
              pro = _look_in(cog, r_dab, axe);
              u3z(axe);
              return pro;
            }
          }
        }
      }
    }
  }


/* functions
*/
  u3_noun
  u3_cqf_look(
                    u3_noun cog,
                    u3_noun dab)
  {
    return _look_in(cog, dab, 1);
  }
  u3_noun
  u3_cwf_look(
                   u3_noun cor)
  {
    u3_noun cog, dab;

    if ( c3n == u3_cr_mean(cor, u3_cv_sam_2, &cog, u3_cv_sam_3, &dab, 0) ) {
      return u3_cm_bail(c3__fail);
    } else {
      return u3_cqf_look(cog, dab);
    }
  }
