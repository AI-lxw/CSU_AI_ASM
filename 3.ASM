.286

DATAS SEGMENT
   SUM DW 1H,'#','$',1000 DUP(?)
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
	MOV AX,1D
	JMP OPERA;

OPERA:
	;1D入栈
	PUSH AX;
	LEA SI,SUM
	MOV BP,SI
	LOP_INDEX:
		MOV AX,[SI]
		ADD SI,2
		CMP AX,'#'
		JNE LOP_INDEX
		MOV AX,[SI]
		ADD SI,2
		CMP AX,'$'
		JNE LOP_INDEX
	;初始化参数
	MOV CX,0;初始化为0 
	ADD CX,0;初始化进位为0
	SUB SI,4;SI回退到'$'
	POP BX;出栈	、
	;#入栈，作为2标志
	MOV AX,'$'
	PUSH AX
	MOV AX,'#'
	;$入栈，作为1标志
	PUSH AX
	MULAGAIN:
		SUB SI,2
		MOV AX,[SI]
		MUL BX
		;前一个低位加本次高位
		ADD AX,CX
		;前一个低位加本次高位的和进栈
		PUSH AX
		;进位加到高位
		ADC DX,0
		MOV CX,DX
		CMP BP,SI
		;循环相乘
		JNE MULAGAIN
		;将结果存入SUM中
		LEA SI,SUM
		CMP CX,0
		JE PUSHSTACK
		PUSH CX;进位入栈
		JMP PUSHSTACK
	;;;保存结果到串;;;
	PUSHSTACK:
		POP AX
		MOV [SI],AX
		ADD SI,2
		;判断是否为标志位1
		CMP AX,'#'
		;循环弹出保存
		JNE PUSHSTACK
		MOV [SI],AX
		POP AX
		MOV [SI],AX
		ADD SI,2
		;判断是否为标志位2
		CMP AX,'$'
		;循环出栈并保存
		JNE PUSHSTACK
		MOV [SI],AX

	MOV AX,BX;
	INC AX
	;如果到达1000结束
	CMP AX,1001D
	;否则继续累加
	JNE OPERA
	;展示结果
	JMP DISPLAY
	

DISPLAY:
	LEA SI,SUM
	MOV BX,10H
	MOV DX,0	
	MOV CX,'$'
	;标志入栈
	PUSH CX
	MOV AX,[SI]
	ADD SI,2
	;循环将串中的内容取出，以字为单位
	JMP REM
	REM:
		MOV DX,0
		;将取出来的一个字的内容，并取余
		DIV BX
		;余数入栈
		PUSH DX
		;一直除到商为0 
		CMP AX,0
		;如果不为0则取余
		JNE REM
		;否则把之前压入栈内的内容弹出
		JMP POPDATA
		
	POPDATA:
		;把之前压入栈内的内容弹出
		POP AX
		MOV AH,0
		;判断标志位
		CMP AX,'$'
		JE NEXTW;下一个字的计算输出	
		CMP AX,0AH;判断数字字母
		JB NUMBER;打印数字
		JMP LETTER;打印字母
	;跳到下一个字的计算输出	
	NEXTW:
		MOV DL,20H;输出空格
		MOV AH,06H
		INT 21H
		;标志入栈
		MOV CX,'$'
		PUSH CX
		;获取一个字的内容
		MOV AX,[SI]
		;SI地址后移两个字节
		ADD SI,2
		;每4位计数
		MOV CX,4
		;判断是否是倒数第二个字
		CMP AX,'#'
		;再次跳转取余
		JNE REM2
		;获取一个字的内容
		MOV AX,[SI]
		ADD SI,2;SI地址后移两个字节
		MOV CX,4;计数
		;判断是否是最后一个字
		CMP AX,'$'
		;跳转取余
		JNE REM2
		
		JMP FIN;结束
	;;再次取余
	REM2:
		DEC CX;CX--
		MOV DX,0
		;除10H取余
		MOV BX,10H
		DIV BX
		;余数入栈
		PUSH DX
		;二进制连续四位转换是否结束
		CMP CX,0
		;再一次取余
		JNE REM2
		JMP POPDATA;跳转输出
	;打印数字	
	NUMBER:
		MOV DL,AL
		ADD DL,30H
		MOV AH,06H
		INT 21H
		JMP POPDATA;跳转输出
	;打印字母
	LETTER:
		MOV DL,AL
		ADD DL,37H
		MOV AH,06H
		INT 21H
		JMP POPDATA;调回循环输出
FIN:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START


