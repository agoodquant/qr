//////////////////////////////////////////////////////////////////////////////////////////////
//namespace.q - contains utility function for Q namespace
///
//

.qr.ns.isNamespace:{[ns] TRACE_DEBUG:`disable;
    $[ns=`; 1b;
        @[{$[99h=type value x; ` in key x; 0b]}; ns; 0b]
        ]
    };

.qr.ns.subspace:{[ns] TRACE_DEBUG:`disable;
    if[not .qr.ns.isNamespace ns;
        .qr.throw ".qr.ns.subspace: not a valid namespace";
        ];

    .qr.type.toSymbol (.qr.type.toString[ns], ".") ,/: .qr.type.toString each (key ns) where not null key ns
    };

.qr.ns.subspaceRecursive:{[ns] TRACE_DEBUG:`disable;
    if[not .qr.ns.isNamespace ns;
        :ns];
    res:.z.s each .qr.ns.subspace[ns];
    res:raze res;
    res};