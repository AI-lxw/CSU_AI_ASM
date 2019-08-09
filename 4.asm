.286
;4. 依次打印下列字符串的 ASCII 值（注意符号）：or example, This is a number 3692.
DATAS SEGMENT
    STRING DB 'or example, This is a number 3692.','$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    LEA SI,STRING
    MOV DX,SI
    MOV AH,9
    INT 21H
    ;输出回车
	MOV DL,0AH
	MOV AH,6H
	INT 21H
    
    MOV BX,0
	JMP TRAN
TRAN:
	MOV CX,'$'
	;依次去除第一个字内容
	MOV DX,[SI]
	MOV DH,0
	;判断是否取到结束标志
	CMP DX,CX
	;若为结束标志则结束
	JE FIN
	;调用ASC
	CALL ASC
	MOV DL,20H;输出空格
	MOV AH,6H
	INT 21H
	MOV DL,20H;输出空格
	MOV AH,6H
	INT 21H
	MOV DL,20H;输出空格
	MOV AH,6H
	INT 21H
	MOV DL,20H;输出空格
	MOV AH,6H
	INT 21H
	;SI后退一位
	ADD SI,1
	;继续循环输出
	JMP TRAN

ASC:
	;添加标志0FH入栈
	MOV BX,0FH
	PUSH BX
	JMP TOASC;
;翻译成ASCII
TOASC:
	MOV AX,DX
	;除10取余
	MOV DX,0AH
	DIV DL
	MOV BL,AH
	;余数压进栈
	PUSH BX
	MOV DL,AL
	;一直除到商为0
	CMP AL,0
	;打印ASCII值
	JE REM;
	JMP TOASC;继续计算取余
	

REM:
	;余数出栈
	POP BX
	;判断标志位
	CMP BX,0FH
	;如果为标志结束段
	JE FIN1
	MOV DL,BL
	;输出余数
	ADD DL,30H;（ASCII）
	MOV AH,6H
	INT 21H
	;循环输出余数
	JMP REM

FIN1:
	RET
FIN: 
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START



