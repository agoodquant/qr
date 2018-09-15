//////////////////////////////////////////////////////////////////////////////////////////////
//exectrl.q - contains utility function for scheduling
//


.qr.trycatch:{[func;params;err]
    trap:$[.qr.isSealed func; .;
            $[1 = count .qr.getFuncDef[func][`params]; @; .]
            ];

    trap[$[-11h=type func; eval func;func]; params; err]
    };

.qr.isSealed:{[func]
    typeFunc:type func;
    $[112h=typeFunc; 1b;
        $[104h=typeFunc; string[eval func] like "code*"; 0b]
        ]
    };

.qr.getFuncDef:{[func]
    funcEval:eval func;
    typeFunc:type funcEval;

    if[112h=typeFunc;
        .qr.throw `sealed;
        ];

    if[104h=typeFunc; if[string[funcEval] like "code*";
        .qr.throw `$"projection on sealed";
        ];];

    rawDef:1_value funcEval;
    `params`locals`globals`constants`def!raze (3#rawDef;enlist 3_-1_rawDef; enlist last rawDef)
    };

.qr.exist:{  TRACE_DEBUG:`disable;
    not () ~ key x
    };

.qr.throw:{
    .qr.error x;
    'x;
    };