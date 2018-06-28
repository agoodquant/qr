//////////////////////////////////////////////////////////////////////////////////////////////
//schema.q - contains Util functions to construct table schema
///
//

.qr.schema.addTbl:{[tblNameIn;schemaIn]
    schemaIn:enlist flip schemaIn;
    $[0=count select from .qr.schema.priv.registerSchemas where tblName=tblNameIn;
        .qr.schema.priv.registerSchemas:.qr.schema.priv.registerSchemas, ([] tblName:tblNameIn; schema:schemaIn);
        update schema:schemaIn from `.qr.schema.priv.registerSchemas where tblName=tblNameIn];
    };

.qr.schema.addCol:{[colNameIn;typeNameIn]
    typeNameIn:.qr.toString typeNameIn;
    if[isListIn:"s"=typeNameIn[neg 1-count typeNameIn];
        typeNameIn:-1_typeNameIn;
        ];

    ([] colName:enlist colNameIn; typeNameIn:enlist typeNameIn; isList:enlist isListIn)
    };

.qr.schema.getEmptyTbl:{[tblNameIn]
    schema:flip .qr.schema.priv.getSchema[tblNameIn];
    numericType:{exec first numType from .qr.listTypes[] where dataType like x} each schema[`typeNameIn];
    numericType:"h"$numericType * (1 - 2*schema[`isList]);
    flip schema[`colName]!{x$()} each numericType
    };

.qr.schema.formatTbl:{[tblNameIn;tbl]
    schema:.qr.schema.priv.getSchema[tblNameIn];
    schema:update dataType:typeNameIn from schema;
    schema:0!.qr.tbl.lj[`dataType;schema;.qr.listTypes[]];
    schema:update numType:"h"$numType * (1-2*isList) from schema;
    getFormattingFunc:{[schema;col]
        if[not col in schema`colName;
            :col;
            ];

        schemaEntry:exec from schema where colName=col;
        castingFunc:$["char" ~ schemaEntry`typeNameIn;
                        $[schemaEntry`isList;(each;{enlist .qr.toString x}; col);(each;.qr.toString; col)];
                        $["symbol" ~ schemaEntry`typeNameIn;
                            $[schemaEntry`isList;(each;{.qr.list.enlist .qr.toSymbol x}; col); (.qr.toSymbol; col)];
                                $[schemaEntry`isList;(each;{.qr.list.enlist $[x=type y; y;
                                    $[11h = abs type y; neg[x]$.qr.toString y; x$y]]}[abs schemaEntry`numType]; col);
                                ({$[x=type y; y;
                                    $[11h = abs type y; neg[x]$.qr.toString y; x$y]]}[abs schemaEntry`numType]; col)
                            ]
                        ]
                    ];
        castingFunc};

    formattingFunc:getFormattingFunc[schema] each cols tbl;
    ?[tbl;();0b; (cols tbl) ! formattingFunc]
    };

.qr.schema.getSchemaCodes:{[tbl]
    columns:cols tbl;
    numTypes:type each tbl each columns;
    dataType:{exec first dataType from .qr.listTypes[] where numType=abs x} each numTypes;
    dataType:{$[y;x,"s";x]}'[dataType;numTypes<0];

    schemaCodes:{".qr.schema.addCol", "[", "`", (.qr.toString x), ";", "\"", y, "\"", "]"}'[columns;dataType];
    "," sv schemaCodes
    };

.qr.schema.priv.getSchema:{[tblNameIn]
    schema:flip exec first schema from .qr.schema.priv.registerSchemas where tblName=tblNameIn;
    if[0=count schema;
        .qr.throw ".qr.schema.priv.getSchema: schema ", (.qr.toString tblNameIn), " is not registered";
        ];

    schema
    };

.qr.schema.init:{
    if[not .qr.exist `.qr.schema.priv.registerSchemas;
        .qr.schema.priv.registerSchemas:([] tblName:`$(); schema:());
        ];
    };

.qr.schema.init[];