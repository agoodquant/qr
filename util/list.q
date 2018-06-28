//////////////////////////////////////////////////////////////////////////////////////////////
//list.q - contains utility function for list/vector
///
//

.qr.list.enlist:{
    $[0>type x;enlist x; x]
    };

.qr.list.join:{
    if[(count x) <> count y;
        .qr.throw ".qr.list.join: dimension does not match";
        ];

    x ,' y
    };

.qr.list.fill:{
    reverse fills reverse fills x
    };

.qr.list.slice:{
    k:count[x] & 0, (+\) y;
    res:k _ x;
    res where 0 <> count each res
    };

.qr.list.reshape:{
    x:.qr.raze.razeAll x;
    if[count[x] <> (*/) y;
        .qr.throw ".qr.list.reshape: dimension does not match";
        ];

    ({y cut x}/)[x;-1 _ reverse y]
    };

.qr.list.dim:{
    x:(raze\) x;
    dimX:{count each x} each x;
    if[0 <> sum sum each dimX <> {first x} each dimX;
        .qr.throw ".qr.list.dim: inconsistent shape. cannot determine";
        ];
    (%':) count each x
    };

.qr.list.bin:{[start;end;nbin]
    increment:(end-start) % nbin;
    start + (end-start) & increment * 1 + til nbin
    };