grammar OG;

program: machineSettings=machine drawFunction=draw functionsDeclarations=functionDcls? shapeDeclarations=shapeDcls #prog
       ;
       
shapeDcls   : currentShapeDcl=shapeDcl shapeDeclarations=shapeDcls #shapeDeclarations
            |                                                      #noShapesDefined
            ;
            
functionDcls: functionDcl functionDcls   #functionDeclarations
            |                            #noFunctionsDefined
            ;
       

machineVariables : 'xmin' '=' xmin=mathExpression ',' 'xmax' '=' xmax=mathExpression ',' 'ymin' '=' ymin=mathExpression',' 'ymax' '=' ymax=mathExpression;
machine          : 'Machine' '.''WorkArea''.''size' '(' machineVariables ')'';';
draw             : 'draw' '{' shapesToDraw=drawCommands '}';

drawCommands: drawCommand drawCommands #drawCmds
            |                          #drawCommandsEmpty
            ;
drawCommand     : id=ID';'                             #drawCmd
                | id=ID fromCmd=fromCommand ';'        #drawFromCmd
                ;
//Shapes:
shapeDcl            : 'shape' id=ID '{' bdy=body '}'
                    ;


body: statements=stmts;

stmts: currentStatement = stmt statements =stmts | ;
stmt:  dcl  =declaration 
    | assign=assignment
    | cmd   =command;             

                    
assignments : assign=assignment assignmnts = assignments    #assgnments
            |                                               #noAssignmentsDefined
            ;
declarations: dcl=declaration dcls=declarations  #dcls
            |                                    #noDeclarationsDefined
            ;
            
commands: cmd=command cmds=commands              #cmds
        |                                        #noCmdsDeclared
        ;

declaration         : numberDcl=numberDeclaration';' #numberDcl
                    | pointDcl=pointDeclaration';'   #pointDcl
                    | boolDcl=booleanDeclaration';'  #boolDcl
                    ;
booleanDeclaration  : 'bool'   id=ID   '=' value=boolExpression
                    ;
numberDeclaration   : 'number' id=ID '=' value=mathExpression
                    ;
pointDeclaration    : 'point'  id=ID '='  value=pointReference    #pointDclPointRefAssign
                    | 'point'  id=ID  '=' value=ID                #pointDclIdAssign
                    ;

pointReference      :  '(' tuple=numberTuple ')' 
                    | point=StartPointReference
                    | point=EndPointReference 
                    | point=ID
                    | funcCall=functionCall
                    ;
numberTuple         : lhs=mathExpression ',' rhs=mathExpression;

//Basic declarations and assignments:
assignment          : variableAssignment 
                    | propertyAssignment
                    ;
propertyAssignment  : xyVal=CoordinateXYValue '=' value=mathExpression';'
                    ;

variableAssignment  : id=ID'=' value=ID             ';' #idAssign
                    | id=ID'=' value=boolExpression ';' #boolAssign    
                    | id=ID'=' value=mathExpression ';' #numberAssign
                    | pointAssignment               ';' #pointAssign
                    ; 

pointAssignment     :  endPointAssignment
                    |  startPointAssignment     
                    |  id=ID '=' value=pointReference
                    ;

startPointAssignment: id=StartPointReference '=' value=pointReference
                    ;
endPointAssignment  : id=EndPointReference '=' value=pointReference
                    ;


//Generel expressions:
expression      : id=ID 
                | mathExpression 
                | boolExpression 
                | functionCall
                ;    
                     //term   ((Plus_Minus) term)*
mathExpression  : lhs=term op=Plus_Minus rhs=mathExpression        #infixAdditionExpr //operand står i midten
                | child=term                                       #singleTermExpr
                ;
                
term            : lhs=factor op=Mul_Div rhs=term                   #infixMultExpr              
                | child=factor                                     #singleTermChild //Child er et vidtdækkende begreb
                ;      
factor          : lhs=atom pow='^' rhs=factor                      
                | child=atom                                          
                |'(' mathExpr=mathExpression ')'
                ;

atom            : funcCall=functionCall
                | value=Number 
                | xyValue=CoordinateXYValue 
                | id=ID
                ;
               

boolExpression  : id=ID                                                    #boolExprID
                | value=BooleanValue                                          #boolExprTrueFalse
                | funcCall=functionCall                                          #boolExprFuncCall
                | lhs=mathExpression BoolOperator rhs=mathExpression    #boolExprMathComp
                | lhs=boolExpression LogicOperator rhs=boolExpression   #boolExprBoolComp
                | '!'boolExpr=boolExpression                                     #boolExprNotPrefix   
                ;



//Commands:
//Movement commands:
command         : iterCmd=iterationCommand
                | movementCmd=movementCommand
                | drawCmd=drawCommand
                ;

movementCommand : lineCmd=lineCommand ';' 
                | curveCmd=curveCommand';'
                ;
                
lineCommand     : 'line' fromCmd=fromCommand  toCmds=toCommands;

toCommands: toCmd=toCommand chainedToCmds=toCommands          #chainedToCommand
          | toCmd=toCommand                                   #singleToCommand
          ;

   
curveCommand    : 'curve''.''withAngle' '('angle=mathExpression ')'  fromCmd=fromCommand toCmd=toCommand;
                
toCommand       : '.to''(' id=ID ')'                   #toWithId
                | '.to''(' tuple=numberTuple ')'          #toWithNumberTuple
                | '.to''(' toPoint=StartPointReference ')'  #toWithStartPointRef
                | '.to''(' toPoint=EndPointReference ')'    #toWithEndPointRef
                ;

fromCommand     :  '.from' '(' id=ID')'                             #fromWithId
                |  '.from' '(' tuple=numberTuple ')'                #fromWithNumberTuple
                |  '.from' '(' fromPoint=StartPointReference ')'    #fromWithStartPointRef
                |  '.from' '(' fromPoint=EndPointReference ')'      #fromWithEndPointRef
                ;


//Iterative statements:
iterationCommand: numberIterCmd=numberIteration 
                | untilIterCmd=untilIteration
                ;
numberIteration : 'repeat''('iterator=mathExpression')' statements=body 'repeat.end'
                ;
untilIteration  : 'repeat''.''until''(' iterator=functionCall')' statements=body 'repeat.end'    #untilFuncCall
                | 'repeat''.''until''(' iterator=boolExpression')' statements=body 'repeat.end'  #untilCondition
                ; //Udvid til flere regler?


//Functions: 
functionDcl             : returnFunctionDCL 
                        | voidFunctionDCL
                        ;
                        
returnFunctionDCL       : 'function' type=typeWord funcName=ID '('paramDcls=parameterDeclarations ')''{' statements=body returnStmt=returnStatement '}';

typeWord                : PointDCLWord 
                        | BoolDCLWord 
                        | NumberDCLWord
                        ;
voidFunctionDCL         : 'function' 'void' id=ID '(' paramDcls=parameterDeclarations ')'  '{' statements=body '}';

parameterDeclarations   :  currentParamDcl=parameterDcl ',' paramDcls=parameterDeclarations #multiParamDcl
                        |  paramDcl=parameterDcl                                 #singleParamDcl
                        |                                                        #noParamsDcl
                        ;
parameterDcl: type=typeWord id=ID;      
                  
functionCall            : id=ID '(' params=passedParams ')' 
                        ;


passedParams: firstParameter=passedParam ',' params=passedParams #multiParameters
            | parameter=passedParam                          #singleParameter
            |                                                #noParameter
            ;

passedParam : id = ID                                       #passedID
            | funcCall = functionCall                       #passedFunctionCall
            | expr = expression                             #passedDirectValue
            | endpointRef =  EndPointReference              #passedEndPointReference
            | startpointRef = StartPointReference           #passedStartPointReference
            ;



returnStatement         : 'return' id=ID ';'         #returnValueReference
                        | 'return' expr=expression ';' #returnDirectValue
                        ;



Number: Integer|Float;

//Tokens and help variables:
BooleanValue    : 'true'| 'false';
fragment Integer: [0-9]+ | '-'[0-9]+;
fragment Float  : [0-9]+'.'[0-9]+ | '-'[0-9]+ | '-'[0-9]+'.'[0-9]+;

WS     : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines
COMMENT: '/*' .*? '*/' -> skip;

//Startwords
ShapeDCLWord : 'shape';
PointDCLWord : 'point';
BoolDCLWord  : 'bool';
NumberDCLWord:'number';
DrawDCLWord  :  'draw';


//CommandWords: 
WithAngle    : 'withAngle';
Curve        : 'curve';
Line         : 'line';
To           : 'to';
From         : 'from';
RepeatStart  : 'repeat';
RepeatEnd    : 'repeat.end';
Until        : 'until';
DOT          : '.';

//Function specific words
FunctionStartWord : 'function';
FunctionReturnWord: 'return';
Void              : 'void';

//Operators for mathematics and expressions
LParen   : '('   ;
RParen   : ')'   ;

Plus_Minus: Plus | Minus;
Plus     : '+'   ;
Minus    : '-'   ;

Mul_Div  : Times | Div;
Times    : '*'   ;
Div      : '/'   ;

Pow      : '^'   ;

LogicOperator    :  AND | OR;
BoolOperator     :  LT  | GT | EQ;
fragment GT       : '>'   ;
fragment LT       : '<'   ;
fragment EQ       : '=='  ;
fragment AND      : '&&'  ;
NOT               : '!'   ;
fragment OR       : '||'  ;

Assign   : '=';

//Scopes and terminators;
OpenScope   :  '{';
CloseScope  : '}';
Terminator  : ';';
Seperator   : ',';

XMIN: 'xmin';
XMAX: 'xmax';
YMAX: 'ymin';
YMIN: 'ymax';

// 'Machine' '.''WorkArea''.''size' '(' machineVariables ')'';'
Machine : 'Machine'; 
WorkArea: 'WorkArea';
Size    : 'size';

StartPointReference : ID'.''startPoint';
EndPointReference   : ID'.''endPoint';
If  : 'if';
Then: 'then';

CoordinateXYValue: (ID'.x') | (ID'.y') | (StartPointReference|EndPointReference) ('.x'|'.y') ;
ID: [a-zA-Z]+[0-9a-zA-Z]*; //ID skal være nederst for ikke at overwrite alle de andre keywords.



