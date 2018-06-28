//////////////////////////////////////////////////////////////////////////////////////////////
//mat.q - contains linear algebra function
///
//

.qr.mat.zeros:{[m;n]
    (m;n)#0f
    };

.qr.mat.identity:{[n]
    "f"${x=/:x} til n
    };

.qr.mat.diag:{
    (2#count x)#raze x,'(2#count x)#0f
    };

.qr.mat.rand:{[m;n;rng]
    m#n cut .qr.rng.uniform[rng;m*n]
    };

.qr.mat.diagVec:{[A]
    .qr.mat.subDiagVec[A;0]
    };

.qr.mat.subDiagVec:{[A;i]
    neg[i] _ A @' i+til count A
    };

.qr.mat.solve:{[A;b]
    (inv A) mmu b
    };

.qr.mat.dim:{[A]
    (count A; count first A)
    };

.qr.mat.isSquare:{[A]
    dims:.qr.mat.dim[A];
    dims[0] = dims[1]
    };

.qr.mat.isTriDiag:{[A]
    res:A<>0;
    triDiagSum:sum sum each .qr.mat.subDiagVec[res] each (-1 0 1);
    totalSum:sum sum res;

    0 = totalSum-triDiagSum
    };

.qr.mat.isDiagDominant:{[A]
    diagVec:.qr.mat.diagVec[A];
    diagA:.qr.mat.diag diagVec;
    "b"$(prd/) abs[diagVec] > sum each abs(A-diagA)
    };

.qr.mat.det:{[A]
    .qr.mat.priv.checkSquare[A];

    .qml.mdet[A]
    };

.qr.mat.minors:{[A]
    {k:til x; .qr.mat.det A[k;k]} each 1 + til count[A]
    };

.qr.mat.isPosDef:{[A]
    (and/) .qr.mat.minors[A] > 0
    };

.qr.mat.isPosSemiDef:{[A]
    (and/) .qr.mat.minors[A] >= 0
    };

.qr.mat.QR:{[A]
    .qr.mat.priv.checkSquare[A];

    `Q`R!.qml.mqr[A]
    };

.qr.mat.LUP:{[A]
    .qr.mat.priv.checkSquare[A];

    if[.qr.mat.isTriDiag[A] and .qr.mat.isDiagDominant[A];
        :.qr.mat.crout[A];
        ];

    res:`L`U`P!.qml.mlup[A];
    res[`P]:"f"$res[`P] =\: til count[A];
    res};

.qr.mat.PLU:{[A]
    // first do LUP decomp, then PA = LU
    // then A = (inv P) LU
    // inverse of permuation matrix is its transpose
    res:.qr.mat.LUP[A];
    res[`P]:flip res[`P];
    res};

.qr.mat.crout:{[A]
    n:count A;
    res:`L`U!();
    res[`L]:.qr.mat.diag n#1f;
    res[`U]:.qr.mat.zeros[n;n];
    res[`U;0;0]:A[0;0];

    calcFun:{[A;res;i]
        res[`U;i;i+1]:A[i;i+1];
        res[`L;i+1;i]:A[i+1;i] % res[`U;i;i];
        res[`U;i+1;i+1]:A[i+1;i+1]-res[`L;i+1;i]*res[`U;i;i+1];
        res}[A];

    res calcFun/ -1 _ til n
    };

.qr.mat.SVD:{[A]
    `U`S`V!.qml.msvd[A]
    };

.qr.mat.chol:{[A]
    .qr.mat.priv.checkSquare[A];

    if[not A ~ flip A;
        .qr.throw ".qr.mat.chol: not symmetric";
        ];

    U:.qml.mchol[A];
    `L`U!(flip U;U)
    };

.qr.mat.eigen:{[A]
    `eigval`eigvec!.qml.mev[A]
    };

.qr.mat.priv.checkSquare:{[A]
    if[not .qr.mat.isSquare[A];
        .qr.throw ".qr.mat.priv.checkSquare: not square matrix."
        ];
    };