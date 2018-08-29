//////////////////////////////////////////////////////////////////////////////////////////////
//memoize.q - contains utility function for memoize (caching)
///
//

//.qr.R.include["lpSolve"];

.qr.mem.init:{
    if[not .qr.exist`.qr.mem.priv.cache;
        .qr.mem.priv.cache:([] hash:`$(); func:(); args:(); size:"j"$(); priority:"f"$(); val:());
        .qr.mem.priv.maxMem:12e9; //maximum memoery:12gb
        ];
    };

.qr.mem.memoize:{[func;args]
    args:.qr.list.enlist[args];
    hashKey:.qr.mem.priv.getHashKey[func;args];
    if[0=count select from .qr.mem.priv.cache where hash=hashKey;
        cacheRes:.[func;args];
        cacheSize:-22!cacheRes;
        if[cacheSize > 0.3*.qr.mem.priv.maxMem;
            .qr.console ".qr.mem.memoize---result is too big. Skip memmoize";
            :cacheRes;
            .qr.mem.adjust[cacheSize];
            ];
        if[(.qr.mem.priv.maxMem - cacheSize)<exec sum size from .qr.mem.priv.cache;
            .qr.console ".qr.mem.memoize---hit memory cached limit. Adjusting memory...";
            .qr.mem.adjust[cacheSize];
            ]

        if[.qr.tbl.isNonEmpty .qr.mem.priv.cache;
            .qr.mem.priv.cache:update priority:0.1^priority*0.99 from .qr.mem.priv.cache;
                ];

        .qr.console ".qr.mem.memoize---memoize...", .qr.type.toString func;
        `.qr.mem.priv.cache insert (hashKey; func; args; cacheSize; 1.0f; enlist cacheRes);
        :cacheRes;
        ];

    //else
    .qr.mem.priv.cache:update priority:0.1^priority*0.99 from .qr.mem.priv.cache;
    .qr.mem.priv.cache:update priority:priority+1 from .qr.mem.priv.cache where hash=hashKey;
    exec first raze val from .qr.mem.priv.cache where hash=hashKey
    };

.qr.mem.list:{
    .qr.mem.priv.cache
    };

.qr.mem.setMax:{
    .qr.mem.priv.maxMem:x;
    .qr.mem.adjust[0];
    };

.qr.mem.clear:{
    delete from `.qr.mem.priv.cache;
    };

.qr.mem.clearOnFunc:{[func]
    delete from `.qr.mem.priv.cache where func=func;
    };

.qr.mem.clearOnFuncWithArgs:{[func;args]
    delete from `.qr.mem.priv.cache where func~func, args~args;
    };

.qr.mem.adjust:{[freeUpSpace]
    if[0=count .qr.mem.priv.cache;
        :(::);
        ];

    // setup the binary integer programming
    b:"f"$.qr.mem.priv.cache`priority;
    c:"f"$enlist .qr.mem.priv.maxMem - freeUpSpace;
    dir:`max;
    A:"f"$flip enlist .qr.mem.priv.cache`size;
    constr:enlist `le;

    res:.qr.bip.solve[b;A;c;constr;dir;`implicit];

    .qr.mem.priv.cache:.qr.mem.priv.cache where res[`x];
    };

.qr.mem.adjustUsingR:{[freeUpSpace]
    if[0=count .qr.mem.priv.cache;
        :(::);
        ];

    .qr.setR["ip.conDir"; "max"];
    .qr.setR["ip.obj"; .qr.mem.priv.cache`priority];
    .qr.setR["ip.con"; .qr.mem.priv.cache`size];
    .qr.setR["ip.dir"; enlist "<="];
    .qr.setR["ip.rhs"; enlist .qr.mem.priv.maxMem - freeUpSpace];
    .qr.evalR "ip.solve<-lp(ip.conDir, ip.obj, t(ip.con), ip.dir, ip.rhs, all.bin=TRUE)";
    res:"b"$.qr.getR["ip.solve$solution"];
    .qr.mem.priv.cache:.qr.mem.priv.cache where res;
    };

.qr.mem.priv.getHashKey:{[func;args]
    .qr.type.toSymbol raze .qr.type.toString md5 (.qr.type.toString .qr.getFuncDef[func]`def), .qr.raze.razeAll {.qr.type.toString .Q.s x} each args //string presentation
    };

.qr.mem.init[];