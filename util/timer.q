//////////////////////////////////////////////////////////////////////////////////////////////
//timer.q - contains utility function for scheduling
//

.qr.timer.start:{[func;params;freq]
    .qr.timer.forwardStart[func;
        params;
        .z.p + .qr.timer.priv.getMillisecond 3+freq; // give 3 ms buffer
        freq
        ];
    };

.qr.timer.startAbs:{[func;params;st]
    .qr.timer.priv.timers:.qr.timer.priv.timers,
        `id`func`params`initTime`nextRun`timerType`freq`executed!(
        1 + exec max id from .qr.timer.priv.timers;
        func; params;
        .z.p; st;
        `absolute; 0n;
        0b);

    .qr.timer.tick[];
    };

.qr.timer.forwardStart:{[func;params;st;freq]
    entry:`id`func`params`initTime`nextRun`timerType`freq`executed!(
        1 + exec max id from .qr.timer.priv.timers;
        func; params;
        .z.p; st;
        `relative; freq;
        0b);

    .qr.timer.priv.timers:.qr.timer.priv.timers, entry;
    .qr.timer.tick[];
    };

.qr.timer.remove:{
    delete from `.qr.timer.priv.timers where id=x;
    if[0 = count .qr.timer.priv.timers;
        value "\\t 0";
        ];
    };

.qr.timer.removeByFunctor:{
    delete from `.qr.timer.priv.timers where x~/: func;
    if[0 = count .qr.timer.priv.timers;
        value "\\t 0";
        ];
    };

.qr.timer.removeAll:{
    delete from `.qr.timer.priv.timers;
    value "\\t 0";
    };

.qr.timer.list:{
    .qr.timer.priv.timers
    };

.qr.timer.init:{
    if[not .qr.exist`.qr.timer.priv.timers;
        .qr.timer.priv.timers:([] id:"i"$();
            func:0h$();
            params:0h$();
            initTime:"p"$();
            nextRun:"p"$();
            timerType:"s"$();
            freq:"i"$();
            executed:"b"$());

        .z.ts:{show .z.p; .qr.timer.tick[];};
        ];
    };

.qr.timer.priv.getMillisecond:{
    00:00:00.001000000 * x
    };

.qr.timer.priv.exec:{[timersToExec]
    exec .qr.timer.priv.execFunc'[func;params;id] from .qr.timer.priv.timers where id in timersToExec;
    update executed:1b from `.qr.timer.priv.timers where id in timersToExec, timerType<>`relative;
    update nextRun:nextRun+.qr.timer.priv.getMillisecond freq
        from `.qr.timer.priv.timers where id in timersToExec, timerType=`relative;

    .qr.timer.tick[];
    };

.qr.timer.priv.execFunc:{[func;params;id]
    errorFunc:{"timer ", .qr.type.toString[x], " execute error: ", .qr.type.toString y}[id];
    .qr.trycatch[func;params;errorFunc]
    };

.qr.timer.tick:{
    // execute functions
    now:.z.p;
    timersToExec:exec id from .qr.timer.priv.timers where not executed, nextRun <= now;
    if[0 <> count timersToExec;
        :.qr.timer.priv.exec[timersToExec];
        ];

    // determine the next interval to tick
    nextRun:exec min nextRun from .qr.timer.priv.timers where not executed, nextRun > now;
    // if interval is less than 1ms. The timer is ticking around the scheduled task due
    // to timing error, we push back 1ms to force the task to run
    interval:"i"$ $[nextRun=0Wp; 0; 1 | (nextRun - now) % 00:00:00.001000000];
    value "\\t ", .qr.type.toString interval;
    };

.qr.timer.init[];