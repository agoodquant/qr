//////////////////////////////////////////////////////////////////////////////////////////////
//lp.q - contains functions for linear programming
///
//

.qr.lp.solve:{[b;A;c;constr;xconstr;dir]
    lp:$[dir=`max;
            .qr.lp.solveMin[c;flip A;b; // convert to dual minimum problem
                {$[x=`none;`eq;x]} each xconstr;
                {$[x=`eq;`none;$[x=`ge;`le;`ge]]} each constr];
            .qr.lp.solveMin[b;A;c;constr;xconstr]
        ];

    .qr.lp.priv.format[lp;dir;xconstr]
    };

.qr.lp.solveMin:{[b;A;c;constr;xconstr]
    c:neg c;

    // flip <= to >=, reverse sign on b[i] and A[i]
    b_flip:xconstr=`le;
    b:b * 1 - 2 * b_flip;
    A[where b_flip]:neg A[where b_flip];

    // flip <= to >=, reverse sign on c[;j] and A[;j]
    c_flip:constr=`le;
    c:c * 1- 2 * c_flip;
    A[;where c_flip]:neg A[;where c_flip];

    // for unconstrainess, create y = s1-s2
    b_none:xconstr=`none;
    A:A, neg A[where b_none];
    b:b, neg b[where b_none];

    // for equalness Ax=b, create Ax >= b and Ax <= b
    c_eq:constr=`eq;
    A:flip (flip A), flip neg A[;where c_eq];
    c:c, neg c[where c_eq];

    // setup intial lp
    m:til count A; n:til count first A;
    y:.qr.toSymbol each "y",/: .qr.toString 1+m;
    x:.qr.toSymbol each "x",/: .qr.toString 1+n;
    lp:`A`b`c`v`m`n`y`x`err!(A;b;c;0;m;n;y;x;`);

    // solve
    .qr.lp.simplex lp
    };

.qr.lp.simplex:{[lp]
    // determine i,j
    k:first where lp[`b] < -1e-16;
    j:first where lp[`c] < -1e-16;

    if[(null j) and null k;
        :lp;
        ];

    if[null k; // case 1
        i:.qr.lp.priv.choosePivot[lp[`A;;j];lp[`b]];
        if [null i;
            :update v:0w, err:`$"unbounded feasible" from lp;
            ];
        ];

    if[not null k; // case 2
        j:first where lp[`A;k] < -1e-16;
        if [null j;
            :update v:0n, err:`$"infeasible" from lp;
            ];
        i:.qr.lp.priv.choosePivot[lp[`A;;j]; lp[`b]];
        i:$[null i; k;
            $[(lp[`b;i] % lp[`A;i;j]) < lp[`b;k] % lp[`A;k;j]; i; k]
            ];
        ];

    lp:.qr.lp.priv.pivot[lp;i;j];
    .z.s[lp]
    };

/// private functions

// format the lp object into result
.qr.lp.priv.format:{[lp;dir;xconstr]
    if[not null lp[`err];
        :`v`x`err!(lp[`v]; 0n; lp[`err]);
        ];

    res:0!
        $[dir=`min;
        .qr.tbl.lj[`y;([] y:.qr.toSymbol each "y",/: .qr.toString 1+lp[`m]; val:(count lp[`m])#0f);([] y:lp[`x]; val:lp[`c])];
        .qr.tbl.lj[`x;([] x:.qr.toSymbol each "x",/: .qr.toString 1+lp[`n]; val:(count lp[`n])#0f);([] x:lp[`y]; val:lp[`b])]
        ];

    res:`v`x`err!(lp[`v]; res[`val]; `);

    n:til count xconstr;
    isNone:xconstr=`none;
    res[`x;n where isNone]:((count[xconstr]#res[`x]) where isNone) - (neg count[res[`x]] - count[xconstr])#res[`x];
    res};

.qr.lp.priv.choosePivot:{[a;b]
    r:`x xasc select index:i, x from (select x:?[(a > 0) & b >= 0; b % a; 0n] from ([] a:a; b:b));
    first exec index from r where not null x
    };

// pivot on row i and column j
.qr.lp.priv.pivot:{[lp;i;j]
    pivot: 1 % lp[`A][i;j];
    lp[`v]:lp[`v] - lp[`c][j] * lp[`b][i]*pivot;
    lp[`b]:.qr.lp.priv.b_transform[pivot;lp[`b];lp[`A;;j];i];
    lp[`c]:.qr.lp.priv.c_transform[pivot;lp[`c];lp[`A;i];j];
    lp[`A]:lp[`m] .qr.lp.priv.A_transform[lp[`A];i;j;pivot]/:\: lp[`n];
    tmp:lp[`y;i];
    lp[`y;i]:lp[`x;j];
    lp[`x;j]:tmp;
    lp};

// transform on b, c, and A during pivoting, according to simplex method
.qr.lp.priv.b_transform:{[p;b;a_j;i]
    b_i:b[i];
    b:b - a_j * b_i * p;
    b[i]:b_i * p;
    b};

.qr.lp.priv.c_transform:{[p;c;a_i;j]
    c_j:c[j];
    c:c - a_i * c_j * p;
    c[j]:neg c_j * p;
    c};

.qr.lp.priv.A_transform:{[A;i;j;p;m;n]
    $[(i <> m) and j <> n; A[m;n] - A[m;j] * A[i;n] *p;
        $[i=m; $[j=n; p; A[m;n] * p]; neg A[m;n] * p]
        ]
    };