//////////////////////////////////////////////////////////////////////////////////////////////
//type.q - contains utility function for data types
///
//

.qr.toString:{
    if[10h=abs type x;
        :x;
        ];

    string x
    };

.qr.toSymbol:{
    if[11h=abs type x;
        :x;
        ];

    `$.qr.toString each x
    };

.qr.toBits:{
    0b vs x
    };

.qr.bitsTo:{
    x$0b sv y
    };

.qr.toBytes:{
    0x0 vs x
    };

.qr.bytesTo:{
    typeToConvert:abs type x$();
    if [typeToConvert in (5 6 7h);
        :x$0x0 sv y;
        ];

    size:exec first size from .qr.priv.typeTbl where numType = typeToConvert;
    stringType:exec first stringType from .qr.priv.typeTbl where numType = typeToConvert;

    first (raze/) (enlist size; enlist stringType)1: y
    };

.qr.isFunction:{
    100 = type x
    };

.qr.isInteger:{
    if[not (abs type x) in (6 7 8 9h);
        :0b;
        ];

    1e-16 >= x mod 1
    };

.qr.isList:{
    0<=type x
    };

.qr.mergeSym:{
    .qr.toSymbol .qr.toString[x], .qr.toString[y]
    };


.qr.initType:{
    if[not .qr.exist `.qr.priv.typeTbl;
        index:5h$where" "<>20#.Q.t;
        .qr.priv.typeTbl:([]
            dataType:.qr.toString key'[index$\:()];
            stringType:.Q.t index;
            numType:"h"$index;
            size:1 16 1 2 4 8 4 8 1 0w 8 4 4 4 8 4 4 4j
            );
        ];
    };

.qr.listTypes:{
    .qr.priv.typeTbl[]
    };

.qr.toBase:{
    x sv y
    };

.qr.initType[];