/* j/6/fuse.c
**
** This file is in the public domain.
*/
#include "all.h"
#include "../pit.h"

/* logic
*/
  static u2_noun
  _fuse_in(u2_noun, u2_noun, u2_noun, u2_noun);

  static u2_noun
  _fuse_repo(
             u2_noun van,
             u2_noun sut,
             u2_noun ref,
             u2_noun bix)
  {
    u2_noun rep = u2_cqfu_repo(van, sut);
    u2_noun ret = _fuse_in(van, rep, ref, bix);

    if ( u2_yes == u2_cr_sing(ret, rep) ) {
      if ( c3__void == rep ) {
        return c3__void;
      } else {
        u2z(rep);
        u2z(ret);
        return u2k(sut);
      }
    } else {
      u2z(rep);
      return ret;
    }
  }

  static u2_noun
  _fuse_in(
           u2_noun van,
           u2_noun sut,
           u2_noun ref,
           u2_noun bix)
  {
    u2_noun p_sut, q_sut;

    if ( u2_yes == u2_cr_sing(sut, ref) || (c3__noun == ref) ) {
      return u2k(sut);
    }
    if ( u2_no == u2du(sut) ) switch ( sut ) {
      default: return u2_cm_bail(c3__fail);

      case c3__noun:
      {
        return u2k(ref);
      }
      case c3__void:
      {
        return c3__void;
      }
    }
    else switch ( u2h(sut) ) {
      default: return u2_cm_bail(c3__fail);

      case c3__atom:
      {
        if ( u2_yes == u2du(ref) ) {
          if ( c3__atom == u2h(ref) ) {
            if ( u2_yes == u2_cqf_fitz(u2t(ref), u2t(sut)) ) {
              return u2k(sut);
            } else return u2k(ref);
          }
          else if ( c3__cell == u2h(ref) ) {
            return c3__void;
          }
        }
        return _fuse_in(van, ref, sut, bix);
      }
      case c3__bull: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        u2_noun vot = _fuse_in(van, q_sut, ref, bix);
        u2_noun ret = u2_cqf_bull(p_sut, vot);

        u2z(vot);
        return ret;
      }
      case c3__cell: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        u2_noun p_ref, q_ref;

        if ( u2_yes == u2_cr_pq(ref, c3__cell, &p_ref, &q_ref) ) {
          u2_noun hed = _fuse_in(van, p_sut, p_ref, bix);
          u2_noun tal = _fuse_in(van, q_sut, q_ref, bix);
          u2_noun ret = u2_cqf_cell(hed, tal);

          u2z(hed);
          u2z(tal);
          return ret;
        }
        else return _fuse_in(van, ref, sut, bix);
      }
      case c3__core:
      {
        return _fuse_repo(van, sut, ref, bix);
      }
      case c3__cube: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        u2_noun foz = _fuse_in(van, q_sut, ref, bix);
        u2_noun ret;

        if ( u2_no == u2_cqfu_firm(van, foz, p_sut) ) {
          ret = c3__void;
        } else {
          ret = u2_cqf_cube(p_sut, foz);
        }
        u2z(foz);
        return ret;
      }
      case c3__face: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        u2_noun vot = _fuse_in(van, q_sut, ref, bix);
        u2_noun ret = u2_cqf_face(p_sut, vot);

        u2z(vot);
        return ret;
      }
      case c3__fork: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        u2_noun dis = _fuse_in(van, p_sut, ref, bix);
        u2_noun dat = _fuse_in(van, q_sut, ref, bix);
        u2_noun ret = u2_cqf_fork(dis, dat);

        u2z(dis);
        u2z(dat);
        return ret;
      }
      case c3__hold: p_sut = u2t(sut);
      {
        u2_noun hud = u2nc(u2k(sut), u2k(ref));

        if ( u2_yes == u2_cqdi_has(bix, hud) ) {
          //  u2_noun dun = u2_cqfu_dunq(van, "type", sut);
          //  u2_noun niz = u2_cqfu_dunq(van, "over", ref);

          //  u2_ct_push(u2nc(c3__mean, dun));
          //  u2_ct_push(u2nc(c3__mean, niz));

          return u2_cm_error("fuse-loop");
        } else {
          u2_noun bux = u2_cqdi_put(bix, hud);
          u2_noun ret = _fuse_repo(van, sut, ref, bux);

          u2z(hud);
          u2z(bux);
          return ret;
        }
      }
    }
  }

  u2_noun                                                         //  transfer
  j2_mcx(Pt6, ut, fuse)(
                        u2_noun van,                              //  retain
                        u2_noun sut,                              //  retain
                        u2_noun ref)                              //  retain
  {
    return _fuse_in(van, sut, ref, u2_nul);
  }

/* boilerplate
*/
  u2_ho_jet
  j2_mcj(Pt6, ut, fuse)[];

  u2_noun                                                         //  transfer
  j2_mc(Pt6, ut, fuse)(
                       u2_noun cor)                               //  retain
  {
    u2_noun sut, ref, van;

    if ( (u2_no == u2_cr_mean(cor, u2_cv_sam, &ref, u2_cv_con, &van, 0)) ||
         (u2_none == (sut = u2_cr_at(u2_cv_sam, van))) )
    {
      return u2_cm_bail(c3__fail);
    } else {
      return j2_mcx(Pt6, ut, fuse)(van, sut, ref);
    }
  }

  u2_noun                                                         //  transfer
  u2_cqfu_fuse(u2_noun van,                              //  retain
                        u2_noun sut,                              //  retain
                        u2_noun ref)                              //  retain
  {
    c3_m    fun_m = c3__fuse;
    u2_noun pro   = u2_cz_find_2(fun_m, sut, ref);

    if ( u2_none != pro ) {
      return pro;
    }
    else {
      pro = j2_mcx(Pt6, ut, fuse)(van, sut, ref);

      return u2_cz_save_2(fun_m, sut, ref, pro);
    }
  }

  u2_weak
  j2_mck(Pt6, ut, fuse)(u2_noun cor)
  {
    u2_noun sut, ref, van;

    if ( (u2_no == u2_cr_mean(cor, u2_cv_sam, &ref, u2_cv_con, &van, 0)) ||
         (u2_none == (sut = u2_cr_at(u2_cv_sam, van))) )
    {
      return u2_none;
    } else {
      return u2nc(u2k(sut), u2k(ref));
    }
  }

/* structures
*/
  u2_ho_jet
  j2_mcj(Pt6, ut, fuse)[] = {
    { ".2", c3__hevy,
        j2_mc(Pt6, ut, fuse),
        Tier6_b_memo,
        u2_none, u2_none,
        j2_mck(Pt6, ut, fuse), c3__fuse,
    },
    { }
  };
