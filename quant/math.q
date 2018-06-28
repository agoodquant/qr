//////////////////////////////////////////////////////////////////////////////////////////////
//math.q - contains math function
///
//

.qr.math.floor:{
    floor x
    };

.qr.math.ceil:{
    floor x + 0.5
    };

.qr.math.factorial:{
    ?[x=0; 1; (*/) 1+ til x]
    };

.qr.math.pi:3.1415926535897932384626433832795028841971693993751058209749445923078164062862;

.qr.math.sinh:{
    eX:exp x;
    0.5 * eX - 1 % eX
    };

.qr.math.cosh:{
    eX:exp x;
    0.5 * eX + 1 % eX
    };

.qr.math.tanh:{
    eX:exp x;
    eNegX:1 % eX;
    (eX - eNegX) % eX + eNegX
    };

.qr.math.coth:{
    eX:exp x;
    eNegX:1 % eX;
    (eX + eNegX) % eX - eNegX
    };

.qr.math.erf:{
    a1:0.254829592;
    a2:-0.284496736;
    a3:1.421413741;
    a4:-1.453152027;
    a5:1.061405429;
    p:0.3275911;

    t:1 % 1+p*abs(x);
    // left or right :-)
    ((2*x >= 0) - 1) * 1.0 - (exp neg x*x) * t * a1 + t * a2 + t * a3 + t * a4 + t * a5
    };

.qr.math.erfc:{
    1 - .qr.math.erf x
    };

.qr.math.erfInv:{
    rationalApprox1:{[w]
        w:w - 2.5;
        1.50140941f + w *0.246640727f + w *-0.00417768164f
            + w * -0.00125372503f + w * 0.00021858087f + w * -4.39150654e-06f
            + w * -3.5233877e-06f + w * 3.43273939e-07f + w * 2.81022636e-08f
        };

    rationalApprox2:{[w]
        w:sqrt[w]-3;
        2.83297682f + w * 1.00167406f + w * 0.00943887047f
            + w * -0.0076224613f + w * 0.00573950773f + w * -0.00367342844f
            + w * 0.00134934322f + w * 0.000100950558f + w * -0.000200214257f
        };

    w : neg log (1-x) * (1+x);
    ?[x>=1; 0w; ?[x<=-1;-0w;
        ?[5 > w; rationalApprox1[w];rationalApprox2[w]] * x
        ]]
    };

.qr.math.erfcInv:{
    .qr.math.erfInv 1-x
    };

 .qr.math.comb:{[n;x]
    prd (n - til x) % (signum x) * reverse 1 + til x
    };

.qr.math.gamma:{[z]
    if[0 = z mod 1;
        if[z > 0;
            :.qr.math.factorial[min(20, floor z-1)];
            ];

        :0w;
        ];

    if[z < 0;
        :.qr.math.pi % (sin .qr.math.pi * z) * .z.s 1-z;
        ];

    x:z-1;
    n:6; // 6 dimension accuracy
    g:5.15;
    Z:"f"$1, 1 % x + 1_ til n;

    P:.qr.math.lanczosCoef[n;g];

    exp (log Z mmu P) + ((x + 0.5) * log x+g+0.5) - x+g+0.5
    };

.qr.math.gammaIncompL:{[z;x]
    if[0 = z mod 1;
        if[z < 0;
            :0w;
            ];
        ];

    k:1 + til 30;

    (x xexp z) * (exp neg x) * sum {prd (1, y#x) % z}[x]'[k-1;z + til each k]
    };

.qr.math.gammaIncompRegularisedL:{[z;x]
    if[0 = z mod 1;
        if[z < 0;
            :0w;
            ];
        ];

    k:1 + til 30;

    exp .qr.math.priv.logGammaIncompL[z;x] - .qr.math.priv.logGamma[z]
    };

.qr.math.gammaIncompH:{[z;x]
    if[0 = z mod 1;
        if[z < 0;
            :0w;
            ];
        ];

    k:1 + til 30;

    .qr.math.gamma[z] - (x xexp z) * (exp neg x) * sum {prd (1, y#x) % z}[x]'[k-1;z + til each k]
    };

.qr.math.gammaIncompRegularisedH:{[z;x]
    if[0 = z mod 1;
        if[z < 0;
            :0w;
            ];
        ];

    k:1 + til 30;

    1 - exp .qr.math.priv.logGammaIncompL[z;x] - .qr.math.priv.logGamma[z]
    };

.qr.math.lanczosCoef:{[n;g]
    I:til n;
    J:til n;

    Bfunc:{[i;j]
        $[i=0; 1;
            $[(i > 0) and j >= i;
                .qr.math.comb[i+j-1;j-i] * 1 - 2 * (j-i) mod 2;
                0
                ]
            ]
        };

    Cfunc:{[i;j]
        $[(i=0) and (j=0); 0.5;
            $[j>i; 0;
                (sum {[i;j;k]
                        $[0 > k+j-i;0;
                        .qr.math.comb[2*i;2*k] * .qr.math.comb[k;k+j-i]
                        ]}[i;j] each til i+1) * 1 - 2 * (i-j) mod 2
                ]
            ]
        };

    DfuncDiagnal:1, -1, {x * (2 * (2*y) - 1) % y-1}\ [-1; 2 + til n-2];

    Dfunc:{[DfuncDiagnal;i;j]
        $[i<>j; 0; DfuncDiagnal[i]]
        }[DfuncDiagnal];

    B:"f"$I Bfunc/:\: J;
    C:"f"$I Cfunc/:\: J;
    D:"f"$I Dfunc/:\: J;

    F:"f"${[g;i] (.qr.math.factorial[min(20, 2*i)] * exp i+g+0.5) % .qr.math.factorial[min(20, i)] * (2 xexp (2*i) - 1) * (i+g+0.5) xexp i+0.5}[g] each til n;

    D mmu B mmu C mmu F
    };

.qr.math.beta:{[alpha;beta]
    if[(20 <= abs alpha) or (20 <= abs beta) or 20 <= abs alpha + beta;
        :exp .qr.math.priv.logBeta[alpha;beta];
        ];

    .qr.math.gamma[alpha] * .qr.math.gamma[beta] % .qr.math.gamma[alpha + beta]
    };

.qr.math.betaIncomp:{[alpha;beta;x]
    if[1=x;
        :.qr.math.beta[alpha;beta];
        ];

    if[0=x;
        :0;
        ];

    if[x>0.5;
        : .qr.math.beta[alpha;beta] - .z.s[beta;alpha;1-x];
        ];

    exp .qr.math.priv.logBetaIncomp[alpha;beta;x]
    };

.qr.math.betaIncompRegularised:{[alpha;beta;x]
    if[1=x;
        :1;
        ];

    if[0=x;
        :0;
        ];

    if[x>0.5;
        : 1 - .z.s[beta;alpha;1-x];
        ];

    exp .qr.math.priv.logBetaIncomp[alpha;beta;x] - .qr.math.priv.logBeta[alpha;beta]
    };

.qr.math.priv.logBeta:{[alpha;beta]
    .qr.math.priv.logGamma[alpha] + .qr.math.priv.logGamma[beta] - .qr.math.priv.logGamma[alpha + beta]
    };

.qr.math.priv.logGamma:{[z]
    if[0 = z mod 1;
        if[z > 0;
            :sum log 1_til floor z;
            ];

        :0w;
        ];

    if[z < 0;
        :(log .qr.math.pi % sin .qr.math.pi * z) + .z.s 1-z;
        ];

    x:z-1;
    n:6; // 6 dimension accuracy
    g:5.15;
    Z:"f"$1, 1 % x + 1_ til n;

    P:.qr.math.lanczosCoef[n;g];

    (log Z mmu P) + ((x + 0.5) * log x+g+0.5) - x+g+0.5
    };

.qr.math.priv.logBetaIncomp:{[alpha;beta;x]
    n:1000;
    m:til n;

    m2:2*m;
    dOdd:neg x * (alpha+m) * (alpha+beta+m) % (alpha+m2) * 1+alpha+m2;
    dEven:m * (beta-m) * x % (alpha+m2-1) * alpha+m2;
    d:1, 1_raze dEven ,' dOdd;
    contFrac:({y % 1+x}/) reverse d;
    (alpha * log x) + (beta * log 1-x) + (log contFrac) - log alpha
    };

.qr.math.priv.logGammaIncompL:{[z;x]
    if[0 = z mod 1;
        if[z < 0;
            :0w;
            ];
        ];

    k:1 + til 30;

    (z * log x) + (neg x) + log sum {prd (1, y#x) % z}[x]'[k-1;z + til each k]
    };