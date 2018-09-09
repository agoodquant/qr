// dependency
.qinfra.cleanDep[];
.qinfra.loadDep[`env;"Q:/qr/env"];
.qinfra.loadDep[`quant;"Q:/qr/quant"];
.qinfra.listDep[]

// load project
.qinfra.load["env"];
.qinfra.load["thirdparty"];
.qinfra.load["quant"];
.qinfra.load["util"];
.qinfra.include["quant"; "random.q"];
.qinfra.clean[`.qr];
.qinfra.reload[];
.qinfra.listModule[]

// test host.q
.qr.host[]
.qr.ipAddr[]
.qr.pid[]
.qr.pwd[]

// test exectrl.q
.qr.trycatch[{x+y};(1;2);{'x}]
.qr.trycatch[.qml.msvd;enlist (0 1 2f;-1 0 -3f;2 1 7f); {'x}]
.qr.trycatch[{[x;y] '`hello};(1;2);{show "error catch: ", .qr.type.toString[x]}]
.qr.trycatch[{'`error};enlist (::);{show "error catch: ", .qr.type.toString[x]}]
.qr.trycatch[{[x] '`error};enlist 1;{show "error catch: ", .qr.type.toString[x]}]
.qr.getFuncDef[`.qr.exist]
.qr.trycatch[`.qr.exist;enlist `qr.exist;{'x}]
.qr.getFuncDef[{'`error}]

// test logger.q
.qr.setSev[`INFO]
.qr.setSev[`ERROR]
.qr.addLogHandle["C:/Users/user/Desktop/Document/dev/KDB+/log/qr/test.log";`SILENT`DEBUG`INFO];
.qr.addLogHandle["C:/Users/user/Desktop/Document/dev/KDB+/log/qr/testErr.log";`WARN`ERROR`FATAL];
.qr.setLogConsole[]
.qr.removeLogHandleAll[]

.qr.console "info"
.qr.debug "debug"
.qr.silent "silent"
.qr.warn "warning"
.qr.throw "error"
.qr.fatal "fatal error"

// test params.q
.qr.setParams[.qr.param[`test; `$"hello"]];
.qr.listParam[]
.qr.getParam[`test]

// test R
.qr.R.open[]
.qr.R.eval "a=array(1:24,c(2,3,4))"
.qr.R.get "dim(a)"
.qr.R.get "a"
.qr.R.set["xyz";1 2 3i]
.qr.R.get "xyz"

.qr.R.install["Matrix"];
.qr.R.include["Matrix"];
.qr.R.include["lpSolve"];

.qr.R.set["A";.qr.mat.rand[10;10;`.qr.rng.rand]];
.qr.R.eval "M <- matrix(unlist(A), ncol=10, byrow=TRUE)";
.qr.R.get "as.list(M)";
.qr.R.eval "res <- expand(lu(M))"
`P`L`U!(.qr.R.get "as.list(res$P)";.qr.R.get "as.list(res$L)";.qr.R.get "as.list(res$U)")

.qr.R.get "as.list(res$P)"
.qr.R.get "split(M, rep(1:ncol(M), each = nrow(M)))";
.qr.R.get "split(M, col(M))"

//test type.q
.qr.type.toString[`hello]
.qr.type.toString (`hello;`world)
.qr.type.toSymbol ("hello";"world")
.qr.type.mergeSym[`hello;`world]
.qr.type.list[]
.qr.type.toBits[1]
.qr.type.bitsTo["j"] .qr.type.toBits[1]
.qr.type.toBytes each "hello"
.qr.type.bytesTo["c"] each .qr.type.toBytes each "hello"
.qr.type.bytesTo["j"] .qr.type.toBytes 123i
.qr.type.toBase[2;(101b)]
.qr.type.toBase[3;(1 2 1)]

//test dict.q
tbl:([] a:1 2 3; b:`a`b`c)
dict:`a`b!(1 2 3; `a`b`c)
dict2:`a`b!1 2
.qr.dict.isDict[dict]
.qr.dict.isDict[`a xkey tbl]
.qr.dict.isNonKeyedTblDict[`a xkey tbl]
.qr.dict.isColDict each (flip tbl;dict;dict2)
.qr.tbl.isNonEmptyTbl each (tbl;delete from tbl)
.qr.tbl.isKeyed[`a xkey tbl]

// test remote.q
.qr.remote.rpc["localhost:26041"] "show `hello"
.qr.remote.arpc["localhost:26041"] "show `hello"
.qr.remote.lrpc["localhost:26041"] "show `hello"
.qr.remote.list[]
.qr.remote.close "localhost:26041"

// test namespace.q
.qr.ns.isNamespace[`.qr]
.qr.ns.subspace[`.qr]
.qr.ns.subspaceRecursive[`.qr]

// test reflection.q
.qr.ns.ls[`.qr]
.qr.ns.lsr[`.qr]
.qr.ns.ls[`.qr]
.qr.ns.ls[`.qr.complex]
exec val from .qr.ns.lsr[`.qr] where (namespace=`.qr) and subspace=`dist.exp.pdf

// test memoize.q
squareMatrix:{[n]
    (n;n)#til n*n
    };

squareMatrix2:{[n]
    10*(n;n)#til n*n
    };

.qr.mem.clear[]
.qr.mem.setMax[5000] //set to 5KB
.qr.mem.list[]
.qr.mem.adjust[0]
exec sum size from .qr.mem.list[]

.qr.mem.memoize[`squareMatrix] each 1+til 10;
.qr.mem.memoize[`squareMatrix;5];
.qr.mem.memoize[`squareMatrix;1];
.qr.mem.memoize[`squareMatrix2] each 1+til 20;
.qr.mem.memoize[`squareMatrix] 10

// test stat.q
seq1:til 10
seq2:reverse til 10

seq1:rand each 100#100
seq2:rand each 100#100

seq1:1+til 50
seq2:log seq1
.qr.stat.pearsonCor[seq1;seq2]
.qr.stat.spearmanCor[seq1;seq2]

avg normSeq
.qr.stat.sampleVar[seq1]
.qr.stat.sampleCov[seq1;seq2]
.qr.stat.skew[seq1]
.qr.stat.kurt[seq1]

.qr.stat.sampleVar[normSeq]
.qr.stat.skew[normSeq]
.qr.stat.kurt[normSeq]

// test rng.q
([] x:.qr.rng.uniform[`.qr.rng.rand;3000];
    y:.qr.rng.uniform[`.qr.rng.rand;3000])

.qr.rng.uniform[.qr.rng.rand;1]

([] x:.qr.rng.uniform[`.qr.rng.halton[2];3000];
    y:.qr.rng.uniform[`.qr.rng.halton[17];3000])

flip (enlist `x)!enlist .qr.rng.uniform[`.qr.rng.rand;10000]
flip (enlist `x)!enlist .qr.rng.uniform[`.qr.rng.halton[2];10000]

flip (enlist `x)!enlist .qr.rng.normBM[0;1;`.qr.rng.rand;`.qr.rng.rand;5000000];
flip (enlist `x)!enlist .qr.rng.normBM[0;1;.qr.rng.halton[2];.qr.rng.halton[3];50000]

flip (enlist `x)!enlist .qr.rng.normBMP[0;1;`.qr.rng.rand;`.qr.rng.rand;5000000];

.qr.rng.normBM[0;1;`.qr.rng.rand;`.qr.rng.rand;50000]
.qr.rng.normICDF[0;1;`.qr.rng.rand;50000]

// test probdist.q
([] poissonDist:.qr.dist.poisson.cdf[10] each til 25)
([] binDist:.qr.dist.bin.cdf[25;0.5] each til 26)

.qr.dist.bin.pdf[1;0.5;1]
.qr.dist.bin.pdf[6;0.3;3]
.qr.dist.bin.pdf[25;0.5;0]

.qr.dist.bin.cdf[25;0.5] each til 25
.qr.dist.bin.pdf[100;0.5;50]
.qr.dist.bin.pdf[1;0.5;0]

([] negBinomialDist:.qr.dist.negBin.pdf[2;0.5] each til 25)
([] negBinomialDist:.qr.dist.negBin.cdf[2;0.5] each til 25)

([] negBinomialDist:.qr.dist.geo.pdf[0.5] each til 25)
([] negBinomialDist:.qr.dist.geo.cdf[0.5] each til 25)

.qr.dist.negBin.pdf[5;0.4;5]
.qr.dist.geo.pdf[0.5;0]

.qr.math.erf 1
([] x:.qr.dist.normal.pdf[0;1] -3 + 0.1 * 1+til 60)
([] x:.qr.dist.normal.cdf[0;1] -3 + 0.1 * 1+til 60)
([] x:.qr.dist.stdNormal.pdf -3 + 0.1 * 1+til 60)
([] x:.qr.dist.stdNormal.cdf -3 + 0.1 * 1+til 60)

([] .qr.dist.skewNormal.pdf[5;0;1] -3 + 0.1 * 1+til 60)

([] x:.qr.dist.lognormal.pdf[0;0.5] 0.1 * 1 + til 30)
([] x:.qr.dist.lognormal.cdf[0;0.5] 0.1 * 1 + til 30)

([] x:.qr.dist.exp.pdf[1.5] 0.1 * 1 + til 50)
([] x:.qr.dist.exp.cdf[1.5] 0.1 * 1 + til 50)

.qr.math.erf[1]
.qr.math.erfInv[0.8427007]
.qr.math.erfInv[-0.8]
.qr.dist.stdNormal.cdfInv[0.975]
.qr.dist.normal.pdf[0;1;0.025]

.qml.nicdf 1000000#0.975;
.qr.dist.stdNormal.cdfInv 1000000#0.975;
.qr.math.erfInv 1000000#0.975;

([] x:.qr.dist.levy.pdf[0;0.5] 0.01 * til 300;
    y:.qr.dist.levy.pdf[0;1] 0.01 * til 300;
    z:.qr.dist.levy.pdf[0;2] 0.01 * til 300)
([] x:.qr.dist.levy.cdf[0;0.5] 0.01 * til 300)

// test binary.q
.qr.bit.shiftLeft[01010b;1]
.qr.bit.shiftRight[01010b;1]
.qr.bit.xor[01010b;11000b]

// test numeric.q
m:(1.1 2.1 3.1; 2.3 3.4 4.5; 5.6 7.8 9.8)
inv m

.qr.numeric.delta[{(x*x)-5*x};3;`central]
.qr.numeric.convexity[{(x*x)-5*x};3]

.qr.numeric.newton[{(x*x)-5*x};{(2*x)-5};100]
.qr.numeric.newton[{(x*x)-5*x};.qr.numeric.delta[{(x*x)-5*x};;`central];100] // use numerical gradient

.qr.numeric.bisection[{(x*x)-5*x};3;9]
.qr.numeric.bisection[{((x*x)-3*x)+2};1.5;5]

.qr.numeric.bisection[{(5*x)-x*x};3;9]
.qr.numeric.newton[{(5*x)-x*x};{5-2*x};3]

.qr.numeric.newton[{(x*x)-5*x};{(2*x)-5};100]
.qr.numeric.bisection[{(x*x)-5*x};3;9]

pts:("f"$1+til 10);
ptsInterp:(-1.0;1.0;1.2;2.3;3.4;4.5;5.6;6.7;10.0;11.0);
values:{(x*x)-5*x} 1+til 10;
.qr.numeric.interp[values;pts;ptsInterp]
res:([] x:pts,ptsInterp; yInt:values, .qr.numeric.interp[values;pts;ptsInterp])
res:`x xasc update yAct:{(x*x)-5*x} x from res
res:update yInt:"f"$yInt from res
select yInt, yAct from res

// test integral
.qr.numeric.simpson[{1 % x};1;3]

.qr.numeric.integral[{1 % x};1;3]

.qr.numeric.integral[{(x xexp 0.5) * exp neg x};0;100] //0.8862269
.qr.math.gamma[1.5] // 0.8862269

.qr.numeric.integral[{(x xexp -0.5) * exp neg x};0;100] // singularity
.qr.numeric.integral[{(x xexp -0.5) * exp neg x};1e-16;100] // 1.7724542, numeric err
.qr.math.gamma[0.5] // 1.7724539

.qr.numeric.integral[{(x xexp y-1) * exp neg x}[;2.5];0;100] //1.3293404
.qr.math.gamma[2.5] // good

sum .qr.dist.bin.pdf[100;0.5] each til 51
.qr.math.betaIncomp[50;51;0.5] % .qr.math.beta[50;51]

.qr.math.beta[6;4]
.qr.math.gamma[6] * .qr.math.gamma[4] % .qr.math.gamma[10]

.qr.math.betaIncomp[51;50;0.5] // exploded
.qr.math.betaIncomp[2;1;0.5]

sum .qr.dist.bin.pdf[100;0.5] each til 50
.qr.math.betaIncompRegularised[51;50;0.5]

.qr.math.beta[3;2]
exp .qr.math.priv.logBeta[3;2]

.qr.math.gammaIncompL[2;3.0]

// Qschema
test2:([] Continent:`NorthAmerica`Asia`Asia`Europe`Europe`Africa`Asia`Africa`Asia;
	 Country:("US";"China";"japan";"Germany";"UK";"Zimbabwe";"Bangladesh";"Nigeria";"Vietnam");
	 Population:313847 1343239 127938 81308 63047 13010 152518 166629 87840;
	 GDP:15080.0 11300.0 4444.0 3114.0 2228.0 9.9 113.0 196.0 104.0;
	 GDPperCapita:`48300`8400`34700`38100`36500`413`1788`732`3359 ;
	 LifeExpectancy:`77.14`72.22`80.93`78.42`78.16`39.01`61.33`51.01`70.05)

// test schema.q
.qr.schema.addTbl[`sampleTbl;
    .qr.schema.addCol[`ticker;"symbol"],
    .qr.schema.addCol[`tradetime;"datetime"],
    .qr.schema.addCol[`price;"float"],
    .qr.schema.addCol[`size;"float"],
    .qr.schema.addCol[`lastFivePrices;"floats"],
    .qr.schema.addCol[`ammendment;"chars"]
    ];

.qr.schema.addTbl[`test1;
    .qr.schema.addCol[`Continent;"symbol"],
    .qr.schema.addCol[`Country;"symbol"],
    .qr.schema.addCol[`Population;"symbol"],
    .qr.schema.addCol[`GDP;"symbol"],
    .qr.schema.addCol[`GDPperCapita;"symbol"],
    .qr.schema.addCol[`LifeExpectancy;"symbol"]
    ];

.qr.schema.addTbl[`test2;
    .qr.schema.addCol[`Continent;"symbol"],
    .qr.schema.addCol[`Country;"symbols"],
    .qr.schema.addCol[`Population;"float"],
    .qr.schema.addCol[`GDP;"floats"],
    .qr.schema.addCol[`GDPperCapita;"float"],
    .qr.schema.addCol[`LifeExpectancy;"floats"]
    ];

.qr.schema.addTbl[`test3;
    .qr.schema.addCol[`Continent;"symbol"],
    .qr.schema.addCol[`Country;"symbols"],
    .qr.schema.addCol[`Population;"float"],
    .qr.schema.addCol[`GDP;"floats"],
    .qr.schema.addCol[`GDPperCapita;"float"],
    .qr.schema.addCol[`LifeExpectancy;"float"]
    ];

.qr.schema.addTbl[`test4;
    .qr.schema.addCol[`Continent;"char"],
    .qr.schema.addCol[`Country;"char"],
    .qr.schema.addCol[`Population;"int"],
    .qr.schema.addCol[`GDP;"int"],
    .qr.schema.addCol[`GDPperCapita;"int"],
    .qr.schema.addCol[`LifeExpectancy;"float"]
    ];

.qr.schema.getEmptyTbl[`sampleTbl]
.qr.schema.getEmptyTbl[`test3]
.qr.schema.getEmptyTbl[`test4]
.qr.schema.priv.getSchema[`test4]

.qr.schema.getSchemaCodes[test2]
.qr.schema.formatTbl[`test1;test2]
.qr.schema.formatTbl[`test2;test2]
.qr.schema.formatTbl[`test3;test2]
.qr.schema.formatTbl[`test4;test2]
.qr.schema.formatTbl[`test4;.qr.schema.formatTbl[`test3;test2]]


// test list.q
.qr.list.enlist[1]
.qr.list.enlist[(1;2)]
.qr.list.join[(1;2;3);(10;20;30)]
.qr.list.fill[(0n;0n;0n;0n;3;4;0n;0n;5;6)]
.qr.list.slice[til 10; (1;3;6)]
.qr.list.slice[til 10; (1;3;5;6;8;10)]
.qr.list.reshape[til 2*3*4; (4;3;2)]
.qr.list.dim .qr.list.reshape[til 2*3*4; (4;3;2)]
.qr.list.dim ((0 1j;2 3j;4 5 6j);(6 7j;8 9j;10 11j);(12 13j;14 15j;16 17j);(18 19j;20 21j;22 23j)); //should fail
.qr.list.bin[2;10;5]

// test table.q
.qr.tbl.prepends[`;`prod;test2]
test3:.qr.tbl.prepends[`Continent;`prod;test2]
test4:.qr.tbl.prepends[`Continent;`qa;test2]
.qr.tbl.lj[`Continent;test3;test4]
test:([] x:("a|b|c";"c|e|f"); y: 12 20f; z:("hello";"world"))
test:([] x:("a|b|c";"a|b|c"); y: 12 20f; z:("hello";"world"))
.qr.tbl.splitCol[test;`x;"|"]

// test shim.q
testFunc:{x+y}
testFunc2:.qr.dist.normal.cdf;
.qr.shimming.shim[`testFunc;{x*y}]
.qr.shimming.shim[`testFunc2;.qr.dist.lognormal.cdf]
testFunc[2;3]
.qr.shimming.unshim[`testFunc]
.qr.shimming.unshim[`testFunc2]
.qr.shimming.unshimAll[]
.qr.shimming.list[]

// test qtracer.q
testFunc:{testFunc2[x;y]}
testFunc2:{x+y}
testFunc2:{[x;y] .qr.throw "a bug :(";};

.qr.qtracer.unwrapAll[]
.qr.qtracer.wrap[`.qr.dist];
.qr.qtracer.wrap[`.qr.remote];
.qr.qtracer.wrap[`.qr];
.qr.qtracer.unwrap[`.qr];
.qr.dist.normal.cdf[0;1;0]

// test raze.q
.qr.raze.razeAll(1;(2;3;4);(((4;5);6);7))

tbl1:([] a:1+til 3; b:10*1+til 3; c:`a`b`c)
tbl2:([] a:4+til 3; b:10*4+til 3; c:`d`e`f)
.qr.raze.razeTable[(tbl1;`c`a`b xcols tbl2; `b`a`c xcols tbl1)]

dict1:(`a`b`c)!(1;2;3)
dict2:(`c`b`a)!(10;20;30)
.qr.raze.razeDict[(dict1;dict2)]

 //test math.q
.qr.math.factorial[5]
.qr.math.comb[6;2]
.qr.math.gamma[0]
.qr.math.gamma[-1]
.qr.math.gamma[-0.5]
.qr.math.gamma[-1.5]
.qr.math.gamma[0.5]
.qr.math.gamma[1.5]


.qr.math.beta[1.5;0.5]
.qr.math.betaIncomp[1.5;0.5;0.999]
.qr.math.betaIncomp[1.5;0.5;0.01]

([] x:.qr.dist.t.pdf[1] -3 + 0.1 * 1+til 60;
    y:.qr.dist.t.pdf[3] -3 + 0.1 * 1+til 60;
    z:.qr.dist.t.pdf[5] -3 + 0.1 * 1+til 60)

([] x:.qr.dist.t.cdf[1] each -3 + 0.1 * 1+til 60;
    y:.qr.dist.t.cdf[3] each -3 + 0.1 * 1+til 60;
    z:.qr.dist.t.cdf[5] each -3 + 0.1 * 1+til 60)

([] x:.qr.dist.beta.pdf[0.5;0.5] 0.01 * 1+til 99;
    y:.qr.dist.beta.pdf[5;1] 0.01 * 1+til 99;
    z:.qr.dist.beta.pdf[1;3] 0.01 * 1+til 99;
    g:.qr.dist.beta.pdf[2;5] 0.01 * 1+til 99)

([] x:.qr.dist.beta.cdf[0.5;0.5] each 0.01 * 1+til 99;
    y:.qr.dist.beta.cdf[5;1] each 0.01 * 1+til 99;
    z:.qr.dist.beta.cdf[1;3] each 0.01 * 1+til 99;
    g:.qr.dist.beta.cdf[2;5] each 0.01 * 1+til 99)

([] x:.qr.dist.t.cdf[1] each -3 + 0.1 * 1+til 60;
    y:-3 + 0.1 * 1+til 60)

.qr.dist.beta.cdf[0.5;0.5;0.6]
.qr.dist.beta.cdfInv[0.5;0.5;0.5640942]

.qr.dist.t.cdf[1;0.6]
.qr.dist.t.cdfInv[1;0.6720209]

// complex number fun
a:(`real`imaginary)!(1;2) // 1+2i

b:(`real`imaginary)!(2;3) // 2+3i

.qr.complex.number[1;2]

.qr.complex.add[a;b]
.qr.complex.minus[a;b]
.qr.complex.multiply[a;b]
.qr.complex.multiply[a;2]
.qr.complex.reciprocal[a]
.qr.complex.multiply[a;.qr.complex.reciprocal[b]]
.qr.complex.divide[a;b]

.qr.complex.exp[a]
.qr.complex.sinh[a]
.qr.complex.cosh[a]
.qr.complex.tanh[a]
.qr.complex.divide[.qr.complex.sinh[a];.qr.complex.cosh[a]]

x:(.qr.complex.number[1;0]; .qr.complex.number[2;-1]; .qr.complex.number[0;-1]; .qr.complex.number[-1;2])
fourierX:.qr.complex.dft[x] each til count x
.qr.complex.idft[fourierX] each til count fourierX

([] binomial:.qr.dist.bin.pdf[10;0.5] each til 11;
    poissonBin:.qr.dist.poissonBin.pdf[10#0.5] each til 11)

sum .qr.dist.bin.pdf[10;0.5] each til 5
sum .qr.dist.poissonBin.pdf[10#0.5] each til 5
.qr.dist.poissonBin.cdf[10#0.5;4]

sum .qr.dist.bin.pdf[100;0.5] each til 51
.qr.dist.poissonBin.cdf[100#0.5;50]


// test mat.q
.qr.mat.solve[(0 1 2f; -1 0 -3f; 2 1 7f);(3 -2 5f)]
.qr.mat.zeros[5;3]
.qr.mat.identity[5]

A:(0 1 2f;-1 0 -3f;2 1 7f);
A:flip (1 1f;5 9f;1 0f;1 0f);
A:.qr.mat.diag[10#1f]; A[3;5]:0.5;
A:(2 1 0f;1 -5 3f;0 2 3f);
A:(2 1 0f;-3 -5 3f;0 2 3f);
A:(16 4 4 -4f;4 10 4 2f;4 4 6 -2f;-4 2 -2 4f)

.qr.mat.dim[A]
.qr.mat.isSquare[A]
.qr.mat.diag[(1 2 3 4 5)]
.qr.mat.diagVec .qr.mat.diag[(1 2 3 4 5)]
.qr.mat.diagVec[A]
.qr.mat.subDiagVec[A;-1]
.qr.mat.isDiagDominant[A]
.qr.mat.rand[10;10;`.qr.rng.rand]
.qr.mat.isTriDiag[A]

A:.qr.mat.rand[1000;1000;`.qr.rng.rand];
LU:.qr.mat.crout[A]

LUP:.qr.mat.LUP[A]
sum sum (LUP[`P] mmu A) - LUP[`L] mmu LUP[`U]

PLU:.qr.mat.PLU[A]
sum sum A - PLU[`P] mmu PLU[`L] mmu PLU[`U]

QR:.qr.mat.QR[A]
sum sum A - QR[`Q] mmu QR[`R]

A:.qr.mat.diag[1000#1f]; A[2;3]:0.5; A[3;2]:0.5
LU:.qr.mat.chol[A]
sum sum A - LU[`L] mmu LU[`U]

SVD:.qr.mat.SVD[A]
sum sum A - SVD[`U] mmu SVD[`S] mmu flip SVD[`V]

.qr.mat.det[(-2 2 -3f;-1 1 3f; 2 0 -1f)]
.qr.mat.det[(2 5 -3 -2f;-2 -3 2 -5f; 1 3 -2 0f; -1 -6 4 0f)]
.qr.mat.det[A]

A:.qr.mat.diag[10#1f];
.qr.mat.eigen[A]
.qr.mat.minors[A]
.qr.mat.isPosDef[A]
A[1;1]:0f;
.qr.mat.isPosSemiDef[A]

// test lp, linear programming
A:(0 1 2f;-1 0 -3f;2 1 7f);
b:(3 -2 5f);
c:(1 1 5f);
constr:`ge`ge`ge;
xconstr:`ge`ge`ge;
.qr.lp.solve[b;A;c;constr;xconstr;`min] // Soln: 0 2/3 1 with v=11/3

A:flip (-1 5 2 5f; 0 3 0 1f; -1 0 1 2f);
c:(0 5 1 4f);
b:(5 2 1f);
constr:`le`eq`eq;
xconstr:`ge`ge`none`ge;
.qr.lp.solve[c;A;b;constr;xconstr;`max] // Soln 1 0 -2 2 with v = 6

A:(-1 -2 1 1f; -4 1 -1 1f; 0 -3 0 1f; 1 -1 -3 1f; 1 1 1 0f);
c:(0 0 0 1f);
b:(0 0 0 0 1f);
constr:`ge`ge`ge`eq;
xconstr:`ge`ge`ge`ge`none;
.qr.lp.solve[b;A;c;constr;xconstr;`min] // 14/35 8/35 0 13/35 33/35(lambda) with v = 33/35

// not possible. should be infeasible
A:flip (1 1f;5 9f;1 0f;1 0f);
c:(6 45 2 4f);
b:(5 8f);
constr:`le`le`le`ge;
xconstr:`ge`ge;
dir:`max;
.qr.lp.solve[b;A;c;constr;xconstr;dir] // infeasible

// flip the sign
A:flip (1 1f;5 9f;1 0f);
c:(6 45 6);
b:(5 8f);
constr:`le`le`ge;
xconstr:`ge`ge;
dir:`max;
.qr.lp.solve[b;A;c;constr;xconstr;dir] // 6 0 with v = 30

//flip the sign
A:flip (1 1f;5 9f;1 0f;0 1f);
c:(6 45 2 4f);
b:(5 8f);
constr:`le`le`le`ge;
xconstr:`ge`ge;
dir:`max;
.qr.lp.solve[b;A;c;constr;xconstr;dir] // 1.8 4 with v = 41

// all equal constraint
A:flip (1 -2 1 0f;2 1 0 1f);
c:(2.5 1.5f);
b:(-3 -2 0 0f);
constr:`eq`eq;
xconstr:`ge`ge`ge`ge;
dir:`max;
.qr.lp.solve[b;A;c;constr;xconstr;dir] // 0 0 2.5 1.5 with v = 0

// super corner case
A:flip enlist (1 1 1 1 1f);
c:enlist 10f;
b:(1 1 0 0 0f);
constr:enlist `eq;
xconstr:`ge`ge`none`none`none;
.qr.lp.solve[b;A;c;constr;xconstr;`min] //0 0 10 0 0 0 0 0 with v = 0

lp:.tmp.lp
count lp[`err]

// test ip, integer programming and mixed integer programming
A:(1 1f;5 9f);
c:(6 45f);
b:(5 8f);
constr:`le`le;
xconstr:`ge`ge;
dir:`max;
.qr.ip.solve[b;A;c;constr;xconstr;dir] // 6 0 with v = 30

A:flip (1 -2 1 0f;2 1 0 1f);
c:(2.5 1.5f);
b:(-3 -2 0 0f);
constr:`eq`eq;
xconstr:`ge`ge`ge`ge;
dir:`max;
iconstr:0110b;
.qr.mip.solve[b;A;c;constr;xconstr;iconstr;dir] // 0.5 0 2 0.5 with v = -1.5

A:flip (1 2 1 0f;2 1 0 1f);
c:(2.5 1.5f);
b:(3 2 0 0f);
constr:`ge`ge;
xconstr:`ge`ge`ge`ge;
dir:`max;
iconstr:0110b;
.qr.mip.solve[b;A;c;constr;xconstr;iconstr;dir] // unbounded feasible

// binary programming
A:flip (-3 -3 1 2 3f; -5 -3 -2 -1 1f);
b:(-8 -2 -4 -7 -5f);
c:(-2 -4f);
constr:`le`le;
dir:`max;
.qr.bip.solve[b;A;c;constr;dir;`explicit] // explicit 01100b with v = -6
.qr.bip.solve[b;A;c;constr;dir;`implicit] // implicit 01100b with v = -6

A:flip (-1 -1 -1 -2 -3f; -1 -1 -1 -2 -1f);
b:(-8 -2 -4 -7 -5f);
c:(-2 -4f);
constr:`le`le;
dir:`min;
.qr.bip.solve[b;A;c;constr;dir;`explicit] // explicit 1 1 1 1 1f with v = -26
.qr.bip.solve[b;A;c;constr;dir;`implicit] // implicit 11111b with v = -26

b:0.7700431 0.7778214 0.7856781 0.7936143 8.7817807 0.8097279 0.8179069 0.8261686 0.8345138 0.8429432 0.9320653 0.9414801 0.95099 0.960596 0.970299 0.9801 0.99;
c:enlist 4426;
A:"f"$flip enlist 28 58 104 166 244 338 448 574 716 874 28 58 104 166 244 338 448;
constr:enlist `le;
xconstr:count[b]#`ge;
n:count b;
.qr.bip.solve[b;A;c;constr;`max;`implicit] // 11111110111111111b with v = 21.9395598
.qr.bip.solve[b;A;c;constr;`max;`explicit] // slower than implicit
.qr.lp.solve[b;A;c;constr;count[b]#`ge;`max]
.qr.ip.solve[b;A;c;constr;count[b]#`ge;`max] // exploded!!

// test datetime.q
.qr.dt.yearSD[.z.d]
.qr.dt.monthSD[.z.d]
.qr.dt.weekSD[.z.d]
.qr.dt.weekDay[.z.d;1]
.qr.dt.dtToDate[.z.p]
.qr.dt.toGMT .qr.dt.toEST .z.p
.qr.dt.toEST .qr.dt.addHours[.z.p;1]
.qr.dt.toEST .qr.dt.addMins[.z.p;5]
.qr.dt.toEST .qr.dt.addSec[.z.p;10]
.qr.dt.toEST .qr.dt.addMilliSec[.z.p;2]
.qr.dt.toEST .qr.dt.addSec[.z.p;0.000001]
.qr.dt.addSec[.z.p;0.000001] = .qr.dt.addMilliSec[.z.p;1]

// test timer.q
test2:{x+y}
.qr.timer.priv.execFunc[`test2;(2;3);1]
.qr.timer.priv.execFunc[{x*x};2;1]

.qr.timer.start[{show "timer1"};enlist (::);3000]
.qr.timer.start[{show "timer2"};enlist (::);5000]
.qr.timer.startAbs[{show "timer3"};enlist (::);.z.p+.qr.timer.priv.getMillisecond 6000]
.qr.timer.startAbs[{show "timer4"};enlist (::);.z.p+.qr.timer.priv.getMillisecond 20000]
.qr.timer.forwardStart[{show "timer5"};enlist (::);.z.p+ .qr.timer.priv.getMillisecond 5000;4000]
.qr.timer.list[]
.qr.timer.removeAll[]
.qr.timer.removeByFunctor[{show "timer3"}]
