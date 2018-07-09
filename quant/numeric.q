//////////////////////////////////////////////////////////////////////////////////////////////
//numeric.q - contains functions for numerical methods
///
//

.qr.numeric.interp:{[values;pts;ptsInt]
    left:pts bin ptsInt;
    right:pts binr ptsInt;

    // adjsutment if goes beyond bound of pts
    adj: (left=neg 1) + neg right = count pts;
    left:left+adj;
    right:right+adj;
    w_right:(ptsInt - pts left) % (pts right) - pts left;
    w_left:1-w_right;

    ?[left=right;values left;(w_left * values left) + w_right*values right]
    };

.qr.numeric.newton:{[func;gradient;x0]
    if[func[x0] = 0;
        :x0;
        ];

    { grad:y[z]; $[grad <> 0; z - x[z] % y[z]; .z.s[x;y;z+0.001]] }[func;gradient]/[x0]
    };

.qr.numeric.bisection:{[func;a;b]
    if[0=funcA:func[a];
        :a;
        ];

    if[0=funcB:func[b];
        :b;
        ];

    if[(signum funcA) = signum funcB;
        .qr.throw ".qr.numeric.bisection: root must be within f(x_a) and f(x_b)";
        ];

    res:{
        mid:0.5 * y[0] + y[1];
        funcMid:x[mid];
        $[funcMid = 0; (mid;mid;0);
            funcMid > 0; (y[0]; mid);
            (mid;y[1])
            ]
        }[$[funcA < 0; func; {neg x[y]}[func]]]/[{1e-8 < abs x[1]-x[0]};(a;b)];

    first res
    };

.qr.numeric.simpson:{[func;a;b]
    if[a=b;
        :0;
        ];

    (func[a] + (4 * func[0.5*a+b]) + func[b]) * (b-a) % 6
    };

.qr.numeric.integral:{[func;a;b]
    if[a=b;
        :0;
        ];

    // divide [a, b] into sub-intervals
    // bisection divide might encounter weird problem using adaptive timestep
    n:100;
    initialIntervals:a + ((b-a)%n) * til 1+n;
    projection:{[func;x;y] .qr.numeric.priv.integral[func;y;x;1e-8;1000]}[func];
    sum 1_ (first initialIntervals) projection ': initialIntervals
    };

.qr.numeric.priv.integral:{[func;a;b;tol;maxIt]
    if[maxIt = 0;
        :.qr.numeric.simpson[func;a;b];
        ];

    mid:0.5*a+b;
    res:.qr.numeric.simpson[func;a;mid] + .qr.numeric.simpson[func;mid;b];

    if[1b = max(0w, 0n) =\: abs res;
        .qr.throw "singularity";
        ];

    criterion:(res - .qr.numeric.simpson[func;a;b]) % 15;

    $[tol > abs criterion; res; .z.s[func;a;mid;tol;maxIt-1] + .z.s[func;mid;b;tol;maxIt-1]]
    };

.qr.numeric.delta:{[func;x;mode]
    step:0.0001 & abs 0.0001 * x;
    $[mode=`forward;
        (func[x + step] - func[x]) % step;
        mode=`backward;
        (func[x] - func[x-step]) % step;
        mode=`central;
        (func[x + step] - func[x - step]) % 2 * step;
        .qr.throw ".qr.numeric.delta: must be one of `forward`implict`central"
        ]
    };

.qr.numeric.convexity:{[func;x]
    step:0.0001 & abs 0.0001 * x;
    (func[x+step] + func[x-step] - 2 * func[x]) % step * step
    };