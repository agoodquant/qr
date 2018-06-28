//////////////////////////////////////////////////////////////////////////////////////////////
//kdbR.q - calling R from Q/KDB+
///
//

.qr.R.close:{
    (`rserver 2:(`rclose;1)) 0
    };

.qr.R.open:{
    (`rserver 2:(`ropen;1)) 0
    };

.qr.R.eval:{
    (`rserver 2:(`rcmd;1)) x
    };

.qr.R.get:{
    (`rserver 2:(`rget;1)) x
    };

.qr.R.set:{
    (`rserver 2:(`rset;2)) [x;y]
    };

.qr.R.include:{
    .qr.R.eval "library(", "\"", x, "\")";
    };

.qr.R.install:{
    .qr.R.eval "install.packages(", "\"", x, "\")";
    };