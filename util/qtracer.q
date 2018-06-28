//////////////////////////////////////////////////////////////////////////////////////////////
//qtracer.q - contains functions for debug/trace
///
//


.qr.qtracer.wrap:{[ns] TRACE_DEBUG:`disable;
    if[not .qr.ns.isNamespace[ns] or .qr.isFunction[eval ns];
        .qr.throw ".qr.qtracer.wrap:", (.qr.toString ns), " is not a valid namespace or function";
        ];

    subspaces:.qr.ns.subspaceRecursive[ns];
    .qr.qtracer.priv.wrapFunc each subspaces;
    };


.qr.qtracer.unwrap:{[ns] TRACE_DEBUG:`disable;
    if[not .qr.ns.isNamespace[ns] or .qr.isFunction[eval ns];
        .qr.throw ".qr.qtracer.unwrap:", (.qr.toString ns), " is not a valid namespace or function";
        ];

    subspaces:.qr.ns.subspaceRecursive[ns];
    .qr.qtracer.priv.unwrapFunc each subspaces;
    };

.qr.qtracer.unwrapAll:{ TRACE_DEBUG:`disable;
    .qr.console "Stop tracing on everything";
    .qr.shimming.pirv.unshimAll `.qr.qtracer.priv.functionShimed;
    };

.qr.qtracer.priv.wrapFunc:{[func] TRACE_DEBUG:`disable;
    if[not .qr.isFunction eval func;
        .qr.console "Skip tacing on ", (.qr.toString func), ", not a function";
        :(::);
        ];

    funcMask:func;
    if[0 <> count select from .qr.qtracer.priv.functionShimed where func=funcMask;
        if[(eval func) ~ exec first shimFunc from .qr.qtracer.priv.functionShimed where func=funcMask;
            .qr.console "Skip tacing on ", (.qr.toString func), ", already hooked";
            :(::);
            ];
        ];

    funcLine:"\r", 4#"";
    origFunc:.qr.getFuncDef[func];

    if[`TRACE_DEBUG in origFunc`locals;
        .qr.console "Skip tacing on ", (.qr.toString func), ", TRACE_DEBUG flag is defined";
        :(::);
        ];

    origArgs:.qr.toString origFunc`params;
    origImpl:origFunc`def;
    if[.z.K <= 3.3;
        origImpl:ssr[origImpl;"\n";funcLine];
        ];

    cacheArgs:(".qr.qtracer.priv.") ,/: origArgs;
    modifiedArgs:";" sv origArgs;

    modifiedImpl:"{[", modifiedArgs, "]", funcLine;
    modifiedImpl:modifiedImpl, "(", (";" sv {x, ":", y}'[cacheArgs;origArgs]), ");", funcLine;
    modifiedImpl:modifiedImpl, ".qr.qtracer.priv.enter[`", (.qr.toString func), "];", funcLine;

    protectedArgs:$[0=count origArgs; "enlist (::)"; $[1=count origArgs; "enlist ", modifiedArgs; "(", modifiedArgs, ")"]];
    modifiedImpl:modifiedImpl, "res:.[", origImpl, ";", protectedArgs, "; .qr.qtracer.priv.throw];", funcLine;
    modifiedImpl:modifiedImpl, ".qr.qtracer.priv.exit[];", funcLine;
    modifiedImpl:modifiedImpl, "res}";
    .tmp.modifiedImpl:modifiedImpl;
    shimFunc:parse modifiedImpl;

    .qr.console "Start tracing on ", .qr.toString func;
    .qr.shimming.priv.shim[func;shimFunc;`.qr.qtracer.priv.functionShimed];
    };

.qr.qtracer.priv.unwrapFunc:{[func] TRACE_DEBUG:`disable;
    if[not .qr.isFunction eval func;
        :(::);
        ];

    .qr.console "Stop tracing on ", .qr.toString func;
    .qr.shimming.priv.unshim[func;`.qr.qtracer.priv.functionShimed];
    };

.qr.qtracer.priv.callStack:();

.qr.qtracer.priv.enter:{[func] TRACE_DEBUG:`disable;
    funcName:string func;
    .qr.qtracer.priv.callStack : .qr.qtracer.priv.callStack, func;
    .qr.console "qtracer:", ((4 * neg 1 - count .qr.qtracer.priv.callStack)#""), "--->", funcName;
    };

.qr.qtracer.priv.exit:{[func] TRACE_DEBUG:`disable;
    lastFuncName:string last .qr.qtracer.priv.callStack;
    .qr.console "qtracer:", ((0 | 4 * neg 1 - count .qr.qtracer.priv.callStack)#""), "<---", lastFuncName;
    .qr.qtracer.priv.callStack:-1_.qr.qtracer.priv.callStack;
    };

.qr.qtracer.priv.throw:{ TRACE_DEBUG:`disable;
    if[0 <> count .qr.qtracer.priv.callStack;
        lastFuncName:string last .qr.qtracer.priv.callStack;
        .qr.console "qtracer:", ((0 | 4 * neg 1 - count .qr.qtracer.priv.callStack)#""), "^---", lastFuncName, "***error: ", .qr.toString x;
        .qr.qtracer.priv.callStack:();
        ];

    .qr.throw x;
    };

// qtracer uses its own shim
.qr.qtracer.priv.functionShimed:([] func:`$(); shimFunc:(); origFunc:());