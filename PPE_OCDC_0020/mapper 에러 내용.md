mapper 내부의 쿼리 

```
<insert id="insert">
					DECLARE
				VCNT NUMBER;
		
		BEGIN
		
			SELECT SEQ_JSSDRLRM.NEXTVAL
			   INTO VCNT
			  FROM DUAL;		
			  
			IF #{num} > 0 THEN
				FOR i IN 1..#{num} LOOP
					FOR j IN 1..#{roomCount} LOOP
						INSERT INTO EAGLE.JSSDRLRE(
							RES_DATE,
							ROOM_TYPE,
							RES_NUM
						)
						VALUES(
							--TO_CHAR(#{staDate}+(i-1),'yyyymmdd'),
							TO_CHAR(TO_DATE(#{staDate},'YYYYMMDD')+(i-1),'YYYYMMDD'),
							#{roomType},
	  						VCNT
						);
					END LOOP;
				END LOOP;
					INSERT INTO EAGLE.JSSDRLRM(	
						RES_NUM,
						RES_DATE,
						IRUM,
						ROOM_TYPE,
						ROOM_COUNT,
						STERM,
						ETERM,
						TEL,
						HP,
						STATE,
						USERID,
						USEDATE,
						TOTAL,
						GUBUN,
						BIRTH,
						BIGO,
						INWON_CNT
					)
					VALUES(
	  					VCNT,
						sysdate,
						#{irum},
						#{roomType},
						#{roomCount},
						TO_DATE(#{staDate},'YYYYMMDD'),
						TO_DATE(#{endDate},'YYYYMMDD'),
						#{tel},
						#{hp},
						'1',	--입금대기중 
						DECODE(#{userId},'','web',#{userId}),
						sysdate,
						#{total},
						#{gubun},
						#{birth},
						#{bigo},
						#{inwonTotal})
					;
					
					INSERT INTO EAGLE.TB_INST_SMS(
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
						#{hp},
						'신청 완료! 24시간이내 입금하세요. 전북은행 567-13-0305378, 입금자명: ''' || #{irum} || VCNT ||''' ',  -- 에러 발생의 원인 
						SYSDATE
					)	
					;
				
			ELSE
				RAISE_APPLICATION_ERROR( -20000, '객실예약신청이 정상처리되지 않았습니다. 다시 신청해주세요.' );
				ROLLBACK;
			END IF;
		END;	
	</insert>
```    

에러 내용 
```
org.apache.ibatis.type.TypeException: Could not set parameters for mapping: ParameterMapping{property='irum', mode=IN, javaType=class java.lang.Object, jdbcType=null, numericScale=null, resultMapId='null', jdbcTypeName='null', expression='null'}. Cause: org.apache.ibatis.type.TypeException: Error setting non null for parameter #22 with JdbcType null . Try setting a different JdbcType for this parameter or a different configuration property. Cause: org.apache.ibatis.type.TypeException: Error setting non null for parameter #22 with JdbcType null . Try setting a different JdbcType for this parameter or a different configuration property. Cause: java.sql.SQLException: 부적합한 열 인덱스

```