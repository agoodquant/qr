//////////////////////////////////////////////////////////////////////////////////////////////
//stat.q - contains basic statistical function
///
//

.qr.stat.pearsonCor:{
    if[(n:count x) <> count y;
        .qr.throw ".qr.stat.pearsonCor: dimension not matched";
        ];

    meanX:avg x;
    meanY:avg y;
    covXY:(sum x*y)-n*meanX*meanY;
    varX:(sum x*x) - n*meanX*meanX;
    varY:(sum y*y) - n*meanY*meanY;
    covXY % sqrt varX*varY
    };

.qr.stat.spearmanCor:{
    .qr.stat.pearsonCor[rank x;rank y]
    };

.qr.stat.sampleCov:{
    if[(n:count x) <> count y;
    .qr.throw ".qr.stat.sampleCov: dimension not matched";
    ];

    covXY:(sum x*y)-n*(avg x)*avg y;
    covXY % n-1
    };

.qr.stat.sampleVar:{
    n:count x;
    meanX:avg x;
    varX:(sum x*x)-n*meanX*meanX;
    varX % n-1
    };

.qr.stat.stdErr:{
    sqrt .qr.stat.sampleVar
    };

.qr.stat.skew:{
    n:count x;
    meanX:avg x;
    thirdMomX:sum xexp[(x-meanX);3];
    stdErrX:.qr.stat.sampleVar[x];

    biasedSkewX:(thirdMomX % xexp[stdErrX;3]);
    unbiasedSkewX:biasedSkewX * n % (n-1) * (n-2);
    unbiasedSkewX
    };

.qr.stat.kurt:{
    n:count x;
    meanX:avg x;
    forthMomX:sum xexp[(x-meanX);4];
    varX:.qr.stat.sampleVar[x];

    biasedKurtX:forthMomX % xexp[varX;2];
    unbiasedKurtX:(biasedKurtX * (n+1) * n % (n-1)*(n-2)*(n-3))-3*(n-1)*(n-1)%(n-2)*(n-3)
    };

.qr.stat.ols:{
    x_t:flip x;
    beta:(y mmu x_t) mmu inv x mmu x_t;
    estRes:y-sum x * beta;
    estVar:sum estRes * estRes % (count y) - count beta;
    (`beta`estVar) ! (beta;estVar)
    };

.qr.stat.gls:{[X;Y;CovM]
    X_t:flip X;
    CovM_inv:inv CovM;
    beta:(Y mmu CovM_inv mmu X_t) mmu inv X mmu CovM_inv mmu X_t;
    estRes:y-sum x * beta;
    estVar:sum estRes * estRes % (count y) - count beta;
    (`beta`estVar) ! (beta;estVar)
    };