bob
===

The Bob Programming Language


Old syntax, no longer valid, this was from bob1.2 (1991-sept)

Table 1: Bob syntax

  Class Definition

  class<class-name>[:<base-class-name>]
   {<member-definition>...}

  Member Definition

  <variable-name>...;
  static<variable-name>...;
  <function-name>([<formal-argument-list>]);
  static <function-name>([<formal-argument-list>]);

  Function Definition

  [<class-name>::]<function-name>
   ([<formal-argument-list>[;<temporary-list>])
   {<statement>...}

  Statement

  if (<test-expression>)<then-statement>[else<else-statement>];
  while (<test-expression>)<body-statement>
  do<body-statement>while<test-expression>);
  for(<init-expression>;<test-expression>;<increment-expression>)
   <body-statement>
  break;
  continue;
  return[<result-expression>];
  [<expression>];
  {<statement>...}

  Expression
  <expression>,<expression>
  <lvalue>=<expression>
  <lvalue>+=<expression>
  <lvalue>-=<expression>
  <lvalue>*=<expression>
  <lvalue>/=<expression>
  <test-expression>?<true-expression>:<false-expression>
  <expression>||<expression>
  <expression>&&<expression>
  <expression>|<expression>
  <expression>^<expression>
  <expression>&<expression>
  <expression>==<expression>
  <expression>!=<expression>
  <expression><<expression>
  <expression><=<expression>
  <expression>>=<expression>
  <expression>><expression>
  <expression><<<expression>
  <expression>>><expression>

  <expression>+<expression>
  <expression>-<expression>
  <expression>*<expression>
  <expression>/<expression>
  <expression>%<expression>
  -<expression>
  !<expression>
  ~<expression>
  ++<lvalue>
  --<lvalue>
  <lvalue>++
  <lvalue>--
  new <class-name>([<constructor-arguments>])
  <expression>([<arguments>])
  <expression>-><function-name>([<arguments>])
  (<expression>)
  <variable-name>
  <number>
  <string>
  nil
