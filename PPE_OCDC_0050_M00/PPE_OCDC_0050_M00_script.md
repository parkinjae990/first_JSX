/**
 * 01. 업무구분	: PPE_OCDC_0050_M00
 * 02. 프로그램명	: 객실예약신청
 * 03. 화면설명	: 객실예약신청
 * 04. 작성일		: 
 * 05. 작성자		: 
 * 06. 작성이력	:
 * 07. 수정일		: -  
 * 08. 수정이력	: -
 **************************************************************************************************
 * 수정일			이름		사유
 **************************************************************************************************
 * 
 **************************************************************************************************
 */

// =================================================================================================
// ▶ include 선언부
// =================================================================================================
// 공통 라이브러리
include "Lib::comInclude.xjs"
// =================================================================================================
// ▶ 폼 전역변수 선언부
// =================================================================================================

// =================================================================================================
// ▶ Form Event Handler
// =================================================================================================
this.form_onload = function (obj:Form, e:nexacro.LoadEventInfo)
{	
	// Form Load 시 공통 기능 처리
	this.gfn_formOnLoad(obj);
	
	// 기본 날짜 설정 
	this.div_main.form.cal_startdt.set_value(GFN.getToday());
	this.div_main.form.cal_enddt.set_value(GFN.getToday());
	this.fn_setEndDate();
	
	//trace(this.ds_in.saveXML());
	this.div_main.form.spn_inwon.set_value(5); // 이용인원 5인으로 고정 
	this.div_main.form.rdo_type.set_value("A");
	this.fn_setGubun();
	
	
};
this.fn_setGubun = function (){
	if(GFN.isNull(this.div_main.form.cmb_gubun.value)){
		this.div_main.form.cmb_gubun.set_value(0); //cmb가 0이면 - 선택  - 
	}
}
// 다음날 설정 스크립트 
this.fn_setEndDate = function ()
{
	// 1. 오늘 일자 가져옴 
	var sToday = GFN.getToday();
	trace("sToday = " + sToday); 
		
	// 2. 가져온 날짜 문자열을 기반으로 Date 객체를 생성합니다.
	
	var year = parseInt(sToday.substr(0, 4));
	var month = parseInt(sToday.substr(4, 2)) - 1;
	var day = parseInt(sToday.substr(6, 2));
	var objDate = new Date(year, month, day);

	// 3. 생성된 Date 객체에 하루를 더합니다. setDate 함수가 월과 년도를 자동으로 계산해줍니다. [3, 13]
	objDate.setDate(objDate.getDate() + 1);

	// 4. 다음 날짜를 "YYYYMMDD" 형식의 문자열로 변환합니다.
	// getMonth()는 0부터 반환하므로 +1을 해주고, padLeft를 사용해 월과 일이 항상 두 자리가 되도록 합니다. [2, 4]
	var nextYear = objDate.getFullYear();
	var nextMonth = (objDate.getMonth() + 1).toString().padLeft(2, "0");
	var nextDay = objDate.getDate().toString().padLeft(2, "0");
	var sTomorrow = nextYear + nextMonth + nextDay;

	// 5. 종료일을 계산된 내일 날짜로 설정합니다.
	this.div_main.form.cal_enddt.set_value(sTomorrow);
		trace(sTomorrow);
	
}

// =================================================================================================
// ▶ 공통버튼 Event Handler
// =================================================================================================
this.fn_search = function()
{
}
// =================================================================================================
// ▶ 사용자 정의 Function
// =================================================================================================

** substr >>  문자열에서 원하는 위치에 있는 문자열을 얻기위해 사용함 
문자열.substr(시작 위치, 길이)
