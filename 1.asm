.286
;1. 用降幂法和除法将下列十进制数转换为二进制数和十六进制数，
;并将结果打印在屏 幕上：369，10000，4095，32767，8000。 
;数据结构：数组装数据
;有一个pop结束标志
;(一)降幂法
;1.降幂法首先要写出要转换的十进制数，
;2.其次写出该十进制数的16进制的权值，
;3.然后找出该数中包含多少个最接近该数的权值的倍数，
;4.这一倍数即对应位的是，
;5.用袁术减去此倍数与相应为值的成绩得到一个差值去找第一位的权值的倍数，
;6.如此反复知道差值为0 
;除法
;1.转二进制--》2.得到二进制很容易就可以转为16进制
DATA    SEGMENT 
	;此处输入数据段代码
	STRING DB 40 DUP(?)
DATA    ENDS  
STACK SEGMENT
	;此处输入堆栈段代码
STACK ENDS
CODE   SEGMENT    
ASSUME  CS:CODE, DS:DATA,SS:STACK
BEGIN:
	MOV AX,DATA
	MOV DS,AX
	JMP ARR2
	;此处输入代码段代码
;;;;;;;;;;;;;;;
;降幂法
;初始化数组，把369，10000，4095，32767，8000放进去
ARR:
	PUSH 0
	PUSH 369
	PUSH 10000
	PUSH 4095
	PUSH 32767
	PUSH 8000
	;[0,369，10000，4095，32767，8000]
	;零在这边目的是当做一个结束标志
	JMP TAKEOUT
;;;;;;;;;;;;;;;;;;
;依次取出要转换的数
TAKEOUT:
	POP AX
	;每次取数都要 compare 有没有0如果有结束
	CMP AX,0
	;若ZF=1运算指令的结果为0时
	JZ finish;JZ 进行转移到finish段
	MOV BX,1
	CALL SUBT
	;右移1位
	SHR BX,1
	MOV CX,AX	
	LEA SI,STRING
	CALL BINARY;调用转换二进制子函数
	;1.转二进制--》2.得到二进制很容易就可以转为16进制
	CALL OUT_HX1;根据二进制串输出十六进制
	mov AH,2
	mov DL, 32
	int 21h
	mov AH,2
	mov DL, 32
	int 21h
	mov AH,2
	mov DL, 32
	int 21h
	mov AH,2
	mov DL, 32
	int 21h
	JMP TAKEOUT;
;;;;;;;;;;;;;;;;;;
;做减法运算
SUBT:
	;逻辑左移
	SHL BX,1;1位
	PUSH AX
	SUB AX,BX;AX - BX 
	POP AX
	;如果不为负数符号位S不为1，就跳转
	JNS SUBT;
	RET
;;;;;;;;;;;;;;;;;;
;做转换为二进制运算
BINARY:
	MOV AX,CX
	SUB AX,BX
	;减法指令，当两数相等，结果就为0，就转移
	JZ ZERO
	;当两数不等且相减得负
	JS ISNEG
	;当两数不等且相减得正
	JNS ISPOS
;;;;;;;;;;;;;;;;;;
;等于0
ZERO:
	MOV DX,BX
	SHR DX,1
	CMP DX,0
	JNE LOWEST;是否为最低位
	
	MOV DL,31H;
	MOV AH,6
	INT 21H
	
	PUSH DX;如果是最后一位保 压入二进制栈中
	MOV DX,1H
	MOV [SI],DL
	INC SI
	POP DX	
	PUSH AX
	MOV AX,'$';加标志位
	MOV [SI],AL
	POP AX	
	RET
;;;;;;;;;;;;;;;;;;;;;;
;输出结果处理
;若计算得0但是不是最低位
LOWEST:
	MOV DL,31H;先输出一个1
	MOV AH,6H
	INT 21H	
	PUSH DX;添加到二进制串
	MOV DX,1H
	MOV [SI],DL
	INC SI
	POP DX	
	JMP OUT1
OUT1:
	MOV DX,BX
	SHR DX,1
	CMP DX,0
	JNZ PRI0;先输出一个1之后全是零	
	PUSH AX
	MOV AX,'$';添加标志位到二进制串
	MOV [SI],AL
	POP AX
	
	RET
PRI0:;输出剩下的0
	MOV DL,30H
	MOV AH,6;输出0
	INT 21H
	
	PUSH DX
	MOV DX,0H;0保存到二进制串
	MOV [SI],DL
	INC SI
	POP DX	
	SHR BX,1
	JMP OUT1
;如果为-
ISNEG:
	SHR BX,1
	MOV DL,0
	CALL PRI;输出
	JMP BINARY
;如果为+
ISPOS:;
	SHR BX,1
	MOV CX,AX
	MOV DL,1H
	CALL PRI;输出
	JMP BINARY
PRI:
	MOV [SI],DL
	INC SI
	ADD DL,30H
	MOV AH,6
	INT 21H
	RET
;;;;;;;;;;;;;;
;除法
ARR2:;将要转换的数入栈
	PUSH 0
	PUSH 369
	PUSH 10000
	PUSH 4095
	PUSH 32767
	PUSH 8000
	JMP OUTSTACK
OUTSTACK:
	POP BX;要转换的数依次出栈
	CMP BX,0;比较是否为0
	JNE GOC;若不为 0
	;输出回车
	MOV DL,0AH
	MOV AH,6H
	INT 21H
	MOV DL,0AH
	MOV AH,6H
	INT 21H
	MOV DL,0AH
	MOV AH,6H
	INT 21H
	MOV DL,0AH
	MOV AH,6H
	INT 21H
	;JMP FIN_END
	JMP ARR
GOC:
	CALL LOGR;调用LOGR
	;空格输出
	mov AH,2
	mov DL, 32
	int 21h
	mov AH,2
	mov DL, 32
	int 21h
	mov AH,2
	mov DL, 32
	int 21h

	mov AH,2
	mov DL, 32
	int 21h
	JMP OUTSTACK
;;;;;;;;;;;;;;;;;
;逻辑右移
LOGR:
	MOV AX,BX
	SHR BX,1;右移一位
	CMP BX,0;是否为0
	;结果为0(即 ZF=1)时，转移到FINISH1
	JZ FINISH1
	PUSH AX
	MOV AX,BX
	SHL AX,1;逻辑左移
	MOV CX,AX
	POP AX
	SUB AX,CX;AX-CX
	PUSH AX;入栈
	JMP LOGR
FINISH1:
	PUSH 1
	LEA SI,STRING
	JMP COUT1
COUT1:
	POP DX;依次输出栈的结果
	CMP DX,2;判断是否是
	JNB COUT2
	
	MOV DH,0
	MOV [SI],DX;保存到字符串
	INC SI
	
	ADD DL,30H;输出一位
	MOV AH,6
	INT 21H
	JMP COUT1

COUT2:
	PUSH AX
	MOV AX,'$'
	MOV [SI],AX;结束标志
	POP AX
	
	PUSH DX
	JMP PUTHEX;16进制

;;;;;;;;;;;;;;;
;输出16进制
PUTHEX:
	LEA SI,STRING
	MOV BP,SI
	JMP FLAG
FLAG:
	MOV AL,[SI];将SI指针指到$的前一位
	MOV AH,0
	INC SI
	CMP AL,'$'
	JNE FLAG;跳转到flag标志位
	
	DEC SI
	MOV AL,0
	MOV [SI],AL
	DEC SI
	;;;;;作为标志入栈;;;;
	MOV DX,'$'
	JMP CACUHEX
CACUHEX: 
	PUSH DX;计算结果或者标志入栈
	MOV DX,0;置零
	;;;每四个连续的二进制数可以表示一位16进制数;;;;;
	MOV CX,4;每次循环位数为4
	LOP_HX:
		DEC CX
		CALL CACUSUM;调用累加子函数
		CMP SI,BP;是否全部转换完毕
		JZ PRE_PRI;输出十六进制结果
		DEC SI;指针后退一位
		CMP CX,0;确认连续四位是否转换结束
		JZ CACUHEX
		JMP LOP_HX
CACUSUM:;累加子函数
	PUSH AX
	MOV AL,[SI];删掉二进制穿一位
	PUSH DX
	MOV DX,0
	MOV [SI],DL;并且置零
	POP DX	
	MOV AH,0
	
	PUSH BX
	MOV BX,3H
	SUB BL,CL;左移哪一位？
	PUSH CX
	MOV CL,BL
	SHL AX,CL;左移CL位
	POP CX
	POP BX
	
	ADD DX,AX;将左移结果保存到DX中
	POP AX
	RET
PRE_PRI:
	PUSH DX;保存最后得到的一个十六进制数
	;空格输出
	mov AH,2
	mov DL, 32
	int 21h
	JMP COUTHEX
;;;打印16进制数;;;;;;;;;	
COUTHEX:;
	POP AX
	MOV AH,0
	CMP AX,'$';是否是标志位

	JZ FIN
	CMP AX,0AH
	JB NUMBER;输出数字
	JMP LETTER;输出字母
NUMBER:
	MOV DL,AL
	ADD DL,30H
	MOV AH,06H
	INT 21H
	JMP COUTHEX
LETTER:
	MOV DL,AL
	ADD DL,37H
	MOV AH,06H
	INT 21H
	JMP COUTHEX
	
;;;;;;;;;;;;;;;;;;
;16进制
OUT_HX1:
	LEA SI,STRING
	MOV BP,SI
	JMP INDEX_LEN1
INDEX_LEN1:
	MOV AL,[SI]
	MOV AH,0
	INC SI
	CMP AL,'$'
	JNE INDEX_LEN1
	
	DEC SI
	MOV AL,0
	MOV [SI],AL
	DEC SI
	
	MOV DX,'$'
	JMP HX1
HX1: 
	PUSH DX
	MOV DX,0
	MOV CX,4
	LOP_HX1:
		DEC CX
		CALL MUL_N1
		CMP SI,BP
		JZ PRE_PRI1
		DEC SI
		CMP CX,0
		JZ HX1
		JMP LOP_HX1
MUL_N1:
	PUSH AX
	MOV AL,[SI]
	
	PUSH DX
	MOV DX,0
	MOV [SI],DL
	POP DX	
	MOV AH,0
	
	PUSH BX
	MOV BX,3H
	SUB BL,CL
	PUSH CX
	MOV CL,BL
	SHL AX,CL
	POP CX
	POP BX
	
	ADD DX,AX
	POP AX
	RET
PRE_PRI1:
	PUSH DX
	MOV DL,20H
	MOV AH,6H
	INT 21H
	JMP PRI_HX1
	
PRI_HX1:
	POP AX
	MOV AH,0
	CMP AX,'$'
	JZ FIN
	CMP AX,0AH
	JB OUT_NUM1
	JMP OUT_ALF1
OUT_NUM1:
	MOV DL,AL
	ADD DL,30H
	MOV AH,06H
	INT 21H
	JMP PRI_HX1
OUT_ALF1:
	MOV DL,AL
	ADD DL,37H
	MOV AH,06H
	INT 21H
	JMP PRI_HX1	
	
	
	

FIN:
	RET
finish:
	MOV AH,4CH
	INT 21H
	RET
CODE   ENDS    
    END BEGIN






































