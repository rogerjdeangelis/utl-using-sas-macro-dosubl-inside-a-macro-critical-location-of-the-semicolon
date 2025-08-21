%let pgm=utl-using-sas-macro-dosubl-inside-a-macro-critical-location-of-the-semicolon;

%stop_submission;

Using sas macro dosubl inside a macro critical location of the semicolon

Problem create a macro with just macro code that provides the number of distinct vales of a sas variable;

SOAPBOX ON
 We need detailed documentation on dosubl and %dosubl?
 We do not know the number of self reported sexes before hand.
 The macro solution has many applications.
SOAPBOX OFF

CONTENTS
    1 this fails
    2 this works
    3 macro on end

PROBLEM

    HAVE            |  WANT

    NAME       SEX  |  NAME       SEX    B    F    M    U
                    |
    Alfred      M   |  Alfred      M     0    0    1    0
    John        M   |  John        M     0    0    1    0
    Alice       F   |  Alice       F     0    1    0    0
    Barbara     U   |  Barbara     U     0    0    0    1
    Carol       B   |  Carol       B     1    0    0    0


/**************************************************************************************************************************/
/* INPUT              |                                              |                                                    */
/*                    |                                              |                                                    */
/* NAME       SEX     | 1 THIS FAILS                                 | 583  +array sexs[                                  */
/*                    | (problem simicolon in ));&unqvar)            | 584  +;                                            */
/* Alfred      M      | =================================            |       -                                            */
/* John        M      |                                              |       22                                           */
/* Alice       F      | %deletesasmacn;                              |       76                                           */
/* Barbara     U      | %symdel unqvar / nowarn;                     | MPRINT(DEBUGA):   array sexs[ ;                    */
/* Carol       B      |                                              | 585  +4                                            */
/*                    | %macro utl_unqvar(dsn,var)                   |       -                                            */
/* data have;         |   / des="Return unique levels";              |       180                                          */
/*  input name$ sex$; |                                              |                                                    */
/* cards4;            |    %dosubl(%nrstr(                           | ERROR 180-322: Statement not valid                 */
/* Alfred  M          |       proc sql noprint;                      |                                                    */
/* John    M          |         select                               | 586  +] B F M U                                    */
/* Alice   F          |           count(distinct &var)               | 587  +;                                            */
/* Barbara U          |         into                                 | MPRINT(DEBUGA):   4 ] B F M U ;                    */
/* Carol   B          |           :unqvar trimmed                    |                                                    */
/* ;;;;               |         from                                 |                                                    */
/* run;quit;          |           &dsn                               |                                                    */
/*                    |         ;quit;                               |                                                    */
/*                    |       ));&unqvar                             |                                                    */
/*                    |                                              |                                                    */
/*                    | %mend utl_unqvar;                            |                                                    */
/*                    |                                              |                                                    */
/*                    | data want;                                   |                                                    */
/*                    |  set have;                                   |                                                    */
/*                    |  array sexs[%utl_unqvar(have,sex)]           |                                                    */
/*                    |       %utl_concat(have,var=sex,unique=Y);    |                                                    */
/*                    |  /*- MPRINT:array sexs[4] B F M U;-*/        |                                                    */
/*                    |  do idx=1 to dim1(sexs);                     |                                                    */
/*                    |   if sex=vname(sexs[idx]) then sexs[idx]=1;  |                                                    */
/*                    |   else sexs[idx]=0;                          |                                                    */
/*                    |  end;                                        |                                                    */
/*                    |  drop idx;                                   |                                                    */
/*                    | run;quit;                                    |                                                    */
/*                    |                                              |                                                    */
/*                    |---------------------------------------------------------------------------------------------------*/
/*                    | 2 THIS WORKS                                 | NAME       SEX    B    F    M    U                 */
/*                    | ============                                 |                                                    */
/*                    |                                              | Alfred      M     0    0    1    0                 */
/*                    | %deletesasmacn;                              | John        M     0    0    1    0                 */
/*                    | %symdel unqvar / nowarn;                     | Alice       F     0    1    0    0                 */
/*                    |                                              | Barbara     U     0    0    0    1                 */
/*                    | %macro utl_unqvar(dsn,var)                   | Carol       B     1    0    0    0                 */
/*                    |   / des="Return unique levels";              |                                                    */
/*                    |                                              |                                                    */
/*                    |    %dosubl(%nrstr(                           | MPRINT data want;                                  */
/*                    |       proc sql noprint;                      | MPRINT set have;                                   */
/*                    |         select                               | MPRINT set have;                                   */
/*                    |           count(distinct &var)               | MPRINT array sexs[ 4 ] B F M U ;                   */
/*                    |         into                                 | MPRINT do idx=1 to dim1(sexs);                     */
/*                    |           :unqvar trimmed                    | MPRINT if sex=vname(sexs[idx]) then sexs[idx]=1;   */
/*                    |         from                                 | MPRINT else sexs[idx]=0;                           */
/*                    |           &dsn                               | MPRINT end;                                        */
/*                    |         ;quit;                               | MPRINT drop idx;                                   */
/*                    |       ))&unqvar                              | MPRINT run;                                        */
/*                    |                                              |                                                    */
/*                    | %mend utl_unqvar;                            |                                                    */
/*                    |                                              |                                                    */
/*                    |                                              |                                                    */
/*                    | data want;                                   |                                                    */
/*                    |  set have;                                   |                                                    */
/*                    |  array sexs[%utl_unqvar(have,sex)]           |                                                    */
/*                    |       %utl_concat(have,var=sex,unique=Y);    |                                                    */
/*                    |  /*- MPRINT:array sexs[4] B F M U;-*/        |                                                    */
/*                    |  do idx=1 to dim1(sexs);                     |                                                    */
/*                    |    if sex=vname(sexs[idx]) then sexs[idx]=1; |                                                    */
/*                    |    else sexs[idx]=0;                         |                                                    */
/*                    |  end;                                        |                                                    */
/*                    |  drop idx;                                   |                                                    */
/*                    | run;quit;                                    |                                                    */
/**************************************************************************************************************************/

data have;
 input name$ sex$;
cards4;
Alfred  M
John    M
Alice   F
Barbara U
Carol   B
;;;;
run;quit;

/**************************************************************************************************************************/
/*  NAME       SEX                                                                                                        */
/*                                                                                                                        */
/* Alfred      M                                                                                                          */
/* John        M                                                                                                          */
/* Alice       F                                                                                                          */
/* Barbara     U                                                                                                          */
/* Carol       B                                                                                                          */
/**************************************************************************************************************************/

/*   _   _     _        __       _ _
/ | | |_| |__ (_)___   / _| __ _(_) |___
| | | __| `_ \| / __| | |_ / _` | | / __|
| | | |_| | | | \__ \ |  _| (_| | | \__ \
|_|  \__|_| |_|_|___/ |_|  \__,_|_|_|___/

*/
%deletesasmacn;
%symdel unqvar / nowarn;

%macro utl_unqvar(dsn,var)
  / des="Return unique levels";

   %dosubl(%nrstr(
      proc sql noprint;
        select
          count(distinct &var)
        into
          :unqvar trimmed
        from
          &dsn
        ;quit;
      ));&unqvar

%mend utl_unqvar;

data want;
 set have;
 array sexs[%utl_unqvar(have,sex)]
      %utl_concat(have,var=sex,unique=Y);
 /*- MPRINT:array sexs[4] B F M U;-*/
 do idx=1 to dim1(sexs);
  if sex=vname(sexs[idx]) then sexs[idx]=1;
  else sexs[idx]=0;
 end;
 drop idx;
run;quit;

/**************************************************************************************************************************/
/*  583  +array sexs[                                                                                                     */
/* 584  +;                                                                                                                */
/*       -                                                                                                                */
/*       22                                                                                                               */
/*       76                                                                                                               */
/* MPRINT(DEBUGA):   array sexs[ ;                                                                                        */
/* 585  +4                                                                                                                */
/*       -                                                                                                                */
/*       180                                                                                                              */
/*                                                                                                                        */
/* ERROR 180-322: Statement not valid                                                                                     */
/*                                                                                                                        */
/* 586  +] B F M U                                                                                                        */
/* 587  +;                                                                                                                */
/* MPRINT(DEBUGA):   4 ] B F M U ;                                                                                        */
/**************************************************************************************************************************/

/*___    _   _     _                          _
|___ \  | |_| |__ (_)___  __      _____  _ __| | _____
  __) | | __| `_ \| / __| \ \ /\ / / _ \| `__| |/ / __|
 / __/  | |_| | | | \__ \  \ V  V / (_) | |  |   <\__ \
|_____|  \__|_| |_|_|___/   \_/\_/ \___/|_|  |_|\_\___/

*/

%deletesasmacn;
%symdel unqvar / nowarn;

%macro utl_unqvar(dsn,var)
  / des="Return unique levels";

   %dosubl(%nrstr(
      proc sql noprint;
        select
          count(distinct &var)
        into
          :unqvar trimmed
        from
          &dsn
        ;quit;
      ))&unqvar

%mend utl_unqvar;

data want;
 set have;
 array sexs[%utl_unqvar(have,sex)]
      %utl_concat(have,var=sex,unique=Y);
 /*- MPRINT:array sexs[4] B F M U;-*/
 do idx=1 to dim1(sexs);
   if sex=vname(sexs[idx]) then sexs[idx]=1;
   else sexs[idx]=0;
 end;
 drop idx;
run;quit;

/**************************************************************************************************************************/
/*  NAME       SEX    B    F    M    U |  MPRINT data want;                                                               */
/*                                     |  MPRINT set have;                                                                */
/* Alfred      M     0    0    1    0  |  MPRINT set have;                                                                */
/* John        M     0    0    1    0  |  MPRINT array sexs[ 4 ] B F M U ;                                                */
/* Alice       F     0    1    0    0  |  MPRINT do idx=1 to dim1(sexs);                                                  */
/* Barbara     U     0    0    0    1  |  MPRINT if sex=vname(sexs[idx]) then sexs[idx]=1;                                */
/* Carol       B     1    0    0    0  |  MPRINT else sexs[idx]=0;                                                        */
/*                                     |  MPRINT end;                                                                     */
/*                                     |  MPRINT drop idx;                                                                */
/*                                     |  MPRINT run;                                                                     */
/**************************************************************************************************************************/

/*____         _   _
|___ /   _   _| |_| |   _   _ _ __   __ ___   ____ _ _ __  _ __ ___   __ _  ___ _ __ ___
  |_ \  | | | | __| |  | | | | `_ \ / _` \ \ / / _` | `__|| `_ ` _ \ / _` |/ __| `__/ _ \
 ___) | | |_| | |_| |  | |_| | | | | (_| |\ V / (_| | |   | | | | | | (_| | (__| | | (_) |
|____/   \__,_|\__|_|___\__,_|_| |_|\__, | \_/ \__,_|_|   |_| |_| |_|\__,_|\___|_|  \___/
                   |_____|             |_|
*/

filename ft15f001 "c:/oto/utl_unqvar.sas";
parmcards4;
%macro utl_unqvar(dsn,var)
  / des="Return unique levels";

   %dosubl(%nrstr(
      proc sql noprint;
        select
          count(distinct &var)
        into
          :unqvar trimmed
        from
          &dsn
        ;quit;
      ))&unqvar

%mend utl_unqvar;
;;;;
run;quit;

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
