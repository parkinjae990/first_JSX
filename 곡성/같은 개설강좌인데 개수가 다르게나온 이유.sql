--같은 개설강좌인데 개수가 다르게 나온 이유 
/*
조인의 방식에 의해서 데이터가 같은 개설강좌에 대한 정보인데 데이터의 개수가 다르게 나왔음 

1)의 경우
TH_GYOG_LCTRE_ACTPLN_SUMRY(강의계획서 교과개요) 테이블과 INNER JOIN을 사용해서, 강의계획서 교과개요에 데이터가 없으면
생략 되었기 때문에 1013건이 나왔음

2)의 경우
TH_GYOG_LCTRE_ACTPLN_SUMRY(강의계획서 교과개요) 테이블과 LEFT OUTER JOIN을 사용해서, 강의계획서 교과개요에 데이터가 없어도 
조인이 되기 때문에 1029건이 나왔음 

강의 계획서 교과개요가 작성되지 않아도 가져온다는 조건이면 LEFT OUTER JOIN을 사용하고, 
강의 계획서 교과개요가 작성되어야 한다면, INNER JOIN을 사용한다. 

*/
-- 1) 개설강좌기본정보조회 
         SELECT    A.YEAR              							     										-- 학년도
	             , A.SEMSTR_CD          						     										-- 학기 (2180)
	             , UF_CMM_UCODENM(A.SEMSTR_CD, UPPER('ko') ) AS SEMSTR_NM     			-- 학기명
	             , A.SBJECT_CD          						     										-- 과목코드
	             , B.SBJECT_NM          						     										-- 과목명
	             , FF.LESSON_TY_CD																			-- 수업유형코드(2594)
	             , UF_CMM_UCODENM(FF.LESSON_TY_CD, UPPER('ko') ) AS LESSON_TY_NM     	-- 수업유형명
	             , A.CRCLM_GRADE_CD     						     										-- 수강학년 (2180)
	             , UF_CMM_UCODENM(A.CRCLM_GRADE_CD, UPPER('ko') ) AS CRCLM_GRADE_NM 	-- 수강학년명
	             , A.ATNLC_BAN          						     										-- 수강반
	             , A.COMPL_SE_CD        					         										-- 이수구분 (2590)
	             , UF_CMM_UCODENM(A.COMPL_SE_CD, UPPER('ko') ) AS COMPL_SE_NM 			-- 이수구분명
	             , E.LECTURE_TIME            																-- 강의시간
	             , E.LCTRUM																					-- 강의실
	             , CASE WHEN A.ATNLC_REQST_NMPR = 0 OR A.ATNLC_REQST_NMPR IS NULL THEN '무제한'
	                    WHEN A.ATNLC_REQST_NMPR  <=  D.TOTAL_CNT THEN '신청마감'
	                    ELSE A.ATNLC_REQST_NMPR - D.TOTAL_CNT || ' / ' || A.ATNLC_REQST_NMPR
	                    END AS RMNNG_SEATS      															-- 남은좌석
	                    
	             , D.TOTAL_CNT                                       										-- 수강인원
	             , D.FNOT_CNT                                       										-- 이수인원
	             , A.THEORY_TIME                                     										-- 이론학점
	             , A.PRCTICE_TIME                                    										-- 실습학점
	             , A.PNT AS PNT 			 																-- 총학점 
	             , NVL(A.RCOGN_TIMECNT, A.THEORY_TIME + A.PRCTICE_TIME) AS SISU 						 			-- 시수
	             , UF_CMM_DEPTNM(A.DEPT_NO, UPPER('ko') ) AS DEPT_NM       	 		-- 담당학과코드
	             , UF_CMM_UCODENM(C.JBGP_CD) AS JBGP_NM											 			-- 직종
	             , UF_CMM_UCODENM(C.CLSF_CD, UPPER('ko') ) AS CLSF_NM 		 			-- 직급명
	             , A.CHRG_PROFSR_NO                                  										-- 대표교수코드
	             , C.KOR_NM                                          										-- 대표교수명
	             , UF_CMM_DEPTNM(C.DEPT_NO, UPPER('ko') ) AS PROFSR_DEPT_NM 	 		-- 교수학과
	             , UF_ADM_PSNL_GET(A.CHRG_PROFSR_NO, 'MBTLNUM') AS MBTLNUM									-- 교수 연락처
	             , A.REPRSNT_BAN_AT                                  										-- 대표반여부
	             , A.MRG_BAN_NO                                      										-- 합반번호
	             , A.STUDY_MTHD_CD																			--수업방식
	             , UF_CMM_UCODENM(A.STUDY_MTHD_CD, UPPER('ko') ) AS STUDY_MTHD_CD_NM
             
	     FROM       TH_SUUP_ESTBL_LCTRE A 																	-- 개설학과 테이블
	     INNER JOIN TH_GYOG_LCTRE_ACTPLN_SUMRY FF															-- 강의계획서 교과개요 테이블
				 ON A.YEAR = FF.YEAR
				AND A.SEMSTR_CD = FF.SEMSTR_CD
				AND A.DEPT_NO = FF.DEPT_NO
				AND A.SBJECT_CD = FF.SBJECT_CD
				AND A.ATNLC_BAN = FF.ATNLC_BAN
				 		     
	     INNER JOIN  TH_GYOG_COURSE_M B 	    															-- 교과목마스터 테이블
	             ON A.SBJECT_CD = B.SBJECT_CD
	     LEFT OUTER JOIN TA_PSNL_M C         																-- 인사마스터 테이블
	                  ON A.CHRG_PROFSR_NO = C.EMPNO
	     INNER JOIN (
         		  	 SELECT  A.SBJECT_CD																    -- 과목코드
					 	   , A.YEAR																		    -- 년도
						   , A.DEPT_NO         															    -- 학과코드
						   , A.CRCLM_GRADE_CD  															    -- 교과과정학년코드
						   , A.SEMSTR_CD       															    -- 학기
						   , A.ATNLC_BAN       															    -- 반
						   , COUNT(B.STDNO) AS TOTAL_CNT 												    -- 수강인원
						   , SUM(CASE WHEN B.EVL_GRAD !='F' THEN 1 ELSE 0 END) AS FNOT_CNT 				    -- 이수인원
					 FROM  TH_SUUP_ESTBL_LCTRE  A 														    -- 개설강좌
					 LEFT OUTER JOIN TH_SUGA_ATNLC_REQST  B 											    -- 수강신청
								  ON A.YEAR = B.YEAR
								 AND A.SEMSTR_CD = B.SEMSTR_CD
								 AND A.DEPT_NO = B.CRCLM_DEPT_NO
								 AND A.CRCLM_GRADE_CD = B.CRCLM_GRADE_CD
								 AND A.SBJECT_CD = B.SBJECT_CD
								 AND A.ATNLC_BAN = B.CRCLM_ATNLC_BAN
					 WHERE A.YEAR = '2025'
					  
--					 AND A.SEMSTR_CD = '2180200'
					  
					  
					  
					 GROUP BY A.SBJECT_CD, A.YEAR, A.DEPT_NO, A.CRCLM_GRADE_CD, A.SEMSTR_CD, A.ATNLC_BAN
					) D
	             ON A.YEAR = D.YEAR
	         	AND A.SEMSTR_CD = D.SEMSTR_CD
	         	AND A.DEPT_NO = D.DEPT_NO
	         	AND A.CRCLM_GRADE_CD = D.CRCLM_GRADE_CD
	         	AND A.ATNLC_BAN = D.ATNLC_BAN
	         	AND A.SBJECT_CD = D.SBJECT_CD  -- 수강신청인원
	         
	     LEFT OUTER JOIN (
					 	  SELECT  A.YEAR
								, A.SEMSTR_CD
								, A.DEPT_NO
								, A.SBJECT_CD
								, A.GRADE_CD
								, A.CLSS
								, LISTAGG(A.LECTURE_TIME, ',') WITHIN GROUP(ORDER BY A.WEEK_CD, A.DGHT_SE_CD, A.TIME_FR) AS LECTURE_TIME
								, LISTAGG(B.BULD_NM||' '||A.LCTRUM_CD, ', ') WITHIN GROUP(ORDER BY A.WEEK_CD, A.DGHT_SE_CD, A.TIME_FR) AS LCTRUM
						  FROM (
								SELECT  YEAR			                                                                                                                           -- 년도
									  , SEMSTR_CD		                                                                                                                           -- 학기(2180)
									  , DEPT_NO			                                                                                                                           -- 학과코드
									  , SBJECT_CD		                                                                                                                           -- 과목코드                    
									  , GRADE_CD		                                                                                                                           -- 학년(2170)                  
									  , CLSS			                                                                                                                           -- 분반                        
									  , WEEK_CD			                                                                                                                           -- 요일(1590)                  
									  , DGHT_SE_CD		                                                                                                                           -- 주야구분(1330)              
									  , TIME_FR			                                                                                                                           -- 시간(시작)                  
									  , CASE WHEN TIME_FR = TIME_TO THEN UF_CMM_UCODENM(WEEK_CD) || ' ' || TIME_FR || '(' || UF_CMM_UCODENM(DGHT_SE_CD) || ')'
											 WHEN TIME_FR != TIME_TO THEN UF_CMM_UCODENM(WEEK_CD) || ' ' || TIME_FR || '~' ||TIME_TO || '(' || UF_CMM_UCODENM(DGHT_SE_CD) || ')'
											 END AS LECTURE_TIME  																												   -- 강의시간
									  , BULD_CD		-- 건물코드
									  , LCTRUM_CD	-- 강의실코드
								FROM TH_SUUP_ESTBL_LCTRE_TIME
							
								UNION ALL
							
								SELECT  YEAR		                                                                                                                               -- 년도
									  , SEMSTR_CD	                                                                                                                               -- 학기(2180)
									  , DEPT_NO		                                                                                                                               -- 학과코드
									  , SBJECT_CD	                                                                                                                               -- 과목코드
									  , GRADE_CD	                                                                                                                               -- 학년(2170)
									  , CLSS		                                                                                                                               -- 분반
									  , WEEK_CD		                                                                                                                               -- 요일(1590)
									  , DGHT_SE_CD	                                                                                                                               -- 주야구분(1330)
									  , TIME_FR		                                                                                                                               -- 시간(시작)
									  , CASE WHEN TIME_FR = TIME_TO THEN UF_CMM_UCODENM(WEEK_CD) || ' ' || TIME_FR || '(' || UF_CMM_UCODENM(DGHT_SE_CD) || ')'
											 WHEN TIME_FR != TIME_TO THEN UF_CMM_UCODENM(WEEK_CD) || ' ' || TIME_FR || '~' ||TIME_TO || '(' || UF_CMM_UCODENM(DGHT_SE_CD) || ')'
											 END AS LECTURE_TIME
									  , BULD_CD		                                                                                                                               -- 건물코드
									  , LCTRUM_CD	                                                                                                                               -- 강의실코드
								FROM TH_SUUP_ESTBL_LCTRE_REMOTE		                                                                                                               --원격
							
								UNION ALL
	                                                                                                                                                                               
								SELECT  YEAR		                                                                                                                               -- 년도
									  , SEMSTR_CD	                                                                                                                               -- 학기(2180)
									  , DEPT_NO		                                                                                                                               -- 학과코드
									  , SBJECT_CD	                                                                                                                               -- 과목코드
									  , GRADE_CD	                                                                                                                               -- 학년(2170)
									  , CLSS		                                                                                                                               -- 분반
									  , WEEK_CD		                                                                                                                               -- 요일(1590)
									  , DGHT_SE_CD	                                                                                                                               -- 주야구분(1330)
									  , TIME_FR		                                                                                                                               -- 시간(시작)
									  , CASE WHEN TIME_FR = TIME_TO THEN UF_CMM_UCODENM(WEEK_CD) || ' ' || TIME_FR || '(' || UF_CMM_UCODENM(DGHT_SE_CD) || ')'
											 WHEN TIME_FR != TIME_TO THEN UF_CMM_UCODENM(WEEK_CD) || ' ' || TIME_FR || '~' ||TIME_TO || '(' || UF_CMM_UCODENM(DGHT_SE_CD) || ')'
											 END AS LECTURE_TIME
									  , BULD_CD		                                                                                                                               -- 건물코드
									  , LCTRUM_CD	                                                                                                                               -- 강의실코드
								FROM TH_SUUP_CNCTR_COMPL_TABLE
							   ) A
						  LEFT OUTER JOIN TH_SUUP_BULD B
						  ON A.BULD_CD = B.BULD_CD
						  GROUP BY A.YEAR, A.SEMSTR_CD, A.DEPT_NO, A.SBJECT_CD, A.GRADE_CD, A.CLSS
						 ) E  
	         		ON A.YEAR = E.YEAR
	          	   AND A.SEMSTR_CD = E.SEMSTR_CD
	          	   AND A.DEPT_NO = E.DEPT_NO
	          	   AND A.SBJECT_CD = E.SBJECT_CD
	          	   AND A.CRCLM_GRADE_CD = E.GRADE_CD 
	          	   AND A.ATNLC_BAN = E.CLSS
	     WHERE A.YEAR = '2025'
		  
		 AND A.SEMSTR_CD = '2180200'
		  
		  
		  
	     ORDER BY A.SEMSTR_CD, A.DEPT_NO, A.SBJECT_CD, A.CRCLM_GRADE_CD, A.ATNLC_BAN, A.COMPL_SE_CD;
         
         
         select count(*) from TH_SUUP_ESTBL_LCTRE
         where YEAR = '2025'
            and SEMSTR_CD='2180200';



-- 2) 과목별 강좌개설

SELECT A.YEAR						  --년도
			 ,A.SEMSTR_CD                     --학기(2180)
			 ,A.DEPT_NO                       --학과코드
			 ,NVL(UF_HAK_DEPT_MAJOR_GET(A.DEPT_NO), UF_CMM_DEPTNM(A.DEPT_NO)) AS DEPT_NM
			 ,A.CRCLM_GRADE_CD                --교과과정학년(2170)
			 ,A.ATNLC_BAN					  --수강반
			 ,A.SBJECT_CD                     --과목코드
			 ,D.SBJECT_NM AS SBJECT_NM  	  --과목명
			 ,A.ATNLC_BAN                     --수강반
			 ,A.COMPL_SE_CD                   --이수구분코드(2590)
             ,C.COMPL_CRSE_CD                 --이수과정(2592)			 
			 ,A.PNT                           --학점
			 ,A.THEORY_TIME                   --이론시간
			 ,A.PRCTICE_TIME                  --실습시간
			 ,CASE 
	          WHEN A.RCOGN_TIMECNT IS NOT NULL
	          THEN A.RCOGN_TIMECNT  /* RCOGN_TIMECNT 값이 있으면 그 값을 사용 */
	          ELSE (NVL(A.THEORY_TIME, 0) + NVL(A.PRCTICE_TIME, 0))
	          END AS INSTRCTRFEE_PYMNT_TIMECNT		  --강사료지급시수
			 ,A.REPRSNT_PROFSR_NO             --대표교수코드
			 ,A.CHRG_PROFSR_NO                --담당교수코드			 
             ,NVL(B.KOR_NM, H.CHRG_PROFSR_NM) AS KOR_NM       --성명: 인사정보 없으면 임시교수명
			 ,UF_ADM_PSNL_GET(A.CHRG_PROFSR_NO, 'MBTLNUM') AS MBTLNUM --전화번호
			 ,A.CHRG_PROFSR_NMPR              --담당교수인원수
			 ,A.DGHT_SE_CD                    --주야구분(1330)
			 ,A.PRCTICE_SBJECT_SE_CD          --실습과목구분코드(2190)
			 ,A.LCTRE_EVL_AT                  --강의평가여부
			 ,A.LCTRE_SE_CD                   --강좌구분코드(2770)
			 ,A.ELCTRN_ATEND_USE_AT           --전자출결사용여부
			 ,A.ATNLC_REQST_NMPR              --수가신청인원
			 ,A.SCRE_LAST_USER                --성적마지막사용자
			 ,A.SCRE_LAST_UPDT_DE             --성적마지막수정일자
			 ,A.CNCTR_COMPL_AT                --집중이수제여부
			 ,A.CYBER_LCTRE_AT                --사이버강좌여부
			 ,A.CREAT_EDC_YEAR                --생성교육과정년도
			 ,A.MRG_BAN_NO                    --합반번호
			 ,CASE WHEN A.MRG_BAN_NO IS NOT NULL THEN 'Y' ELSE 'N' END AS BAN_AT
			 ,A.SCRE_PASS_SE_AT               --성적PASS NON-PASS 구분여부
			 ,A.SCRE_PASS_SE_AT AS PASS_AT	  --P/NP 수정여부 확인 COL
			 ,A.ATEND_EXCL_AT                 --출석제외여부(Y/N)
			 ,A.REL_EVL_AT                    --상대평가여부(Y/N)
			 ,A.SCRE_CLOS_AT                  --성적마감여부(Y/N)
			 ,A.SCRE_OTHBC_AT                 --성적공개여부(Y/N)
			 ,A.TEAM_TEACH_AT                 --팀티칭여부(Y/N)
			 ,A.SPT_PRCTICE_AT				  --현장실습여부(Y/N)
			 ,A.CANCLSS_NMPR                  --폐강인원
			 ,A.CANCLSS_AT                    --폐강여부
			 ,A.CANCLSS_RESN                  --폐강사유
			 ,A.CANCLSS_DE                    --폐강일자
			 ,A.USE_AT                        --사용여부 2023.11.03추가
			 ,G.LESSON_TY_CD                  --수업유형코드(2594)
			 ,A.STUDY_MTHD_CD				  --수업방식(2255)
			 ,A.STUDY_MTHD_CD AS STD_CD		  --수업방식(수정여부 확인용 2255)
			 ,E.CNT
			 ,F.CNT_CHK						  --시간표
--			 ,CASE WHEN A.CHRG_PROFSR_NO IS NULL THEN 'theme://images/ico_expandP.png'
--			 	ELSE 'theme://images/img_grd_delete.png'
--			  END AS BTN_THEME	-- 직번 버튼 theme
--			 ,CASE WHEN A.CHRG_PROFSR_NO IS NULL THEN 'N'
--			 	ELSE 'Y'
--			  END AS PRF_AT 	--직번 존재 시 삭제버튼 활성화, 직번 없으면 팝업버튼 활성화

			 ,A.DGHT_SE_CD AS DGHT_SE_CD2
			 ,A.CHRG_PROFSR_NO AS CHRG_PROFSR_NO2
			 ,A.CNCTR_COMPL_AT AS CNCTR_COMPL_AT2
			 ,A.STUDY_MTHD_CD AS STUDY_MTHD_CD2
	         
	         ,NVL(A.RCOGN_TIMECNT_AT, 'N') AS RCOGN_TIMECNT_AT		--인정시수여부
	         
		 FROM TH_SUUP_ESTBL_LCTRE A		--개설강좌
		 
		      LEFT OUTER JOIN TA_PSNL_M B 	--인사마스터 
		      ON A.CHRG_PROFSR_NO = B.EMPNO
		      
		      LEFT OUTER JOIN(SELECT COMPL_CRSE_CD
	                        ,CRCLM_YEAR
	                        ,SBJECT_CD
	                        ,CRCLM_GRADE_CD
	                        ,CRCLM_DEPT_NO
	                        ,CRCLM_SEMSTR_CD
                  	FROM TH_GYOG_CRCLM_TABLE
              		)  C 	-- 교과과정표
		      ON A.CREAT_EDC_YEAR = C.CRCLM_YEAR
		      AND A.SBJECT_CD = C.SBJECT_CD 
              AND A.CRCLM_GRADE_CD = C.CRCLM_GRADE_CD
              AND A.DEPT_NO = C.CRCLM_DEPT_NO
              AND A.SEMSTR_CD = C.CRCLM_SEMSTR_CD
		      		      
		      INNER JOIN TH_GYOG_COURSE_M D
		      ON A.SBJECT_CD = D.SBJECT_CD
		      
		      LEFT OUTER JOIN (SELECT YEAR
                                    ,SEMSTR_CD
                                    ,SBJECT_CD
                                    ,CRCLM_DEPT_NO
                                    ,CRCLM_GRADE_CD                                    
                                    ,CRCLM_ATNLC_BAN
                                    ,COUNT(STDNO) AS CNT
                                FROM TH_SUGA_ATNLC_REQST
                                WHERE (WTHDRAW_STTUS_CD != '2300103' OR WTHDRAW_STTUS_CD IS NULL)	-- 철회처리상태
	    							AND NVL(USE_AT, 'Y') != 'N'       -- 사용여부
                                GROUP BY YEAR
                                    ,SEMSTR_CD
                                    ,SBJECT_CD
                                    ,CRCLM_DEPT_NO
                                    ,CRCLM_GRADE_CD                                    
                                    ,CRCLM_ATNLC_BAN
                                ) E
		      ON A.YEAR = E.YEAR
		      AND A.SEMSTR_CD = E.SEMSTR_CD
		      AND A.SBJECT_CD = E.SBJECT_CD
		      AND A.DEPT_NO = E.CRCLM_DEPT_NO
		      AND A.CRCLM_GRADE_CD = E.CRCLM_GRADE_CD
		      AND A.ATNLC_BAN = E.CRCLM_ATNLC_BAN
	          LEFT OUTER JOIN (
			                   SELECT  A.YEAR
			                         , A.SEMSTR_CD
			                         , A.DEPT_NO
			                         , A.SBJECT_CD
			                         , A.GRADE_CD
			                         , A.CLSS
			                         , COUNT(*) AS CNT_CHK
			                   FROM    (
			                           SELECT    YEAR
			                                   , SEMSTR_CD
			                                   , DEPT_NO
			                                   , SBJECT_CD
			                                   , GRADE_CD
			                                   , CLSS     
			                           FROM    TH_SUUP_ESTBL_LCTRE_TIME 
			                           WHERE   1 = 1
			                           AND     YEAR = '2025'
			                           AND     SEMSTR_CD = '2180200'
			                           
			                           UNION ALL
			                           
			                           SELECT    YEAR
			                                   , SEMSTR_CD
			                                   , DEPT_NO
			                                   , SBJECT_CD
			                                   , GRADE_CD
			                                   , CLSS
			                           FROM    TH_SUUP_CNCTR_COMPL_TABLE 
			                           WHERE   1 = 1
			                           AND     YEAR = '2025'
			                           AND     SEMSTR_CD = '2180200'
			                           
			                           UNION ALL
			                           
			                           SELECT    YEAR
			                                   , SEMSTR_CD
			                                   , DEPT_NO
			                                   , SBJECT_CD
			                                   , GRADE_CD
			                                   , CLSS 
			                           FROM    TH_SUUP_ESTBL_LCTRE_REMOTE 
			                           WHERE   1 = 1
			                           AND     YEAR = '2025'
			                           AND     SEMSTR_CD = '2180200'
			                           ) A
			                   WHERE   1 = 1
			                   GROUP BY A.YEAR
			                          , A.SEMSTR_CD
			                          , A.DEPT_NO
			                          , A.SBJECT_CD
			                          , A.GRADE_CD
			                          , A.CLSS        
			                   ) F
                 ON A.YEAR           = F.YEAR
                AND A.SEMSTR_CD      = F.SEMSTR_CD
                AND A.DEPT_NO        = F.DEPT_NO
                AND A.CRCLM_GRADE_CD = F.GRADE_CD
                AND A.SBJECT_CD      = F.SBJECT_CD
                AND A.ATNLC_BAN      = F.CLSS
           LEFT OUTER JOIN TH_GYOG_LCTRE_ACTPLN_SUMRY G
                ON A.YEAR = G.YEAR
                AND A.SEMSTR_CD = G.SEMSTR_CD
                AND A.SBJECT_CD = G.SBJECT_CD
                AND A.DEPT_NO = G.DEPT_NO
                AND A.ATNLC_BAN = G.ATNLC_BAN          
            LEFT OUTER JOIN TH_SUUP_TEMP_PROFSR H
                ON A.CHRG_PROFSR_NO = H.CHRG_PROFSR_EMPNO                        
	    WHERE A.YEAR = '2025'
	   
		AND A.SEMSTR_CD = '2180200'
	   
	   
	    
	   
	   
		  
	    ORDER BY A.SEMSTR_CD, A.DEPT_NO, A.SBJECT_CD, A.CRCLM_GRADE_CD, A.ATNLC_BAN, A.COMPL_SE_CD



        