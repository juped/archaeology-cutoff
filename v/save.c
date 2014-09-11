/* v/save.c
**
** This file is in the public domain.
*/
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>
#include <setjmp.h>
#include <gmp.h>
#include <stdint.h>
#include <termios.h>
#include <uv.h>

#include "all.h"
#include "v/vere.h"

/* _save_sign_cb: signal callback.
*/
static void
_save_sign_cb(uv_signal_t* sil_u, c3_i num_i)
{
  uL(fprintf(uH, "save: signal %d\n", num_i));
  {
    switch ( num_i ) {
      case SIGCHLD: u3_save_ef_chld(); break;
    }
  }
}

/* _save_time_cb(): timer callback.
*/
static void
_save_time_cb(uv_timer_t* tim_u, c3_i sas_i)
{
  u3_save* sav_u = &u3_Host.sav_u;

  if ( sav_u->pid_w ) {
    return;
  }

  if ( u3A->ent_d > sav_u->ent_d ) {
    // uL(fprintf(uH, "autosaving... ent_d %llu\n", u3A->ent_d));

    u3_cm_purge();
    // u3_lo_grab("save", u3_none);

#ifdef FORKPT
    c3_w pid_w;
    if ( 0 == (pid_w = fork()) ) {
      u3_loom_save(u3A->ent_d);
      exit(0);
    }
    else {
      uL(fprintf(uH, "checkpoint: process %d\n", pid_w));

      sav_u->ent_d = u3A->ent_d;
      sav_u->pid_w = pid_w;
    }
#else
    u3_loom_save(u3A->ent_d);
    sav_u->ent_d = u3A->ent_d;
#endif
  }
}

/* u3_save_ef_chld(): report save termination.
*/
void
u3_save_ef_chld(void)
{
  u3_save* sav_u = &u3_Host.sav_u;
  c3_i     loc_i;
  c3_w     pid_w;

  /* modified for cases with no pid_w
  */
  uL(fprintf(uH, "checkpoint: complete %d\n", sav_u->pid_w));
  pid_w = wait(&loc_i);
  if (0 != sav_u->pid_w) {
    c3_assert(pid_w == sav_u->pid_w);
  }
  else {
    c3_assert(pid_w > 0);
  }
  sav_u->pid_w = 0;
}

/* u3_save_io_init(): initialize autosave.
*/
void
u3_save_io_init(void)
{
  u3_save* sav_u = &u3_Host.sav_u;

  sav_u->ent_d = 0;
  sav_u->pid_w = 0;

  uv_timer_init(u3L, &sav_u->tim_u);
  uv_timer_start(&sav_u->tim_u, _save_time_cb, 15000, 15000);

  uv_signal_start(&sav_u->sil_u, _save_sign_cb, SIGCHLD);
}

/* u3_save_io_exit(): terminate save I/O.
*/
void
u3_save_io_exit(void)
{
}

/* u3_save_io_poll(): poll kernel for save I/O.
*/
void
u3_save_io_poll(void)
{
}
