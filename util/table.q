//////////////////////////////////////////////////////////////////////////////////////////////
//table.q - contains utility function for table operation
///
//

.qr.tbl.isNonEmpty:{[tbl]
    $[not .qr.tbl.isKeyed[tbl] | 98h=type tbl; 0b; 0<>count tbl]
    };

.qr.tbl.isKeyed:{[tbl]
    $[.qr.dict.isDict[tbl]; 98h=type value tbl; 0b]
    };

.qr.tbl.lj:{[colsToJoin;lTbl;rTbl]
    if[not .qr.tbl.isNonEmpty[lTbl];
        .qr.throw ".qr.tbl.lj: left table is empty";
        ];

    if[not colsToJoin in cols lTbl;
        .qr.throw ".qr.tbl.lj: left table does not contains columns to join";
        ];

    if[not .qr.tbl.isNonEmpty[rTbl];
        .qr.warn ".qr.tbl.lj: right table is empty. Return left table";
        :colsToJoin xkey 0!lTbl;
        ];

    if[not colsToJoin in cols rTbl;
        .qr.throw ".qr.tbl.lj: right table does not contains columns to join";
        ];

    (colsToJoin xkey 0!lTbl) lj colsToJoin xkey 0!rTbl
    };

.qr.tbl.uj:{[lTbl;rTbl]
    if[not .qr.tbl.isNonEmpty[lTbl];
        .qr.warn ".qr.tbl.uj: left table is empty. Return right table";
        :0!rTbl;
        ];

    if[not .qr.tbl.isNonEmpty[rTbl];
        .qr.warn ".qr.tbl.uj: right table is empty. Return left table";
        :0!lTbl;
        ];

    (0!lTbl) uj 0!rTbl
    };

.qr.tbl.prepends:{[exceptCols;prefix;tbl]
    colsToAppended:(cols tbl) except exceptCols;
    appendedColList:.qr.type.mergeSym[prefix] each colsToAppended;
    $[null exceptCols; 0#`; exceptCols] xcols appendedColList xcol colsToAppended xcols tbl
    };

.qr.tbl.splitCol:{[t;c;delim]
    splitColTbl:ungroup ?[t;();0b;(`joinCol, c)!(`i;(each;{x vs y}[delim];c))];
    t:update joinCol:i from t;
    t:![t;();0b;enlist c];
    newTbl:0!.qr.tbl.lj[`joinCol; splitColTbl; t];
    newTbl:![newTbl;();0b;enlist `joinCol];
    newTbl};