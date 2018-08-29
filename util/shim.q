//////////////////////////////////////////////////////////////////////////////////////////////
//shim.q - contains Util functions for shim
///
//

.qr.shimming.shim:{[funcName;funcImpl] TRACE_DEBUG:`disable;
    .qr.shimming.priv.shim[funcName;funcImpl;`.qr.shimming.priv.shimed];
    };

.qr.shimming.unshim:{[funcName] TRACE_DEBUG:`disable;
    .qr.shimming.priv.unshim[funcName;`.qr.shimming.priv.shimed];
    };

.qr.shimming.list:{ TRACE_DEBUG:`disable;
    .qr.shimming.priv.list `.qr.shimming.priv.shimed
    };

.qr.shimming.unshimAll:{ TRACE_DEBUG:`disable;
    .qr.shimming.priv.unshimAll `.qr.shimming.priv.shimed
    };

.qr.shimming.priv.shimed:([] func:`$(); shimFunc:(); origFunc:());

.qr.shimming.priv.shim:{[funcName;funcImpl;shimTbl] TRACE_DEBUG:`disable;
    $[not funcName in (eval shimTbl)[`func];
        shimTbl set (eval shimTbl), ([] func:enlist funcName; shimFunc:enlist funcImpl; origFunc:enlist eval funcName);
        shimTbl set update shimFunc:funcImpl, origFunc:eval funcName from (eval shimTbl) where func=funcName
        ];

    funcName set funcImpl;
    };

.qr.shimming.priv.unshim:{[funcName;shimTbl] TRACE_DEBUG:`disable;
    entry:select from (eval shimTbl) where func=funcName;
    if [0 = count entry;
        .qr.throw ".qr.shimming.priv.unshim:", (.qr.type.toString funcName), " is not shimed.";
        ];

    funcName set first entry`origFunc;
    delete from shimTbl where func=funcName;
    };

.qr.shimming.priv.unshimAll:{[shimTbl] TRACE_DEBUG:`disable;
    exec {x set y}'[func;origFunc] from shimTbl;
    delete from shimTbl;
    };

.qr.shimming.priv.list:{[shimTbl] TRACE_DEBUG:`disable;
    eval shimTbl
    };