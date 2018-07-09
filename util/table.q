//////////////////////////////////////////////////////////////////////////////////////////////
//table.q - contains utility function for table operation
///
//

.qr.tbl.isNonEmptyTbl:{[tbl]
    $[not .qr.tbl.isKeyedTbl[tbl] | 98h=type tbl; 0b; 0<>count tbl]
    };

.qr.tbl.isKeyedTbl:{[tbl]
    $[99h=type tbl;
        $[98h=type value tbl;1b;0b];
        0b]
    };

.qr.tbl.lj:{[colsToJoin;lTbl;rTbl]
    if[not .qr.tbl.isNonEmptyTbl[lTbl];
        .qr.throw ".qr.tbl.lj: left table is NOT non-empty table";
        ];

    if[not colsToJoin in cols lTbl;
        .qr.throw ".qr.tbl.lj: left table does not contains columns to join";
        ];

    if[not .qr.tbl.isNonEmptyTbl[rTbl];
        .qr.warn ".qr.tbl.lj: right table is NOT non-empty table. Return left table";
        :colsToJoin xkey 0!lTbl;
        ];

    if[not colsToJoin in cols rTbl;
        .qr.throw ".qr.tbl.lj: right table does not contains columns to join";
        ];

    (colsToJoin xkey 0!lTbl) lj colsToJoin xkey 0!rTbl
    };

.qr.tbl.uj:{[lTbl;rTbl]
    if[not .qr.tbl.isNonEmptyTbl[lTbl];
        .qr.warn ".qr.tbl.uj: left table is NOT non-empty table. Return right table";
        :0!rTbl;
        ];

    if[not .qr.tbl.isNonEmptyTbl[rTbl];
        .qr.warn ".qr.tbl.uj: right table is NOT non-empty table. Return left table";
        :0!lTbl;
        ];

    (0!lTbl) uj 0!rTbl
    };

.qr.tbl.prepends:{[exceptCols;prefix;tbl]
    exceptCols:.qr.list.enlist exceptCols;
    exceptCols:exceptCols where not null exceptCols;
    colsToAppended:(cols tbl) except exceptCols;
    exceptColsList:raze {(enlist x)! enlist x} each exceptCols;
    appendedColList:raze {[prefix;col](enlist .qr.type.toSymbol raze .qr.type.toString prefix, col)!enlist col}[prefix] each colsToAppended;
    transformColList:exceptColsList, appendedColList;
    ?[tbl;();0b;transformColList]
    };

.qr.tbl.splitCol:{[t;c;delim]
    splitColTbl:ungroup ?[t;();0b;(`joinCol, c)!(`i;(each;{x vs y}[delim];c))];
    t:update joinCol:i from t;
    t:![t;();0b;enlist c];
    newTbl:0!.qr.tbl.lj[`joinCol; splitColTbl; t];
    newTbl:![newTbl;();0b;enlist `joinCol];
    newTbl};