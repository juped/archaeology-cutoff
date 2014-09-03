/* j/6/flan.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"

/* functions
*/
  u2_noun                                                         //  transfer
  u2_cqf_flan(
                    u2_noun bos,                                  //  retain
                    u2_noun nif)                                  //  retain
  {
    if ( u2_yes == u2_cr_sing(1, u2h(bos)) ) {
      if ( (u2_nul == u2t(bos)) ) {
        return u2k(nif);
      }
      else return u2k(bos);
    }
    else {
      if ( u2_yes == u2_cr_sing(1, u2h(nif)) ) {
        if ( (u2_nul == u2t(nif)) ) {
          return u2k(bos);
        }
        else return u2k(nif);
      }
      else {
        return u2nq
          (6,
                  u2k(bos),
                  u2k(nif),
                  u2nc(1, u2_no));
      }
    }
  }
  u2_noun                                                         //  transfer
  u2_cwf_flan(
                   u2_noun cor)                                   //  retain
  {
    u2_noun bos, nif;

    if ( u2_no == u2_cr_mean(cor, u2_cv_sam_2, &bos, u2_cv_sam_3, &nif, 0) ) {
      return u2_cm_bail(c3__fail);
    } else {
      return u2_cqf_flan(bos, nif);
    }
  }
