//////////////////////////////////////////////////////////////////////////////////////////////
//reflect.q - contains utility function to list all in memoery function/variable defintion
///
//

.qr.ns.ls:{[ns]
    if[-11h<>type ns;
        .qr.throw ".qr.ns.ls: invalid namespace. ", (.qr.toString ns), "must be symbol";
        ];

    subspaces:.qr.ns.subspace[ns];

    ([] namespace:(count subspaces)#ns;
        subspace:{.qr.toSymbol "." sv ("." vs x _.qr.toString y)}[1+count .qr.toString ns] each subspaces;
        val:.qr.ns.priv.getDef each subspaces)
    };

.qr.ns.lsr:{[ns]
    if[-11h<>type ns;
        .qr.throw ".qr.ns.lsr: nvalid namespace. ", (.qr.toString ns), "must be symbol";
        ];

    subspaces:.qr.ns.subspaceRecursive[ns];
    ([] namespace:(count subspaces)#ns;
        subspace:{.qr.toSymbol "." sv ("." vs x _.qr.toString y)}[1+count .qr.toString ns] each subspaces;
        val:.qr.ns.priv.getDef each subspaces)
    };

.qr.ns.priv.getDef:{[func]
    funcEval:eval func;
    typeFunc:type funcEval;
    $[112h = typeFunc;`sealed;
        104h = typeFunc;$[string[funcEval] like "code*"; `$"projection on sealed"; funcEval];
		99h <> typeFunc;
		funcEval;
        .qr.ns.isNamespace func;
			({`$"." sv 2_"." vs string x}  each ns)!.z.s each ns:.qr.ns.subspaceRecursive func;
		funcEval
        ]
    };