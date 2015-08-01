/* j/e/fl.c
**
*/
#include "all.h"

/* structures
*/
  typedef struct _flOptions {
    c3_w precision;
    mpz_t minExp;
    mpz_t expWidth;
    c3_w rMode;
    c3_w eMode;
  } flOptions;

  typedef struct _fn {
    c3_t s;
    mpz_t e;
    mpz_t a;
  } fn;

/* functions
*/
  static void
  _satom_to_mp(mpz_t a_mp, u3_atom b)
  {
    if ( _(u3a_is_cat(b)) ) {
      c3_ws c = (b + 1) >> 1;
      if ( (b & 1) ) {
        c = -c;
      }
      mpz_init_set_si(a_mp, c);
    }
    else {
      u3r_mp(a_mp, b);
      c3_t x = mpz_odd_p(a_mp);
      mpz_add_ui(a_mp, a_mp, 1);
      mpz_tdiv_q_2exp(a_mp, a_mp, 1);
      if ( x ) {
        mpz_neg(a_mp, a_mp);
      }
    }
  }

  static u3_noun
  _mp_to_satom(mpz_t a_mp)
  {
    c3_ws b = mpz_sgn(a_mp);
    switch ( b ) {
      default: return u3m_bail(c3__fail);
      case  0: {
        mpz_clear(a_mp);
        return 0;
      }
      case  1: {
        mpz_mul_2exp(a_mp, a_mp, 1);
        return u3i_mp(a_mp);
      }
      case -1: {
        mpz_abs(a_mp, a_mp);
        mpz_mul_2exp(a_mp, a_mp, 1);
        mpz_sub_ui(a_mp, a_mp, 1);
        return u3i_mp(a_mp);
      }
    }
  }

  static void
  _noun_to_flOptions(flOptions* a, u3_noun b)
  {
    u3_noun c;
    u3_atom d, e, f, g, h;
    u3x_trel(b, &c, &d, &e);
    u3x_trel(c, &f, &g, &h);

    mpz_t i;
    u3r_mp(i, f);
    if ( !mpz_fits_uint_p(i) ) {
      u3m_bail(c3__exit);
    }
    a->precision = mpz_get_ui(i);
    mpz_clear(i);

    _satom_to_mp(a->minExp, g);
    u3r_mp(a->expWidth, h);

    if ( !(_(u3a_is_cat(d)) && _(u3a_is_cat(e))) ) {
      u3m_bail(c3__exit);
    }
    a->rMode = d;
    a->eMode = e;
  }

  static void
  _noun_to_sea(fn* a, u3_noun b)
  {
    u3_atom c, d, e;
    u3x_trel(b, &c, &d, &e);

    if ( !(_(u3a_is_cat(d))) ) {
      u3m_bail(c3__exit);
    }

    a->s = _(c);
    _satom_to_mp(a->e, d);
    u3r_mp(a->a, e);
  }

  static u3_noun
  _sea_to_noun(fn* a)
  {
    u3_atom b = _mp_to_satom(a->e);
    u3_atom c = u3i_mp(a->a);

    return u3i_trel(__(a->s), u3k(b), u3k(c));
  }

  static void
  _xpd(fn* a, flOptions* b)
  {
    size_t z = mpz_sizeinbase(a->a, 2);
    if ( z >= b->precision ) return;
    c3_w c = b->precision - z;

    if ( b->eMode != c3__i ) {
      mpz_t i;
      mpz_init_set(i, a->e);
      mpz_sub(i, i, b->minExp);
      if ( mpz_sgn(i) < 0 ) {
        c = 0;
      }
      else if ( mpz_fits_uint_p(i) )
      {
        c3_w d = mpz_get_ui(i);
        c = c3_min(c, d);
      }
      mpz_clear(i);
    }

    mpz_mul_2exp(a->a, a->a, c);
    mpz_sub_ui(a->e, a->e, c);
  }

  static u3_noun
  _dragon4(u3_noun a, u3_noun b) {
    fn c;
    flOptions d;
    _noun_to_sea(&c, a);
    _noun_to_flOptions(&d, b);
    if ( mpz_sgn(c.a) == 0 ) {
      mpz_clear(c.e);
      mpz_clear(c.a);
      return u3nt(__(c.s), 0, 0);
    }
    _xpd(&c, &d);
    if ( !mpz_fits_sint_p(c.e) ) {
      u3m_bail(c3__exit);
    }
    mpz_t r, s, m, i, j, u, o;
    mpz_init_set(r, c.a);
    mpz_init_set_ui(s, 1);
    mpz_init_set_ui(m, 1);
    mpz_init(i);
    mpz_init(j);
    c3_w se = mpz_sgn(c.e);
    if ( se == 1 ) {
      mpz_mul_2exp(r, r, mpz_get_ui(c.e));
      mpz_mul_2exp(m, m, mpz_get_ui(c.e));
    }
    else if ( se == -1 ) {
      mpz_mul_2exp(s, s, mpz_get_ui(c.e));
    }
    mpz_cdiv_q_ui(i, s, 10);
    mpz_set_ui(c.e, 0);
    while ( mpz_cmp(r, i) < 0 ) {
      mpz_sub_ui(c.e, c.e, 1);
      mpz_mul_ui(r, r, 10);
      mpz_mul_ui(m, m, 10);
    }
    while ( 1 ) {
      mpz_mul_2exp(i, r, 1);
      mpz_add(i, i, m);
      mpz_mul_2exp(j, s, 1);
      if ( mpz_cmp(i, j) < 0 ) {
        break;
      }
      mpz_mul_ui(s, s, 10);
      mpz_add_ui(c.e, c.e, 1);
    }
    mpz_init(u);
    mpz_init_set_ui(o, 0);
    while ( 1 ) {
      mpz_sub_ui(c.e, c.e, 1);
      mpz_mul_ui(r, r, 10);
      mpz_mul_ui(m, m, 10);
      mpz_tdiv_qr(u, r, r, s);
      mpz_mul_2exp(i, r, 1);
      mpz_mul_2exp(j, s, 1);
      c3_t l = mpz_cmp(i, m) < 0;
      c3_t h = mpz_cmp(j, m) < 0;
      if ( !h ) {
        mpz_sub(j, j, m);
        h = mpz_cmp(i, j) > 0;
      }
      if ( l || h ) {
        mpz_mul_ui(o, o, 10);
        mpz_add(o, o, u);
        if ( h && (!l || (mpz_cmp(i, s) >= 0)) ) {
          mpz_add_ui(o, o, 1);
        }
        break;
      }
      mpz_mul_ui(o, o, 10);
      mpz_add(o, o, u);
    }
    mpz_set(c.a, o);
    mpz_clears(r, s, m, i, j, u, o, d.minExp, d.expWidth, 0);

    return _sea_to_noun(&c);
  }

  /* a: floating point number, b: flOptions */
  u3_noun
  u3qef_drg(u3_noun a, u3_noun b)
  {
    u3_noun c, d;
    u3x_cell(a, &c, &d); 

    switch ( c ) {
      default: return u3m_bail(c3__exit);
      case c3__i: {
        if (_(d)) {
          return u3nc(c3__i, c3y);
        } else {
          return u3nc(c3__i, c3n);
        }
      }
      case c3__n: {
        return u3nc(c3__n, u3_nul);
      }
      case c3__f: {
        u3_noun q = _dragon4(d,b);
        return u3nc(c3__d, u3k(q));
      }
    }
  }

  u3_noun
  u3wef_drg(u3_noun cor)
  {
    u3_noun a, b;
    a = u3x_at(u3x_sam, cor);
    b = u3x_at(62, cor);

    return u3qef_drg(a, b);
  }
