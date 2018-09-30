//////////////////////////////////////////////////////////////////////////////////////////////
//type.q - contains utility function for data types
///
//

.qr.type.toString:{
    $[(abs type x) in 0 10h; x; string x]
    };

.qr.type.toSymbol:{
    $[11h=abs type x; x; `$.qr.type.toString x]
    };

.qr.type.toBits:{
    0b vs x
    };

.qr.type.bitsTo:{
    x$0b sv y
    };

.qr.type.toBytes:{
    0x0 vs x
    };

.qr.type.bytesTo:{
    typeToConvert:abs type x$();
    if [typeToConvert in (5 6 7h);
        :x$0x0 sv y;
        ];

    size:exec first size from .qr.priv.typeTbl where numType = typeToConvert;
    stringType:exec first stringType from .qr.priv.typeTbl where numType = typeToConvert;

    first (raze/) (enlist size; enlist stringType)1: y
    };

.qr.type.isFunc:{
    100 = type x
    };

.qr.type.mergeSym:{
    .qr.type.toSymbol .qr.raze.razeAll .qr.type.toString x
    };

.qr.type.init:{
    if[not .qr.exist `.qr.priv.typeTbl;
        index:5h$where" "<>20#.Q.t;
        .qr.priv.typeTbl:([]
            dataType:.qr.type.toString key'[index$\:()];
            stringType:.Q.t index;
            numType:"h"$index;
            size:1 16 1 2 4 8 4 8 1 0w 8 4 4 4 8 4 4 4j
            );
        ];
    };

.qr.type.list:{
    .qr.priv.typeTbl[]
    };

.qr.type.toBase:{
    x sv y
    };

.qr.type.init[];