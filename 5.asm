DATAS SEGMENT
    N      DB 4 DUP(?);С����Ŀ    	   
   	M	   DB 4 DUP(?);���Ĵ���		   
   	I	   DB 4 DUP(?);�ӵڼ���С����ʼ
   		   
   	LIST_CH DB 50 DUP(?);
   	STRING1 DB 'enter the number of kids from 1 to 9:','$'
   	STRING2 DB 'drumming times from 1 to 9:','$'
   	STRING3 DB 'which kids first from 1 to 9 :','$'
   	STRING4 DB 'who leave:','$'
   	STRING5 DB 'who quit:','$'
   	STRING6 DB ' Illegal input','$'
   	STRING7 DB 'please input right number ','$'
   	serial DB 2 DUP(?);С������б�
   	TODELE DB 2 DUP(?);�˳���Ϸ��С���±�
   	REST DB 2 DUP(?);����С�������
   		     
DATAS ENDS

STACKS SEGMENT
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
	
	MOV AX,DATAS
	MOV DS,AX
	;��ʾ�û�����
	LEA DX,STRING1
	MOV AH,9H
	INT 21H
	;N�ĵ�ַ
	LEA SI,N
	;��ȡС����Ŀ
	CALL INPUT
	
	MOV DL,0AH
	MOV AH,6H
	INT 21H;�س�
	;��ʾ������Ĵ���
	LEA DX,STRING2
	MOV AH,9H
	INT 21H
	LEA SI,M
	;
	CALL INPUT
	
	MOV DL,0AH
	MOV AH,6H
	INT 21H;�û�����
	;�ӵڼ���С����ʼ
	LEA DX,STRING3
	MOV AH,9H
	INT 21H
	LEA SI,I;��ȡ�ڼ���С����ʼ���
	CALL INPUT
	;��ʼ��С���б�
	JMP KIDS

INPUT:
	MOV DL,0FFH
	MOV AH,07H
	;����
	INT 21H;
	MOV AH,0
	PUSH AX
	;�û������ASCII��С��31H
	SUB AX,31H
	JNS ALL;
	;��ʾ�Ƿ���Ϣ
	JMP WORNING;

	
ALL:
	POP AX
	PUSH AX
	SUB AX,3AH
	;��ʾ�Ƿ���Ϣ
	JNS WORNING
	;�������ֽ�ջ��
	JMP PUSHSTACK
WORNING:
	;����ջ�е�����	
	POP AX
	;��ʾ������Ϣ�Ƿ�
	LEA DX,STRING6
	MOV AH,09H
	INT 21H
	
	MOV DL,0AH
	MOV AH,06H;����س�?
	INT 21H
	;�ٴ�������ȷֵ
	LEA DX,STRING7
	MOV AH,09H
	INT 21H
	JMP INPUT
PUSHSTACK:
	POP AX ;�������ֳ�ջ
 	MOV [SI],AX
 	MOV DX,AX
 	MOV DH,0
 	MOV AH,6H
 	INT 21H
 	RET

;С���б�
KIDS:
	LEA SI,I
	MOV AX,[SI]
	SUB AX,30H
	MOV AH,0	
	;���ӵڼ���С����ʼ����serial��
	LEA SI,serial
	MOV [SI],AX
	
	LEA SI,N
	;С��������
	MOV CX,[SI]
	INC CX
	PUSH CX
	
	LEA SI,LIST_CH;�������б��׵�ַ
	MOV AX,31H
	LOP_IN:
		MOV [SI], AX;��ұ�Ŵ��봮
		;��ַ+1
		INC SI
		;��ұ��+1
		INC AX
		;�����������ջ
		POP CX
		;С����������ջ
		PUSH CX
		;�ж���ջ����Ƿ�ȫ
		SUB CX,AX
		JNE LOP_IN;ѭ��
		MOV AX,'$';��־λ
		
		;��־λ����ĩ
		MOV [SI],AX 
		;С��������ջ
		POP CX 
		;��Ϸ������
		JMP MAIN
;;;��Ϸ������;;;
MAIN:
	LEA SI,N
	MOV AX,[SI];ʣ�µ�С�� 
	MOV AH,0
	SUB AX,30H
	LEA SI,REST
	MOV [SI],AX
	
	LEA SI,I
	MOV AX,[SI];iΪ���
	MOV AH,0
	SUB AX,30H
	LEA SI,serial
	MOV [SI],AX
	JMP GAMELOP;��ʼ��Ϸѭ��
	
GAMELOP:;ѭ��
	LEA SI,REST;���ʣ���������
	MOV AX,[SI]
	MOV AH,0
	;ָ��ֻʣһ�˲Ž���
	CMP AX,1
	JE RESULT;������
	LEA SI,serial
	MOV AX,[SI];��ȡ���
	MOV AH,0
	
	LEA SI,M
	MOV BX,[SI];��ȡ��һ����ʼ��С��
	MOV BH,0
	SUB BX,30H
	;M--��ȷ��ɾ����λ��
	DEC AX
	ADD AX,BX 
	
	LEA SI,REST
	MOV BX,[SI]
	PUSH BX;ʣ�µ���ҽ�ջ
	DIV BL;ȡ��
	MOV AL,AH
	MOV AH,0
	;���λ0
	CMP AX,0;
	;Ϊ0 ����ת
	JE ZER
	LEA SI,TODELE
	MOV [SI],AX
	LEA SI,serial
	MOV [SI],AX
	POP AX
	DEC AX
	LEA SI,REST
	MOV [SI],AX
	JMP DELET;����TODELEɾ����ָ̭�����
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
		JMP DELET;����TODELE��ָ̭�����
	DELET:
		MOV CX,'$'
		LEA SI,TODELE
		MOV BX,[SI];��ȡɾ����λ��
		MOV BH,0
		
		LEA SI,LIST_CH
		ADD SI,BX;��SIָ���ɾ��С��λ�õĺ�һλ
		MOV AX,SI
		DEC AX
		MOV DX,[SI]
		MOV DH,0
		PUSH SI
		MOV SI,AX
		MOV [SI],DX;�����λ��ǰ��
				   ;ֱ�Ӹ���ǰһ����
		
		POP SI
		CMP DX,CX
		JE GAMELOP;�ƶ�����־λ$����ת������һ����Ϸ
		LOP_D:
			MOV AX,SI
			INC SI
			MOV DX,[SI]
			MOV DH,0;���ν����λ��ǰ��
			PUSH SI ;����ǰһ�����λ�á���һ�������ǵ��Ǳ�ɾ�����
			MOV SI,AX
			MOV [SI],DX
			POP SI
			CMP DX,CX
			JE GAMELOP;��ת������һ����Ϸ
			JMP LOP_D;�����ƶ�
;������
RESULT:
	MOV DL,0AH
	MOV AH,6H
	INT 21H
	LEA DX,STRING4;�����ʾ��Ϣ
	MOV AH,9H
	INT 21H
	
	LEA SI,LIST_CH;��������Ϸ����ʱ��С���б�
	MOV AX,[SI]
	;ADD AX,30H
	MOV AH,0
	PUSH AX;δ��̭�����ջ
	MOV DX,AX
	MOV AH,6H
	INT 21H
	
	MOV DL,0AH;�س�
	INT 21H
	
	LEA DX,STRING5;��ʾ��Ϣ
	MOV AH,9H
	INT 21H
	LEA SI,N
	MOV BX,[SI];����˳���Ϣ
	MOV BH,0
	MOV CX,0
	MOV DX,30H;����˳��ı��
	LOP_OUT:
		INC DL
		CMP DX,BX
		JA FIN;�����������ת�������Ϊ�
		PUSH AX
		;������Ƿ���ʤ���߱��
		CMP AX,DX
		JE LOP_OUT;�������ñ��?
		MOV AH,6H
		INT 21H;������
		;ѭ���������
		JMP LOP_OUT

FIN:
	MOV AH,4CH
	INT 21H
CODES ENDS
    END START



