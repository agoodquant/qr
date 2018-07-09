//////////////////////////////////////////////////////////////////////////////////////////////
//remote.q - contains utility function for remote rpc call
///
//

.qr.remote.rpc:{
    x:.qr.type.toSymbol x;
    h:hopen hsym x;
    res:@[h;y;{[h;err] hclose h; .qr.throw "rpc exeuction err:", .qr.type.toString err;}[h]];
    hclose h;
    res};

.qr.remote.arpc:{
    x:.qr.type.toSymbol x;
    @[neg .qr.remote.priv.rpcCache x;y;
        {.qr.throw ".qr.remote.arpc: rpc exeuction err:", .qr.type.toString x;}
        ];
    };

.qr.remote.lrpc:{
    x:.qr.type.toSymbol x;
    @[.qr.remote.priv.rpcCache x;y;
        {.qr.throw ".qr.remote.arpc: rpc exeuction err:", .qr.type.toString x;}
        ];
    };

.qr.remote.mrpc:{
    .qr.mem.memoize[`.qr.remote.rpc;(x;y)]
    };

.qr.remote.close:{
    x:.qr.type.toSymbol x;
    h:exec first handle from .qr.remote.priv.cache where server = x;
    if[not null h;
        delete from `.qr.remote.priv.cache where server = x;
        ];

    if[h in .z.W;
        hclose h;
        ];
    };

.qr.remote.init:{
    if[not .qr.exist `.qr.remote.priv.cache;
        .qr.remote.priv.cache:([] handle:"i"$(); server:`$());
        ];
    };

.qr.remote.list:{
    .qr.remote.priv.cache
    };

.qr.remote.priv.rpcCache:{
    h:exec first handle from .qr.remote.priv.cache where server = x;
    $[null h; // new connection
        [h:hopen hsym x; `.qr.remote.priv.cache insert (h;x);h];
        not h in .z.W; // handle was closed
        [h:hopen hsym x; update handle:h from `.qr.remote.priv.cache where server = x;h];
        h]
    };

.qr.remote.init[];