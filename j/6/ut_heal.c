/* j/6/heal.c
**
** This file is in the public domain.
*/
#include "all.h"



/* internals
*/
  static u2_noun
  _heal_as(u2_noun, u2_noun, u2_noun, u2_atom, u2_noun);

  static u2_noun
  _heal_by(
           u2_noun van,
           u2_noun sut,
           u2_noun qog,
           u2_noun ref)
  {
    u2_noun p_sut, q_sut;

    if ( u2_no == u2du(sut) ) {
      return u2_cm_error("heal-name");
    }
    else switch ( u2h(sut) ) {
      default: return u2_cm_error("heal-name");

      case c3__core:
      {
        return u2k(ref);
      }
      case c3__bull: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        if ( u2_yes == u2_cr_sing(u2h(p_sut), u2t(qog)) ) {
          return u2k(ref);
        }
        else {
          u2_noun sub = _heal_by(van, q_sut, qog, ref);
          u2_noun ret;

          ret = u2_cqfu_busk
            (van, sub, u2h(p_sut), u2h(u2t(p_sut)));

          u2z(sub);
          return ret;
        }
      }
      case c3__face: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        if ( u2_yes == u2_cr_sing(p_sut, u2t(qog)) ) {
          return u2_cqf_face(p_sut, ref);
        }
        else return u2_cm_error("heal-name");
      }
      case c3__hold: {
        u2_noun rep = u2_cqfu_repo(van, sut);
        u2_noun ret = _heal_by(van, rep, qog, ref);

        u2z(rep);
        return ret;
      }
      case c3__fork: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        u2_noun dis = _heal_by(van, p_sut, qog, ref);
        u2_noun dat = _heal_by(van, q_sut, qog, ref);
        u2_noun ret = u2_cqf_fork(dis, dat);

        u2z(dis);
        u2z(dat);
        return ret;
      }
    }
  }

  static u2_noun
  _heal_to(
           u2_noun van,
           u2_noun sut,
           u2_noun gil,
           u2_noun qog,
           u2_noun ref,
           u2_atom now,
           u2_atom lat)
  {
    u2_noun p_sut, q_sut;

    if ( u2_no == u2du(sut) ) {
      goto repo;
    }
    else switch ( u2h(sut) ) {
      default: goto repo;

      case c3__atom: return c3__void;

      case c3__bull: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        u2_noun sub = _heal_to(van, q_sut, gil, qog, ref, now, lat);
        u2_noun ret;

        ret = u2_cqfu_busk
          (van, sub, u2h(p_sut), u2h(u2t(p_sut)));

        u2z(sub);
        return ret;
      }
      case c3__cell: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        u2_noun ter, ret;

        if ( 2 == now ) {
          ter = _heal_as(van, p_sut, qog, lat, ref);
          ret = u2_cqf_cell(ter, q_sut);
        } else {
          ter = _heal_as(van, q_sut, qog, lat, ref);
          ret = u2_cqf_cell(p_sut, ter);
        }
        u2z(ter);
        return ret;
      }

      case c3__core: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        if ( 3 != now ) {
          return u2_cm_error("heal-core");
        } else {
          u2_noun ter = _heal_as(van, p_sut, qog, lat, ref);
          u2_noun ret = u2_cqf_core(ter, q_sut);

          u2z(ter);
          return ret;
        }
      }
      case c3__face: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        u2_noun dun = _heal_to(van, q_sut, gil, qog, ref, now, lat);
        u2_noun ret = u2_cqf_face(p_sut, dun);

        u2z(dun);
        return ret;
      }
      case c3__fork: u2_cx_cell(u2t(sut), &p_sut, &q_sut);
      {
        u2_noun dis = _heal_to(van, p_sut, gil, qog, ref, now, lat);
        u2_noun dat = _heal_to(van, q_sut, gil, qog, ref, now, lat);
        u2_noun ret = u2_cqf_fork(dis, dat);

        u2z(dis);
        u2z(dat);
        return ret;
      }

      case c3__hold: {
        if ( (u2_yes == u2_cqdi_has(gil, sut)) ) {
          return c3__void;
        }
        else {
          u2_noun zoc = u2_cqdi_put(gil, sut);
          u2_noun rep = u2_cqfu_repo(van, sut);
          u2_noun ret = _heal_to(van, rep, zoc, qog, ref, now, lat);

          u2z(rep);
          u2z(zoc);

          return ret;
        }
      }
    }

    repo: {
      u2_noun rep = u2_cqfu_repo(van, sut);
      u2_noun ret = _heal_to(van, rep, gil, qog, ref, now, lat);

      u2z(rep);
      return ret;
    }
  }

  static u2_noun
  _heal_as(
           u2_noun van,
           u2_noun sut,
           u2_noun qog,
           u2_atom axe,
           u2_noun ref)
  {
    if ( 1 == axe ) {
      if ( u2_nul == qog ) {
        return u2k(ref);
      } else return _heal_by(van, sut, qog, ref);
    }
    else {
      u2_atom now = u2_cqc_cap(axe);
      u2_atom lat = u2_cqc_mas(axe);
      u2_noun ret = _heal_to(van, sut, u2_nul, qog, ref, now, lat);

      u2z(lat);
      return ret;
    }
  }

/* functions
*/
  u2_noun
  _cqfu_heal(
                        u2_noun van,
                        u2_noun sut,
                        u2_noun qog,
                        u2_noun axe,
                        u2_noun ref)
  {
    return _heal_as(van, sut, qog, axe, ref);
  }

/* boilerplate
*/
  u2_noun
  u2_cwfu_heal(
                       u2_noun cor)
  {
    u2_noun van, sut, qog, axe, ref;

    if ( (u2_no == u2_cr_mean(cor, u2_cv_sam_2, &qog,
                                u2_cv_sam_6, &axe,
                                u2_cv_sam_7, &ref,
                                u2_cv_con, &van,
                                0)) ||
         (u2_no == u2ud(axe)) ||
         (u2_none == (sut = u2_cr_at(u2_cv_sam, van))) )
    {
      return u2_cm_bail(c3__fail);
    } else {
      return _cqfu_heal(van, sut, qog, axe, ref);
    }
  }

  u2_noun
  u2_cqfu_heal(u2_noun van,
                        u2_noun sut,
                        u2_noun qog,
                        u2_noun axe,
                        u2_noun ref)
  {
    return _cqfu_heal(van, sut, qog, axe, ref);
  }
