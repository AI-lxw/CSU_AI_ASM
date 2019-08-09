DATAS SEGMENT
    N      DB 4 DUP(?);小孩数目    	   
   	M	   DB 4 DUP(?);击鼓次数		   
   	I	   DB 4 DUP(?);从第几个小孩开始
   		   
   	LIST_CH DB 50 DUP(?);
   	STRING1 DB 'enter the number of kids from 1 to 9:','$'
   	STRING2 DB 'drumming times from 1 to 9:','$'
   	STRING3 DB 'which kids first from 1 to 9 :','$'
   	STRING4 DB 'who leave:','$'
   	STRING5 DB 'who quit:','$'
   	STRING6 DB ' Illegal input','$'
   	STRING7 DB 'please input right number ','$'
   	serial DB 2 DUP(?);小孩序号列表
   	TODELE DB 2 DUP(?);退出游戏的小孩下标
   	REST DB 2 DUP(?);留下小孩的序号
   		     
DATAS ENDS

STACKS SEGMENT
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
	
	MOV AX,DATAS
	MOV DS,AX
	;提示用户输入
	LEA DX,STRING1
	MOV AH,9H
	INT 21H
	;N的地址
	LEA SI,N
	;获取小孩数目
	CALL INPUT
	
	MOV DL,0AH
	MOV AH,6H
	INT 21H;回车
	;提示输入击鼓次数
	LEA DX,STRING2
	MOV AH,9H
	INT 21H
	LEA SI,M
	;
	CALL INPUT
	
	MOV DL,0AH
	MOV AH,6H
	INT 21H;用户输入
	;从第几个小孩开始
	LEA DX,STRING3
	MOV AH,9H
	INT 21H
	LEA SI,I;获取第几个小孩开始序号
	CALL INPUT
	;初始化小孩列表
	JMP KIDS

INPUT:
	MOV DL,0FFH
	MOV AH,07H
	;输入
	INT 21H;
	MOV AH,0
	PUSH AX
	;用户输入的ASCII不小于31H
	SUB AX,31H
	JNS ALL;
	;提示非法信息
	JMP WORNING;

	
ALL:
	POP AX
	PUSH AX
	SUB AX,3AH
	;提示非法信息
	JNS WORNING
	;锟斤拷锟斤拷锟斤拷锟街斤拷栈锟斤拷
	JMP PUSHSTACK
WORNING:
	;锟斤拷锟斤拷栈锟叫碉拷锟斤拷锟斤拷	
	POP AX
	;锟斤拷示锟斤拷锟斤拷锟斤拷息锟角凤拷
	LEA DX,STRING6
	MOV AH,09H
	INT 21H
	
	MOV DL,0AH
	MOV AH,06H;锟斤拷锟斤拷爻锟?
	INT 21H
	;锟劫达拷锟斤拷锟斤拷锟斤拷确值
	LEA DX,STRING7
	MOV AH,09H
	INT 21H
	JMP INPUT
PUSHSTACK:
	POP AX ;输入数字出栈
 	MOV [SI],AX
 	MOV DX,AX
 	MOV DH,0
 	MOV AH,6H
 	INT 21H
 	RET

;小孩列表
KIDS:
	LEA SI,I
	MOV AX,[SI]
	SUB AX,30H
	MOV AH,0	
	;将从第几个小孩开始存入serial中
	LEA SI,serial
	MOV [SI],AX
	
	LEA SI,N
	;小孩总人数
	MOV CX,[SI]
	INC CX
	PUSH CX
	
	LEA SI,LIST_CH;获得玩家列表首地址
	MOV AX,31H
	LOP_IN:
		MOV [SI], AX;玩家编号存入串
		;地址+1
		INC SI
		;玩家编号+1
		INC AX
		;玩家总人数出栈
		POP CX
		;小孩总人数入栈
		PUSH CX
		;判断入栈编号是否全
		SUB CX,AX
		JNE LOP_IN;循环
		MOV AX,'$';标志位
		
		;标志位放最末
		MOV [SI],AX 
		;小孩人数出栈
		POP CX 
		;游戏主程序
		JMP MAIN
;;;游戏主程序;;;
MAIN:
	LEA SI,N
	MOV AX,[SI];剩下的小孩 
	MOV AH,0
	SUB AX,30H
	LEA SI,REST
	MOV [SI],AX
	
	LEA SI,I
	MOV AX,[SI];i为序号
	MOV AH,0
	SUB AX,30H
	LEA SI,serial
	MOV [SI],AX
	JMP GAMELOP;开始游戏循环
	
GAMELOP:;循环
	LEA SI,REST;获得剩余玩家人数
	MOV AX,[SI]
	MOV AH,0
	;指导只剩一人才结束
	CMP AX,1
	JE RESULT;输出结果
	LEA SI,serial
	MOV AX,[SI];获取序号
	MOV AH,0
	
	LEA SI,M
	MOV BX,[SI];获取第一个开始的小孩
	MOV BH,0
	SUB BX,30H
	;M--，确定删除的位置
	DEC AX
	ADD AX,BX 
	
	LEA SI,REST
	MOV BX,[SI]
	PUSH BX;剩下的玩家进栈
	DIV BL;取余
	MOV AL,AH
	MOV AH,0
	;标记位0
	CMP AX,0;
	;为0 则跳转
	JE ZER
	LEA SI,TODELE
	MOV [SI],AX
	LEA SI,serial
	MOV [SI],AX
	POP AX
	DEC AX
	LEA SI,REST
	MOV [SI],AX
	JMP DELET;根据TODELE删除淘汰指定玩家
	ZER:
		MOV AX,1
		LEA SI,serial
		MOV [SI],AX
		POP AX
		LEA SI,TODELE
		MOV [SI],AX
		LEA SI,REST
		DEC AX
		MOV [SI],AX
		JMP DELET;根据TODELE淘汰指定玩家
	DELET:
		MOV CX,'$'
		LEA SI,TODELE
		MOV BX,[SI];获取删除的位置
		MOV BH,0
		
		LEA SI,LIST_CH
		ADD SI,BX;让SI指向待删除小孩位置的后一位
		MOV AX,SI
		DEC AX
		MOV DX,[SI]
		MOV DH,0
		PUSH SI
		MOV SI,AX
		MOV [SI],DX;将玩家位置前移
				   ;直接覆盖前一个人
		
		POP SI
		CMP DX,CX
		JE GAMELOP;移动到标志位$，跳转继续下一轮游戏
		LOP_D:
			MOV AX,SI
			INC SI
			MOV DX,[SI]
			MOV DH,0;依次将玩家位置前移
			PUSH SI ;覆盖前一个玩家位置。第一个被覆盖的是被删除玩家
			MOV SI,AX
			MOV [SI],DX
			POP SI
			CMP DX,CX
			JE GAMELOP;跳转继续下一轮游戏
			JMP LOP_D;继续移动
;输出结果
RESULT:
	MOV DL,0AH
	MOV AH,6H
	INT 21H
	LEA DX,STRING4;输出提示信息
	MOV AH,9H
	INT 21H
	
	LEA SI,LIST_CH;获得最后游戏结束时的小孩列表
	MOV AX,[SI]
	;ADD AX,30H
	MOV AH,0
	PUSH AX;未淘汰编号入栈
	MOV DX,AX
	MOV AH,6H
	INT 21H
	
	MOV DL,0AH;回车
	INT 21H
	
	LEA DX,STRING5;提示信息
	MOV AH,9H
	INT 21H
	LEA SI,N
	MOV BX,[SI];输出退出信息
	MOV BH,0
	MOV CX,0
	MOV DX,30H;输出退出的标号
	LOP_OUT:
		INC DL
		CMP DX,BX
		JA FIN;输出结束，跳转到结束段
		PUSH AX
		;输出的是否是胜利者编号
		CMP AX,DX
		JE LOP_OUT;是跳过该编号?
		MOV AH,6H
		INT 21H;输出编号
		;循环继续输出
		JMP LOP_OUT

FIN:
	MOV AH,4CH
	INT 21H
CODES ENDS
    END START



