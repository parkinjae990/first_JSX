BEGIN		
			UPDATE JSSDRLRM
			
			SET
				STATE = #STATE#,
				CANCEL_DATE = #CANCEL_DATE#,
				CANCEL_SAYU = #CANCEL_SAYU#,
				HBDATE = #HBDATE#,
				HBAMT = #HBAMT#,
				BANK_CODE = #BANK_CODE#,
				HBACNT = #HBACNT#
				
			WHERE RES_NUM = #RES_NUM#;
			
			<isEqual col="STATE" value="3">
 INSERT INTO TB_INST_SMS(
						SEQ,
						INSTID,
						FROMHP,
						TOHP,
						SUBS_VALUE,
						REGDATE)
					VALUES(
						INST_SMS.NEXTVAL,
						'2',
						'0634691011',
						'01020162596' ,
						'예약취소신청. 확인해주세요',
						SYSDATE
					)	;


</isEqual>
<isEqual col="STATE" value="4">
 INSERT INTO TB_INST_SMS(
						SEQ,
						INSTID,
						FROMHP,
						TOHP,
						SUBS_VALUE,
						REGDATE)
					VALUES(
						INST_SMS.NEXTVAL,
						'2',
						'0634691011',
						'01020162596' ,
						'환불신청왔습니다. 확인해주세요',
						SYSDATE
					)	;


</isEqual>
 
 
 
 
 END;