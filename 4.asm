.286
;4. ���δ�ӡ�����ַ����� ASCII ֵ��ע����ţ���or example, This is a number 3692.
DATAS SEGMENT
    STRING DB 'or example, This is a number 3692.','$'
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
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
    ;����س�
	MOV DL,0AH
	MOV AH,6H
	INT 21H
    
    MOV BX,0
	JMP TRAN
TRAN:
	MOV CX,'$'
	;����ȥ����һ��������
	MOV DX,[SI]
	MOV DH,0
	;�ж��Ƿ�ȡ��������־
	CMP DX,CX
	;��Ϊ������־�����
	JE FIN
	;����ASC
	CALL ASC
	MOV DL,20H;����ո�
	MOV AH,6H
	INT 21H
	MOV DL,20H;����ո�
	MOV AH,6H
	INT 21H
	MOV DL,20H;����ո�
	MOV AH,6H
	INT 21H
	MOV DL,20H;����ո�
	MOV AH,6H
	INT 21H
	;SI����һλ
	ADD SI,1
	;����ѭ�����
	JMP TRAN

ASC:
	;��ӱ�־0FH��ջ
	MOV BX,0FH
	PUSH BX
	JMP TOASC;
;�����ASCII
TOASC:
	MOV AX,DX
	;��10ȡ��
	MOV DX,0AH
	DIV DL
	MOV BL,AH
	;����ѹ��ջ
	PUSH BX
	MOV DL,AL
	;һֱ������Ϊ0
	CMP AL,0
	;��ӡASCIIֵ
	JE REM;
	JMP TOASC;��������ȡ��
	

REM:
	;������ջ
	POP BX
	;�жϱ�־λ
	CMP BX,0FH
	;���Ϊ��־������
	JE FIN1
	MOV DL,BL
	;�������
	ADD DL,30H;��ASCII��
	MOV AH,6H
	INT 21H
	;ѭ���������
	JMP REM

FIN1:
	RET
FIN: 
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START



