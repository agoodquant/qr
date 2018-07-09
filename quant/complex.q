//////////////////////////////////////////////////////////////////////////////////////////////
//complex.q - contains math function for complex number
///
//

.qr.complex.number:{
    `real`imaginary!x, y
    };

.qr.complex.isComplex:{
    $[99h <> type x; 0b; not (`real`imaginary) ~ key x; 0b; 1b]
    };

.qr.complex.toComplex:{[x]
    $[.qr.complex.isComplex[x]; x; `real`imaginary ! x, 0]
    };

.qr.complex.add:{
    .qr.complex.toComplex[x] + .qr.complex.toComplex[y]
    };

.qr.complex.minus:{
    .qr.complex.add[x;neg y]
    };

.qr.complex.multiply:{
    x:.qr.complex.toComplex[x];
    y:.qr.complex.toComplex[y];

    real:(x[`real] * y[`real]) - x[`imaginary] * y[`imaginary];
    imaginary:(x[`real] * y[`imaginary]) + x[`imaginary] * y[`real];

    .qr.complex.number[real;imaginary]
    };

.qr.complex.reciprocal:{
    x:.qr.complex.toComplex[x];
    modulous:(x[`real] * x[`real]) + x[`imaginary] * x[`imaginary];
    .qr.complex.number[x[`real] % modulous; neg x[`imaginary] % modulous]
    };

.qr.complex.divide:{
    x:.qr.complex.toComplex[x];
    y:.qr.complex.toComplex[y];

    .qr.complex.multiply[x;.qr.complex.reciprocal[y]]
    };

.qr.complex.exp:{
    (exp x[`real]) * .qr.complex.number[cos x[`imaginary]; sin x[`imaginary]]
    };

.qr.complex.sinh:{
    eX:.qr.complex.exp x;
    0.5 * eX - .qr.complex.reciprocal eX
    };

.qr.complex.cosh:{
    eX:.qr.complex.exp x;
    0.5 * eX + .qr.complex.reciprocal eX
    };

.qr.complex.tanh:{
    eX:.qr.complex.exp x;
    eNegX:.qr.complex.reciprocal eX;
    .qr.complex.divide[eX-eNegX; eX+eNegX]
    };

.qr.complex.coth:{
    eX:.qr.complex.exp x;
    eNegX:.qr.complex.reciprocal eX;
    .qr.complex.divide[eX+eNegX; eX-eNegX]
    };

.qr.complex.dft:{[yl;k]
    yl:.qr.complex.toComplex each yl;
    n:count yl;
    l:til n;
    w:2 * .qr.math.pi % n;
    expTerms:.qr.complex.exp each .qr.complex.number[0] each neg w*k*l;
    sum .qr.complex.multiply'[yl;expTerms]
    };

.qr.complex.idft:{[zk;l]
    yl:.qr.complex.toComplex each zk;
    n:count zk;
    k:til n;
    w:2 * .qr.math.pi % n;
    expTerms:.qr.complex.exp each .qr.complex.number[0] each w*k*l;
    sum .qr.complex.multiply'[zk;expTerms] % n
    };