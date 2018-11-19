//////////////////////////////////////////////////////////////////////////////////////////////
//random.q - contains random number generator
///
//

/// discrete

.qr.rng.bernoulli:{[p;rng;n]
    p > rng n
    };

.qr.rng.bin:{[m;p;rng;n]
    sum each m cut .qr.rng.bernoulli[p;rng;m*n]
    };

.qr.rng.geo:{[p;rng;n]
    floor log[rng[n]] % log p
    };

.qr.rng.negBin:{[r;p;rng;n]
    sum each r cut .qr.rng.geo[p;rng;n*r]
    };

.qr.rng.poi:{[lambda;rng;n]
    trials:rng n;
    $[lambda<=500;
        binr[sums {[lambda;x] x, last[x]*lambda % 1|count[x]}[lambda]/[{x > sum y}[max trials];exp neg lambda]; trials];
        0 | .qr.dist.normal.cdfInv[lambda;sqrt lambda;trials] - 0.5 // 0.5 is continous correction
        ]
    };

/// continuous
.qr.rng.uniform:{[rng;n]
    rng[n]
    };

.qr.rng.exp:{[lambda;rng;n]
    neg (log .qr.rng.uniform[rng;n]) % lambda
    };

.qr.rng.normBM:{[u;sig;rng1;rng2;n]
    nHalf:.qr.math.ceil n * 0.5;
    u1:.qr.rng.uniform[rng1;nHalf];
    u2:.qr.rng.uniform[rng2;nHalf];
    u1Part:sqrt -2*log u1;
    u2Part:2*.qr.math.pi*u2;
    n#u+sig*(u1Part*cos u2Part), u1Part*sin u2Part
    };

.qr.rng.normBMP:{[u;sig;rng1;rng2;n]
    nHalf:.qr.math.ceil n * 0.5;
    u1:1-2*.qr.rng.uniform[rng1;nHalf];
    u2:1-2*.qr.rng.uniform[rng2;nHalf];
    s:(u1*u1)+u2*u2;
    f:(s > 0) and s < 1;
    u1: u1 where f;
    u2: u2 where f;
    s: s where f;
    s:sqrt -2 * log[s] % s;

    res:u+sig * (u1 * s), (u2 * s);
    $[0 <> resample:n-count[res]; res, .z.s[u;sig;rng1;rng2;(n-count[res])]; res]
    };

.qr.rng.normICDF:{[u;sig;rng;n]
    u:.qr.rng.uniform[rng;n];
    u + sig * .qr.dist.stdNormal.cdfInv u
    };

.qr.rng.logNorm:{[u;sig;rng1;rng2;n]
    exp .qr.rng.norm[u;sig;rng1;rng2;n]
    };

/// generalized method
.qr.rng.cdfStep:{[cdf;rng;n]
    cdf binr rng n
    };

/// random number generator
.qr.rng.rand:{[n]
    n?1.0
    };

.qr.rng.halton:{[b;n]
    k:floor(0.5+(log n+1) % log b);
    base:(1_til b) %/: b xexp 1 + til k;
    haltonSeq:raze {x, raze {y, x+y}[x] each y}/[base];
    n#haltonSeq
    };


/ .qr.rng.grayCode:{[k]
/     if[k <= neg 1 - count .qr.rng.grayCodeList;
/         :.qr.rng.grayCodeList[k];
/         ];

/     oldList:.qr.rng.grayCodeList;
/     newList: reverse oldList;
/     oldList:0b,/:oldList;
/     newList:1b,/:newList;
/     .qr.rng.grayCodeList:oldList, newList;
/     .qr.rng.grayCode k
/     };

/ .qr.rng.grayCodeList:(enlist enlist 0b), enlist enlist 1b;

/ .qr.rng.grayCodeTil:{[k]
/     if[k > neg 1 - count .qr.rng.grayCodeList;
/         .qr.rng.grayCode[k];
/         ];

/     k#.qr.rng.grayCodeList
/     };