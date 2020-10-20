* 	 e0ff3b0 2020-10-20  (HEAD -> master) messing with async formulation, Slot atm
* 	 277adb7 2020-10-06  (tag: 0.1.6, github/master) doc: CHANGELOG.md
* 	 4bc94bd 2020-10-06  feat: hl now compiling, at least
* 	 19c41fc 2020-10-06  feat: Bool.not
* 	 fa983ae 2020-10-06  refactor: faffing with toString
* 	 0f4f429 2020-10-06  fix: removing YCombinator until the compiler bug is fixed
* 	 cbe360f 2020-10-01  feat: typedef Twin<T> = Couple<T,T>
* 	 4ee11e5 2020-09-30  added CHANGELOG.md
* 	 539178c 2020-09-30  🚅perfs: inlined lifts
* 	 f4ac57c 2020-09-25  (tag: v0.1.5) supporting classes for stx_ds to avoid pulling in stx_ext at that level
* 	 d4c6d8b 2020-09-25  (tag: v0.1.4) brought KV from stx_ext
* 	 475d3a2 2020-09-25  (tag: v0.1.3) dependencies and version update
* 	 5caaa5c 2020-09-25  resolve<T,E>(opt:Option<T>,err:E,?pos:Pos):Res<R,E>
* 	 9099143 2020-09-25  add position formatter that plays nice with vs_code
* 	 e7acbec 2020-09-22  fudge throws an error, value always returns an Option
* 	 4ff9641 2020-09-22  clear distinction between Res and Outcome
* 	 f7fc4bf 2020-09-22  more chrome for Res
* 	 87429c9 2020-09-22  orth
* 	 7035d46 2020-09-22  build.hxml -> test.hxml and removed from source control so I can tinker
* 	 2d8580a 2020-09-22  doc
* 	 0ccf1a0 2020-09-22  standardised accessor syntax for Couple
* 	 8df3b6a 2020-07-27  Res now uses Accept | Reject
* 	 6ea0b8f 2020-07-27  a few issues
* 	 1b4d083 2020-07-17  Slot based on object now
* 	 20e95f9 2020-07-07  odds and sods
* 	 cd88d44 2020-07-07  Wildcard.noop and Wildcard.nullify
* 	 a9beea0 2020-07-07  Res.bind_fold added
* 	 6e9dded 2020-07-07  added Triple
* 	 6042287 2020-07-02  Slot.toFuture and __.raise --> __.crack for python generator
* 	 b493618 2020-06-29  Slot added, Res.errate Error.elide
* 	 6da0c2b 2020-05-18  compiler being picky about lensing througgh typedefs in some situations
* 	 6d74be5 2020-05-14  more wildcard functions
* 	 6809c5f 2020-05-14  iterator on Err, and __.option() on prev in new
* 	 2a63ae2 2020-05-14  cant't live without a tuple2 constructor
* 	 112316c 2020-05-05  documentation
* 	 04e1ee6 2020-05-05  added toString to Err
* 	 e5bb638 2020-05-05  documentation
* 	 24f723e 2020-05-05  added `raise` static extension
* 	 1740ae7 2020-05-02  formatting
* 	 2391f2a 2020-05-02  Primitive & Unique added. Some documentation.
* 	 6468dc1 2020-03-28  various fixes. Correct order in `ResLift`
* 	 2b7aa38 2020-03-24  added `fault` function to `stx.core.pack.Err`
* 	 9681c31 2020-03-24  load this up at macro time to check that
* 	 69fca0b 2020-03-23  haxelib details
* 	 5dc3d2c 2020-03-23  deletions
* 	 bb791f9 2020-03-23  Pulls it in together
* 	 b1be5bb 2020-03-22  starting up