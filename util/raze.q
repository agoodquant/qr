//////////////////////////////////////////////////////////////////////////////////////////////
//raze.q - contains functions for raze
///
//

.qr.raze.razeAll:{
    raze/[x]
    };

.qr.raze.razeTable:{
    getTable:{[tbls]
        if[0 = type tbls;
            :.z.s each tbls;
            ];

        if[98 <> type tbls;
            .qr.throw ".qr.raze.razeTable: all elements must be table";
            ];

        tbls
        };

    tblList:getTable[x];
    tblList:{@[{?[y;();0b;x!x]}[x];y;`$".qr.raze.razeTable: metas are not matched"]}[cols first tblList] each tblList;
    metas:meta each tblList;

    if[sum not 1_(~':) metas;
        .qr.throw ".qr.raze.razeTable: metas are not matched";
        ];

    raze tblList
    };

.qr.raze.razeDict:{
    tblList:{flip (key x) ! enlist each value x} each x;
    flip .qr.raze.razeTable tblList
    };