.286

DATAS SEGMENT
   SUM DW 1H,'#','$',1000 DUP(?)
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
	MOV AX,1D
	JMP OPERA;

OPERA:
	;1D��ջ
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
	;��ʼ������
	MOV CX,0;��ʼ��Ϊ0 
	ADD CX,0;��ʼ����λΪ0
	SUB SI,4;SI���˵�'$'
	POP BX;��ջ	��
	;#��ջ����Ϊ2��־
	MOV AX,'$'
	PUSH AX
	MOV AX,'#'
	;$��ջ����Ϊ1��־
	PUSH AX
	MULAGAIN:
		SUB SI,2
		MOV AX,[SI]
		MUL BX
		;ǰһ����λ�ӱ��θ�λ
		ADD AX,CX
		;ǰһ����λ�ӱ��θ�λ�ĺͽ�ջ
		PUSH AX
		;��λ�ӵ���λ
		ADC DX,0
		MOV CX,DX
		CMP BP,SI
		;ѭ�����
		JNE MULAGAIN
		;���������SUM��
		LEA SI,SUM
		CMP CX,0
		JE PUSHSTACK
		PUSH CX;��λ��ջ
		JMP PUSHSTACK
	;;;����������;;;
	PUSHSTACK:
		POP AX
		MOV [SI],AX
		ADD SI,2
		;�ж��Ƿ�Ϊ��־λ1
		CMP AX,'#'
		;ѭ����������
		JNE PUSHSTACK
		MOV [SI],AX
		POP AX
		MOV [SI],AX
		ADD SI,2
		;�ж��Ƿ�Ϊ��־λ2
		CMP AX,'$'
		;ѭ����ջ������
		JNE PUSHSTACK
		MOV [SI],AX

	MOV AX,BX;
	INC AX
	;�������1000����
	CMP AX,1001D
	;��������ۼ�
	JNE OPERA
	;չʾ���
	JMP DISPLAY
	

DISPLAY:
	LEA SI,SUM
	MOV BX,10H
	MOV DX,0	
	MOV CX,'$'
	;��־��ջ
	PUSH CX
	MOV AX,[SI]
	ADD SI,2
	;ѭ�������е�����ȡ��������Ϊ��λ
	JMP REM
	REM:
		MOV DX,0
		;��ȡ������һ���ֵ����ݣ���ȡ��
		DIV BX
		;������ջ
		PUSH DX
		;һֱ������Ϊ0 
		CMP AX,0
		;�����Ϊ0��ȡ��
		JNE REM
		;�����֮ǰѹ��ջ�ڵ����ݵ���
		JMP POPDATA
		
	POPDATA:
		;��֮ǰѹ��ջ�ڵ����ݵ���
		POP AX
		MOV AH,0
		;�жϱ�־λ
		CMP AX,'$'
		JE NEXTW;��һ���ֵļ������	
		CMP AX,0AH;�ж�������ĸ
		JB NUMBER;��ӡ����
		JMP LETTER;��ӡ��ĸ
	;������һ���ֵļ������	
	NEXTW:
		MOV DL,20H;����ո�
		MOV AH,06H
		INT 21H
		;��־��ջ
		MOV CX,'$'
		PUSH CX
		;��ȡһ���ֵ�����
		MOV AX,[SI]
		;SI��ַ���������ֽ�
		ADD SI,2
		;ÿ4λ����
		MOV CX,4
		;�ж��Ƿ��ǵ����ڶ�����
		CMP AX,'#'
		;�ٴ���תȡ��
		JNE REM2
		;��ȡһ���ֵ�����
		MOV AX,[SI]
		ADD SI,2;SI��ַ���������ֽ�
		MOV CX,4;����
		;�ж��Ƿ������һ����
		CMP AX,'$'
		;��תȡ��
		JNE REM2
		
		JMP FIN;����
	;;�ٴ�ȡ��
	REM2:
		DEC CX;CX--
		MOV DX,0
		;��10Hȡ��
		MOV BX,10H
		DIV BX
		;������ջ
		PUSH DX
		;������������λת���Ƿ����
		CMP CX,0
		;��һ��ȡ��
		JNE REM2
		JMP POPDATA;��ת���
	;��ӡ����	
	NUMBER:
		MOV DL,AL
		ADD DL,30H
		MOV AH,06H
		INT 21H
		JMP POPDATA;��ת���
	;��ӡ��ĸ
	LETTER:
		MOV DL,AL
		ADD DL,37H
		MOV AH,06H
		INT 21H
		JMP POPDATA;����ѭ�����
FIN:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START

