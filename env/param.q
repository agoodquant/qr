//////////////////////////////////////////////////////////////////////////////////////////////
//param.q - parameterized farmework
//

.qr.setParams:{
    .qr.priv.param:.Q.def[x].Q.opt .z.x;
    };

.qr.param:{
    (enlist x) ! enlist y
    };

.qr.getParam:{
    .qr.priv.param x
    };

.qr.listParam:{
    .qr.priv.param
    };