//////////////////////////////////////////////////////////////////////////////////////////////
//dict.q - contains utility function for dictionary operation
///
//

.qr.dict.isDict:{[dict]
    99h=type dict
    };

.qr.dict.isNonKeyedTblDict:{[dict]
    $[.qr.dict.isDict[dict];
        98h<>type value dict;
        0b]
    };

.qr.dict.isColDict:{[dict]
    $[.qr.dict.isDict[dict];
        @[{98h=type 0!flip x}; dict; 0b];
        0b]
    };