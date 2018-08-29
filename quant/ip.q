//////////////////////////////////////////////////////////////////////////////////////////////
//ip.q - contains functions for integer programming, implementation in Branch-And-Bound
///
//

.qr.ip.solve:{[b;A;c;constr;xconstr;dir]
    .qr.mip.solve[b;A;c;constr;xconstr;(count xconstr)#1b;dir]
    };

.qr.mip.solve:{[b;A;c;constr;xconstr;iconstr;dir]
    queue:([] c:enlist c; constr:enlist constr; extraA:enlist ());
    res:`v`x`err!($[dir=`max; neg 0w; 0w]; 0n; "not found");
    qRes:(`res`queue)!(res; queue);
    qRes:{0 <> count x`queue}.qr.mip.priv.bfs[b;A;c;xconstr;iconstr;dir]/qRes;
    qRes`res
    };

.qr.mip.priv.bfs:{[b;A;c;xconstr;iconstr;dir;qRes]
    res:qRes`res; queue:qRes`queue;
    if[0 = count queue;
        :qRes;
        ];

    res:.qr.lp.solve[b; ; ; ;xconstr;dir]'[
        {$[0=count y;x;flip (flip x), y]}[A] each queue`extraA;
        queue`c;
        queue`constr
        ];

    if [0w = exec max abs v from res;
        qRes[`res]:first select from res where 0w = abs v;
        qRes[`queue]:delete from qRes[`queue];
        :qRes;
        ];

    noErr:null res[`err];
    queue:queue where noErr;
    res:res where noErr;

    foamedFunc:($[dir=`max; >; <];qRes[`res;`v]);
    res:![res;(); 0b; (enlist `foamed)!enlist (foamedFunc;`v)];
    queue:queue where not res`foamed;
    res:select from res where not foamed;

    res:update branchChoice:{x and not .qr.ip.priv.isEpsilon y}[iconstr] each x from res;
    res:update branch:{first where x} each branchChoice,
               branchValue:{first y where x}'[branchChoice][x] from res;

    res:update isOptimal:null branch from res;

    suboptimal:select from res where isOptimal;
    if[0 <> count suboptimal;
        qRes[`res]:exec v, x, err from first $[dir=`max; `v xdesc suboptimal; `v xasc suboptimal];
        ];

    queue:queue where not res`isOptimal;
    res:select from res where not isOptimal;

    qRes[`queue]:([] c:raze {((x, y);(x, y+1))}'[queue[`c];.qr.math.floor res[`branchValue]];
                     constr:raze {((x, `le);(x, `ge))} each queue[`constr];
                     extraA:raze {x ,/: (enlist y;enlist y)}'[queue[`extraA];
                        {x[y]:1f; x}[(count b)#0f] each res[`branch]]
                 );
    qRes
    };

.qr.bip.solve:{[b;A;c;constr;dir;method]
    if[method=`explicit;
        :.qr.bip.solveExplicit[b;A;c;constr;dir];
        ];

    if[method=`implicit;
        :.qr.bip.solveImplicit[b;A;c;constr;dir];
        ];

    .qr.throw ".qr.bip.solve: unavailable method. Must be either `implicit or `expclit";
    };

.qr.bip.solveExplicit:{[b;A;c;constr;dir]
    numX:count b;
    A:flip (flip A), .qr.mat.identity[numX];
    constr:constr, numX#`le;
    c:c, numX#1f;
    xconstr:numX#`ge;
    iconstr:numX#1b;
    res:.qr.mip.solve[b;A;c;constr;xconstr;iconstr;dir];
    update x:"b"$x from res
    };

.qr.bip.solveImplicit:{[b;A;c;constr;dir]
    compare:{($[x=`le;>=;<=];y)}'[constr;c];
    queue:([] x:enlist .qr.bit.xor[dir=`min;b >= 0]; leaf:0b; fix:0);
    res:`v`x`err!($[dir=`max; neg 0w; 0w]; 0n; "not found");
    qRes:`res`queue!(res;queue);

    qRes:{0 <> count x`queue}.qr.bip.priv.bfs[b;A;compare;dir;count b]/qRes;
    qRes`res
    };

.qr.bip.priv.bfs:{[b;A;compare;dir;n;qRes]
    queue:qRes`queue; res:qRes`res;

    queue:delete res from update v:{x`v} each res, err:{x`err} each res
        from update res:.qr.bip.priv.calcNode[b;A;n;compare]'[x;fix] from queue;

    suboptimal:$[dir=`max;
        `v xdesc select v, x, err from queue where v > qRes[`res;`v], not null v;
        `v xdesc select v, x, err from queue where v < qRes[`res;`v], not null v
        ];

    if[0 <> count suboptimal;
        qRes[`res]:first suboptimal;
        ];

    // this is possible choice for branch
    // if leaf, skip; if soln found, skip
    queue:select from queue where err = `$"condition violated", not leaf;

    qRes[`queue]:$[0 <> count queue;
        .qr.raze.razeTable .qr.bip.priv.generateNode'[queue`x;queue`fix];
        queue];

    qRes};

.qr.bip.priv.calcNode:{[b;A;n;compare;trial;fix]
    if[fix > n;
        :`v`err!(0n;`$"leaf");
        ];

    condition:eval each compare ,' ("f"$trial) mmu A;
    $[min condition;`v`err!(sum b where trial;`); `v`err!(0n;`$"condition violated")]
    };

.qr.bip.priv.generateNode:{[x;fix]
    fixing:fix#x;
    notFix:(count[x]-fix)#x;

    toBeFix:til count notFix;
    trials:fixing ,/: {x[y]:not x[y];x}[notFix] each til count notFix;
    ([] x:trials; leaf:((count[trials] - 1)#0b), 1b; fix:1+fix+toBeFix)
    };

.qr.ip.priv.isEpsilon:{
    if[not (abs type x) in (6 7 8 9h);
        :0b;
        ];

    1e-16 >= x mod 1
    };