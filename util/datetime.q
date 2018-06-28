//////////////////////////////////////////////////////////////////////////////////////////////
//date.q - contains utility function for date
///
//

.qr.dt.yearSD:{
    "d"$12 xbar "m"$x
    };

.qr.dt.monthSD:{
    "d"$"m"$x
    };

.qr.dt.weekSD:{
    "d"$`week$x
    };

.qr.dt.weekDay:{
    y + .qr.dt.weekSD x
    };

.qr.dt.addHours:{
    x + "j"$y * 01:00:00.000000000
    };

.qr.dt.addMins:{
    x + "j"$y * 00:01:00.000000000
    };

.qr.dt.addSec:{
    x + "j"$y * 00:00:01.000000000
    };

.qr.dt.addMilliSec:{
    x + "j"$y * 00:00:00.000001000
    };

.qr.dt.toEST:{
    ltime x
    };

.qr.dt.toGMT:{
    gtime x
    };