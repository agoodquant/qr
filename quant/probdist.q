//////////////////////////////////////////////////////////////////////////////////////////////
//probdist.q - contains functions for probability distribution
///
//


///////////////////////////////
//discrete
///////////////////////////////

.qr.dist.poisson.pdf:{[lambda;x]
    .qr.dist.priv.poisson[lambda;x] x
    };

.qr.dist.poisson.cdf:{[lambda;x]
    (sums .qr.dist.priv.poisson[lambda;x]) x
    };

.qr.dist.priv.poisson:{[lambda;x]
    m:max x;
    exp[neg lambda] * 1.0, prds (m#lambda) % 1 + til m
    };

.qr.dist.bin.pdf:{[n;p;x]
    .qr.dist.priv.bin[n;p;x] x
    };

.qr.dist.bin.cdf:{[n;p;x]
    (sums .qr.dist.priv.bin[n;p;x]) x
    };

// binomial pdf generator
.qr.quatn.dist.priv.bin:{[n;p;x]
    m:max x;
    X:1 + til m;
    N:reverse X+(n-m);
    ((1-p) xexp n) * 1.0, (prds m#p % (1-p)) * prds N % X
    };

.qr.dist.bernoulli.pdf:.qr.dist.bin.pdf[1];
.qr.dist.bernoulli.cdf:.qr.dist.bin.cdf[1];

.qr.dist.negBin.pdf:{[r;p;x]
    .qr.dist.priv.negBin[r;p;x] x
    };

.qr.dist.negBin.cdf:{[r;p;x]
    (sums .qr.dist.priv.negBin[r;p;x]) x
    };

.qr.dist.priv.negBin:{[r;p;x]
    m:max x;
    X:1 + til m;
    N:X+r-1;
    ((1-p) xexp r) * 1.0, prds[m#p] * prds N % X
    };

.qr.dist.geo.pdf:.qr.dist.negBin.pdf[1];
.qr.dist.geo.cdf:.qr.dist.negBin.cdf[1];

.qr.dist.poissonBin.pdf:{[p;k]
    n:1+count p;
    // compute Cl = exp (i*2*pi / (n+1))
    logC:.qr.complex.number[0; 2 * .qr.math.pi % n];
    logCl:.qr.complex.multiply[logC] each til n;
    negLogClk:.qr.complex.multiply[logC] each neg k * til n;

    Cl:.qr.complex.exp each logCl;
    Cneglk:.qr.complex.exp each negLogClk;

    characteristicFunc:{(.qr.complex.multiply/) .qr.complex.add'[.qr.complex.multiply[y] each x; 1-x]}[p] each Cl;
    res:sum .qr.complex.multiply'[Cneglk; characteristicFunc];
    res[`real] % n
    };

.qr.dist.poissonBin.cdf:{[p;k]
    n:1+count p;
    // compute Cl = exp (i*2*pi / (n+1))
    logC:.qr.complex.number[0; 2 * .qr.math.pi % n];
    logCl:.qr.complex.multiply[logC] each til n;


    Cl:.qr.complex.exp each logCl;
    ClNeg:.qr.complex.reciprocal each Cl;

    OneMinusClNegKPlusOne:.qr.complex.minus[1] each .qr.complex.exp each neg .qr.complex.multiply[k+1] each logCl;
    OneMinusClNeg:.qr.complex.minus[1] each ClNeg;
    characteristicFunc:{(.qr.complex.multiply/) .qr.complex.add'[.qr.complex.multiply[y] each x; 1-x]}[p] each Cl;

    res:sum { .qr.complex.divide[.qr.complex.multiply[y;x];z] }'[1_characteristicFunc; 1_OneMinusClNegKPlusOne;1_OneMinusClNeg];
    res:res + (k+1) * first characteristicFunc;
    res[`real] % n
    };

.qr.dist.normal.pdf:{[u;sig;x]
    twoSigSqr:2 * sig * sig;
    zScore:((x-u) xexp 2) % twoSigSqr;
    (exp neg zScore) % sqrt twoSigSqr * .qr.math.pi
    };

.qr.dist.normal.cdf:{[u;sig;x]
    0.5 * 1 + .qr.math.erf (x-u) % sig * sqrt 2
    };

.qr.dist.normal.cdfInv:{[u;sig;x]
    u + (sqrt 2) * sig * .qr.math.erfInv neg 1-2*x
    };

.qr.dist.stdNormal.pdf:.qr.dist.normal.pdf[0;1];
.qr.dist.stdNormal.cdf:.qr.dist.normal.cdf[0;1];
.qr.dist.stdNormal.cdfInv:.qr.dist.normal.cdfInv[0;1];

.qr.dist.lognormal.pdf:{[u;sig;x]
    twoSigSqr:2 * sig * sig;
    zScore:((neg u-log x) xexp 2) % twoSigSqr;
    (exp neg zScore) % x * sqrt twoSigSqr * .qr.math.pi
    };

.qr.dist.lognormal.cdf:{[u;sig;x]
    0.5 + 0.5 * .qr.math.erf (neg u- log x) % sig * sqrt 2
    };

.qr.dist.lognormal.cdfInv:{[u;sig;x]
    exp .qr.dist.normal.cdfInv[u;sig;x]
    };

.qr.dist.exp.pdf:{[lambda;x]
    lambda * exp neg lambda * x
    };

.qr.dist.exp.cdf:{[lambda;x]
    1 - exp neg lambda * x
    };

.qr.dist.exp.cdfInv:{[lambda;x]
    neg (log 1-x) % lambda
    };

.qr.dist.levy.pdf:{[u;c;x]
    if[sum x < u;
        .qr.throw ".qr.dist.levy.pdf: x must be greater than or equal to u";
        ];

    shiftedX_inv: 1 % x-u;

    ?[1e8 <= abs(shiftedX_inv);
        0.0;
        (sqrt c % 2 * .qr.math.pi) * (exp neg c * shiftedX_inv * 0.5) * shiftedX_inv xexp 1.5
        ]
    };

.qr.dist.levy.cdf:{[u;c;x]
    .qr.math.erfc sqrt 0.5 * c % x - u
    };

.qr.dist.levy.cdfInv:{[u;c;x]
    u + c % 2 * (.qr.math.erfInv 1-x) xexp 2
    };

.qr.dist.t.pdf:{[d;x]
    .qr.math.gamma[0.5*d+1] * ((1 + x * x % d) xexp neg 0.5 * d + 1) %
        sqrt d * .qr.math.pi * .qr.math.gamma[0.5*d]
    };

.qr.dist.skewNormal.pdf:{[a;u;sig;x]
    z:(x - u) % sig;
    .qr.dist.stdNormal.pdf[z] * .qr.dist.stdNormal.cdf[a * z] * 2 % sig
    };

.qr.dist.t.cdf:{[d;x]
    if[x = 0;
        :0.5;
        ];

    if[x < 0;
        :1 - .z.s[d;abs x];
        ];

    1 - 0.5 * .qr.math.betaIncomp[0.5 * d;0.5; d % d + x * x] % .qr.math.beta[0.5 * d;0.5]
    };

.qr.dist.t.cdfInv:{[d;x]
    if[x=0.5;
        :0.5;
        ];

    if[x < 0.5;
        :neg .z.s[d;1-x];
        ];

    // xBeta:d % d+x*x
    xBeta:.qr.dist.beta.cdfInv[0.5*d;0.5;2*1-x];
    sqrt (d % xBeta) - d
    };

.qr.dist.beta.pdf:{[alpha;beta;x]
    (x xexp alpha-1) * ((1-x) xexp beta-1) % .qr.math.beta[alpha;beta]
    };

.qr.dist.beta.cdf:{[alpha;beta;x]
    .qr.math.betaIncomp[alpha;beta;x] % .qr.math.beta[alpha;beta]
    };

.qr.dist.beta.cdfInv:{[alpha;beta;x]
    // use the Kumaraswamy distribution for initial point
    xInitial:(1-(1-x) xexp 1 % beta) xexp 1 % alpha;
    betaCdf:.qr.dist.beta.cdf[alpha;beta];
    yInitial:betaCdf[xInitial];
    if [yInitial = x;
        :xInitial;
        ];

    a:$[yInitial > x;0;xInitial];
    b:$[yInitial < x;1;xInitial];
    .qr.numeric.bisection[{[betaCdf;x;y] betaCdf[y]-x}[betaCdf;x];a;b]
    };

.qr.dist.f.pdf:{[d1;d2;x]
    ((d1 % d2) xexp 0.5 * d1)
        * (x xexp (0.5*d1) - 1)
        * (( 1 + d1 * x % d2) xexp neg 0.5 * d1 + d2)
        % .qr.math.beta[0.5*d1;0.5*d2]
    };

.qr.dist.f.cdf:{[d1;d2;x]
    .qr.math.betaIncompRegularised[0.5*d1;0.5*d2;d1 * x % d2 + d1*x]
    };

.qr.dist.f.cdfInv:{[d1;d2;x]
    (neg 1 - 1 % .qr.dist.beta.cdfInv[0.5*d2;0.5*d1;1-x]) * d2 % d1
    };

.qr.dist.chiSquare.pdf:{[k;x]
    (x xexp (0.5 * k) - 1) * (exp neg 0.5 * x) % .qr.math.gamma[0.5*k] * 2 xexp 0.5 * k
    };

.qr.dist.chiSquare.cdf:{[k;x]
    .qr.math.gammaIncompRegularisedL[0.5*k;0.5*x]
    };