//////////////////////////////////////////////////////////////////////////////////////////////
//qml.q - calling LAPACK from Q/KDB+
//        original copyright to https://github.com/zholos/qml
///
//

{x[0] set @[(`$getenv[`QHOME], "/qml") 2:;1_x;
    {'x}"qml: loading ",string[x 1],"(): ",]} each flip
    {(`$".qml." ,/: string r;`$"qml_",/:string r:raze x;where count each x)}

    1 2 3 4!(
            `sin`cos`tan`asin`acos`atan`sinh`cosh`tanh`asinh`acosh`atanh,`exp`expm1,
                `log`log10`logb`log1p`sqrt`cbrt`floor`ceil`fabs`erf`erfc,
                `lgamma`gamma`j0`j1`y0`y1`ncdf`nicdf`kcdf`kicdf,
                `mdet`minv`mevu`mchol`mqr`mqrp`mlup`msvd`mnoop`poly`const;
            `atan2`pow`hypot`fmod`beta`pgammar`pgammarc`ipgammarc`c2cdf`c2icdf,
                `stcdf`sticdf`pscdf`psicdf`smcdf`smicdf`mm`ms`mls`mlsq,
                `solve`min`root`mnoopx`dot;
            `pbetar`ipbetar`fcdf`ficdf`gcdf`gicdf`bncdf`bnicdf`mmx`mlsx`mlsqx,
                `solvex`minx`rootx`conmin`line;
            `conminx`linex);


.qml.pgamma:{.qml.gamma[x]*.qml.pgammar[x;y]};
.qml.pgammac:{.qml.gamma[x]*.qml.pgammarc[x;y]};
.qml.pbeta:{.qml.beta[x;y]*.qml.pbetar[x;y;z]};
.qml.diag:{@[count[x]#abs[type x]$0;;:;]'[til count x;x]};
.qml.mdim:{(count x;count x 0)};
.qml.mdiag:{(n#x)@'til n:min .qml.mdim x};
.qml.mrank:{sum not (d<.qml.eps*d[0]*max .qml.mdim x)|0=d:.qml.mdiag .qml.msvd[x]1};
.qml.mpinv:{.qml.mmx[`rflip;x 2] .qml.mm[x 0]
    ?'[(s=0)|s<.qml.eps*s[0;0]*max .qml.mdim s;s*0;reciprocal s:(x:.qml.msvd x)1]};
.qml.mev:{x@\:idesc sum each {x*x} first x:.qml.mevu x};
.qml.mkron:{raze(raze'')(flip')x*\:\:y};
