//////////////////////////////////////////////////////////////////////////////////////////////
//binary.q - contains math function
///
//

.qr.bit.xor:{
    x <> y
    };

.qr.bit.or:{
    x or y
    };

.qr.bit.and:{
    x and y
    };

.qr.bit.shiftLeft:{
    (neg count x)#x, y#0b
    };

.qr.bit.shiftRight:{
    (count x)# (y#0b), x
    };