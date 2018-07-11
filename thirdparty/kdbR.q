//////////////////////////////////////////////////////////////////////////////////////////////
//kdbR.q - calling R from Q/KDB+
///
//

.qr.R.close:{
    (.qr.R.priv.rserver 2:(`rclose;1)) 0
    };

.qr.R.open:{
    (.qr.R.priv.rserver 2:(`ropen;1)) 0
    };

.qr.R.eval:{
    (.qr.R.priv.rserver 2:(`rcmd;1)) x
    };

.qr.R.get:{
    (.qr.R.priv.rserver 2:(`rget;1)) x
    };

.qr.R.set:{
    (.qr.R.priv.rserver 2:(`rset;2)) [x;y]
    };

.qr.R.include:{
    .qr.R.eval "library(", "\"", x, "\")";
    };

.qr.R.install:{
    .qr.R.eval "install.packages(", "\"", x, "\")";
    };

.qr.R.init:{
    if[() ~ key `.qr.R.priv.rserver;
        .qr.R.priv.rserver:`$getenv[`QHOME], "rserver";
        ];
    };

.qr.R.init[];