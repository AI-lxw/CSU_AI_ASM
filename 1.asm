.286
;1. �ý��ݷ��ͳ���������ʮ������ת��Ϊ����������ʮ����������
;���������ӡ���� Ļ�ϣ�369��10000��4095��32767��8000�� 
;���ݽṹ������װ����
;��һ��pop������־
;(һ)���ݷ�
;1.���ݷ�����Ҫд��Ҫת����ʮ��������
;2.���д����ʮ��������16���Ƶ�Ȩֵ��
;3.Ȼ���ҳ������а������ٸ���ӽ�������Ȩֵ�ı�����
;4.��һ��������Ӧλ���ǣ�
;5.��Ԭ����ȥ�˱�������ӦΪֵ�ĳɼ��õ�һ����ֵȥ�ҵ�һλ��Ȩֵ�ı�����
;6.��˷���֪����ֵΪ0 
;����
;1.ת������--��2.�õ������ƺ����׾Ϳ���תΪ16����
DATA    SEGMENT 
	;�˴��������ݶδ���
	STRING DB 40 DUP(?)
DATA    ENDS  
STACK SEGMENT
	;�˴������ջ�δ���
STACK ENDS
CODE   SEGMENT    
ASSUME  CS:CODE, DS:DATA,SS:STACK
BEGIN:
	MOV AX,DATA
	MOV DS,AX
	JMP ARR2
	;�˴��������δ���
;;;;;;;;;;;;;;;
;���ݷ�
;��ʼ�����飬��369��10000��4095��32767��8000�Ž�ȥ
ARR:
	PUSH 0
	PUSH 369
	PUSH 10000
	PUSH 4095
	PUSH 32767
	PUSH 8000
	;[0,369��10000��4095��32767��8000]
	;�������Ŀ���ǵ���һ��������־
	JMP TAKEOUT
;;;;;;;;;;;;;;;;;;
;����ȡ��Ҫת������
TAKEOUT:
	POP AX
	;ÿ��ȡ����Ҫ compare ��û��0����н���
	CMP AX,0
	;��ZF=1����ָ��Ľ��Ϊ0ʱ
	JZ finish;JZ ����ת�Ƶ�finish��
	MOV BX,1
	CALL SUBT
	;����1λ
	SHR BX,1
	MOV CX,AX	
	LEA SI,STRING
	CALL BINARY;����ת���������Ӻ���
	;1.ת������--��2.�õ������ƺ����׾Ϳ���תΪ16����
	CALL OUT_HX1;���ݶ����ƴ����ʮ������
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
;����������
SUBT:
	;�߼�����
	SHL BX,1;1λ
	PUSH AX
	SUB AX,BX;AX - BX 
	POP AX
	;�����Ϊ��������λS��Ϊ1������ת
	JNS SUBT;
	RET
;;;;;;;;;;;;;;;;;;
;��ת��Ϊ����������
BINARY:
	MOV AX,CX
	SUB AX,BX
	;����ָ���������ȣ������Ϊ0����ת��
	JZ ZERO
	;����������������ø�
	JS ISNEG
	;�������������������
	JNS ISPOS
;;;;;;;;;;;;;;;;;;
;����0
ZERO:
	MOV DX,BX
	SHR DX,1
	CMP DX,0
	JNE LOWEST;�Ƿ�Ϊ���λ
	
	MOV DL,31H;
	MOV AH,6
	INT 21H
	
	PUSH DX;��������һλ�� ѹ�������ջ��
	MOV DX,1H
	MOV [SI],DL
	INC SI
	POP DX	
	PUSH AX
	MOV AX,'$';�ӱ�־λ
	MOV [SI],AL
	POP AX	
	RET
;;;;;;;;;;;;;;;;;;;;;;
;����������
;�������0���ǲ������λ
LOWEST:
	MOV DL,31H;�����һ��1
	MOV AH,6H
	INT 21H	
	PUSH DX;��ӵ������ƴ�
	MOV DX,1H
	MOV [SI],DL
	INC SI
	POP DX	
	JMP OUT1
OUT1:
	MOV DX,BX
	SHR DX,1
	CMP DX,0
	JNZ PRI0;�����һ��1֮��ȫ����	
	PUSH AX
	MOV AX,'$';��ӱ�־λ�������ƴ�
	MOV [SI],AL
	POP AX
	
	RET
PRI0:;���ʣ�µ�0
	MOV DL,30H
	MOV AH,6;���0
	INT 21H
	
	PUSH DX
	MOV DX,0H;0���浽�����ƴ�
	MOV [SI],DL
	INC SI
	POP DX	
	SHR BX,1
	JMP OUT1
;���Ϊ-
ISNEG:
	SHR BX,1
	MOV DL,0
	CALL PRI;���
	JMP BINARY
;���Ϊ+
ISPOS:;
	SHR BX,1
	MOV CX,AX
	MOV DL,1H
	CALL PRI;���
	JMP BINARY
PRI:
	MOV [SI],DL
	INC SI
	ADD DL,30H
	MOV AH,6
	INT 21H
	RET
;;;;;;;;;;;;;;
;����
ARR2:;��Ҫת��������ջ
	PUSH 0
	PUSH 369
	PUSH 10000
	PUSH 4095
	PUSH 32767
	PUSH 8000
	JMP OUTSTACK
OUTSTACK:
	POP BX;Ҫת���������γ�ջ
	CMP BX,0;�Ƚ��Ƿ�Ϊ0
	JNE GOC;����Ϊ 0
	;����س�
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
	CALL LOGR;����LOGR
	;�ո����
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
;�߼�����
LOGR:
	MOV AX,BX
	SHR BX,1;����һλ
	CMP BX,0;�Ƿ�Ϊ0
	;���Ϊ0(�� ZF=1)ʱ��ת�Ƶ�FINISH1
	JZ FINISH1
	PUSH AX
	MOV AX,BX
	SHL AX,1;�߼�����
	MOV CX,AX
	POP AX
	SUB AX,CX;AX-CX
	PUSH AX;��ջ
	JMP LOGR
FINISH1:
	PUSH 1
	LEA SI,STRING
	JMP COUT1
COUT1:
	POP DX;�������ջ�Ľ��
	CMP DX,2;�ж��Ƿ���
	JNB COUT2
	
	MOV DH,0
	MOV [SI],DX;���浽�ַ���
	INC SI
	
	ADD DL,30H;���һλ
	MOV AH,6
	INT 21H
	JMP COUT1

COUT2:
	PUSH AX
	MOV AX,'$'
	MOV [SI],AX;������־
	POP AX
	
	PUSH DX
	JMP PUTHEX;16����

;;;;;;;;;;;;;;;
;���16����
PUTHEX:
	LEA SI,STRING
	MOV BP,SI
	JMP FLAG
FLAG:
	MOV AL,[SI];��SIָ��ָ��$��ǰһλ
	MOV AH,0
	INC SI
	CMP AL,'$'
	JNE FLAG;��ת��flag��־λ
	
	DEC SI
	MOV AL,0
	MOV [SI],AL
	DEC SI
	;;;;;��Ϊ��־��ջ;;;;
	MOV DX,'$'
	JMP CACUHEX
CACUHEX: 
	PUSH DX;���������߱�־��ջ
	MOV DX,0;����
	;;;ÿ�ĸ������Ķ����������Ա�ʾһλ16������;;;;;
	MOV CX,4;ÿ��ѭ��λ��Ϊ4
	LOP_HX:
		DEC CX
		CALL CACUSUM;�����ۼ��Ӻ���
		CMP SI,BP;�Ƿ�ȫ��ת�����
		JZ PRE_PRI;���ʮ�����ƽ��
		DEC SI;ָ�����һλ
		CMP CX,0;ȷ��������λ�Ƿ�ת������
		JZ CACUHEX
		JMP LOP_HX
CACUSUM:;�ۼ��Ӻ���
	PUSH AX
	MOV AL,[SI];ɾ�������ƴ�һλ
	PUSH DX
	MOV DX,0
	MOV [SI],DL;��������
	POP DX	
	MOV AH,0
	
	PUSH BX
	MOV BX,3H
	SUB BL,CL;������һλ��
	PUSH CX
	MOV CL,BL
	SHL AX,CL;����CLλ
	POP CX
	POP BX
	
	ADD DX,AX;�����ƽ�����浽DX��
	POP AX
	RET
PRE_PRI:
	PUSH DX;�������õ���һ��ʮ��������
	;�ո����
	mov AH,2
	mov DL, 32
	int 21h
	JMP COUTHEX
;;;��ӡ16������;;;;;;;;;	
COUTHEX:;
	POP AX
	MOV AH,0
	CMP AX,'$';�Ƿ��Ǳ�־λ

	JZ FIN
	CMP AX,0AH
	JB NUMBER;�������
	JMP LETTER;�����ĸ
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
;16����
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






































