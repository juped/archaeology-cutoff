/* j/6/fish.c
**
** This file is in the public domain.
*/
#include "all.h"


/* functions
*/
  static u3_noun
  _fish_in(
           u3_noun van,
           u3_noun sut,
           u3_atom axe,
           u3_noun vit)
  {
    u3_noun p_sut, q_sut;

    if ( c3y == u3ud(sut) ) switch ( sut ) {
      default: return u3_cm_bail(c3__fail);

      case c3__noun: {
        return u3nc(1, 0);
      }
      case c3__void: {
        return u3nc(1, 1);
      }
    }
    else switch ( u3h(sut) ) {
      default: return u3_cm_bail(c3__fail);

      case c3__atom: {
        u3_noun ton = u3nt(3, 0, u3k(axe));
        u3_noun pro = u3_cqf_flip(ton);

        u3z(ton);
        return pro;
      }
      case c3__bull: {
        return u3_cm_error("bull-fish");
      }
      case c3__cell: {
        if ( (c3n == u3_cr_trel(sut, 0, &p_sut, &q_sut)) ) {
          return u3_cm_bail(c3__fail);
        } else {
          u3_noun hut = u3nt(3, 0, u3k(axe));
          u3_noun lef = u3_cqc_peg(axe, 2);
          u3_noun rit = u3_cqc_peg(axe, 3);
          u3_noun hed = _fish_in(van, p_sut, lef, vit);
          u3_noun tal = _fish_in(van, q_sut, rit, vit);
          u3_noun hob = u3_cqf_flan(hed, tal);
          u3_noun vug = u3_cqf_flan(hut, hob);

          u3z(hob);
          u3z(tal);
          u3z(hed);
          u3z(rit);
          u3z(lef);
          u3z(hut);

          return vug;
        }
      }
      case c3__core: {
        return u3nc(0, 0);
      }
      case c3__cube: {
        if ( (c3n == u3_cr_trel(sut, 0, &p_sut, &q_sut)) ) {
          return u3_cm_bail(c3__fail);
        } else {
          return u3nt
            (5,
                    u3nc(1, u3k(p_sut)),
                    u3nc(0, u3k(axe)));
        }
      }
      case c3__face: {
        if ( (c3n == u3_cr_trel(sut, 0, &p_sut, &q_sut)) ) {
          return u3_cm_bail(c3__fail);
        } else {
          return _fish_in(van, q_sut, axe, vit);
        }
      }
      case c3__fork: {
        if ( (c3n == u3_cr_trel(sut, 0, &p_sut, &q_sut)) ) {
          return u3_cm_bail(c3__fail);
        }
        else {
          u3_noun hed = _fish_in(van, p_sut, axe, vit);
          u3_noun tal = _fish_in(van, q_sut, axe, vit);
          u3_noun pro = u3_cqf_flor(hed, tal);

          u3z(hed);
          u3z(tal);

          return pro;
        }
      }
      case c3__hold: {
        p_sut = u3t(sut);
        {
          if ( (c3y == u3_cqdi_has(vit, sut)) ) {
            //  u3_noun dun = u3_cqfu_dunq(van, "type", sut);
            u3_noun niz = u3_cqfu_shep
              (van, "axis", 'd', u3k(axe));

            //  u3_ct_push(u3nc(c3__mean, dun));
            u3_ct_push(u3nc(c3__mean, niz));

            return u3_cm_error("fish-loop");
          } else {
            u3_noun zoc = u3_cqdi_put(vit, sut);
            u3_noun fop = u3_cqfu_rest(van, sut, p_sut);
            u3_noun pro = _fish_in(van, fop, axe, zoc);

            u3z(fop);
            u3z(zoc);

            return pro;
          }
        }
      }
    }
  }
  u3_noun
  _cqfu_fish(
                        u3_noun van,
                        u3_noun sut,
                        u3_atom axe)
  {
    return _fish_in(van, sut, axe, u3_nul);
  }


/* boilerplate
*/
  u3_noun
  u3_cwfu_fish(
                       u3_noun cor)
  {
    u3_noun sut, axe, van;

    if ( (c3n == u3_cr_mean(cor, u3_cv_sam, &axe, u3_cv_con, &van, 0)) ||
         (c3n == u3ud(axe)) ||
         (c3nne == (sut = u3_cr_at(u3_cv_sam, van))) )
    {
      return u3_cm_bail(c3__fail);
    } else {
      return _cqfu_fish(van, sut, axe);
    }
  }

  u3_noun
  u3_cqfu_fish(u3_noun van,
                        u3_noun sut,
                        u3_noun axe)
  {
    c3_m    fun_m = c3__fish;
    u3_noun pro   = u3_cz_find_2(fun_m, sut, axe);

    if ( c3nne != pro ) {
      return pro;
    }
    else {
      pro = _cqfu_fish(van, sut, axe);

      return u3_cz_save_2(fun_m, sut, axe, pro);
    }
  }
