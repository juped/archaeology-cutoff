/* j/6/flay.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"

/* functions
*/
  static u2_noun
  _flay_roll(
             u2_noun quz)
  {
    if ( u2_no == u2du(quz) ) {
      return c3__void;
    } else {
      u2_noun voo = _flay_roll(u2t(quz));
      u2_noun oon = u2_cqf_fork(u2h(u2h(quz)), voo);

      u2z(voo);
      return oon;
    }
  }

  u2_noun
  u2_cqf_flay(
                    u2_noun pok)
  {
    u2_noun p_pok = u2h(pok);
    u2_noun q_pok = u2t(pok);
    u2_noun typ;

    switch ( u2h(q_pok) ) {
      default: return u2_cm_bail(c3__fail);

      case u2_yes: typ = u2k(u2t(q_pok));
                   break;
      case u2_no: typ = _flay_roll(u2t(u2t(q_pok)));
                  break;
    }
    return u2nc(u2k(p_pok), typ);
  }

  u2_noun
  u2_cwf_flay(
                   u2_noun cor)
  {
    u2_noun pok;

    if ( (u2_no == u2_cr_mean(cor, u2_cv_sam, &pok, 0)) ||
         (u2_no == u2du(pok)) ) {
      return u2_cm_bail(c3__fail);
    } else {
      return u2_cqf_flay(pok);
    }
  }
