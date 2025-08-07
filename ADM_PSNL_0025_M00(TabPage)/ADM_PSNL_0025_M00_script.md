/**
 * 01. 업무구분	: ADM_PSNL_0125_M00
 * 02. 프로그램명	: 보직발령대장
 * 03. 화면설명	: 보직발령대장
 * 04. 작성일		: 2025.05.13
 * 05. 작성자		: bjw
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
	
	// 코드세팅
	this.fn_setCode();

};

this.fn_setCode = function () 
{
	var codeMappings = [
		{  // 보직임용구분  
			objComp : this.div_search.form.cmb_bojik,
			nameSpace : "AdmPsnl0125Mapper",
			sqlId : "selectBojik",
			codecolumn : "cd",
			datacolumn : "nm",
			promptType : "A",
		},		
	];
	this.gfn_commonCodeMapping(codeMappings, function(){
		
	});
}


// =================================================================================================
// ▶ 공통버튼 Event Handler
// =================================================================================================
this.fn_search = function ()
{
		var oData = {
			svcid : "selectList",
			svcList : [
				{
					action	  : ComService.$.SEARCH,
					nameSpace : "AdmPsnl0125Mapper",
					sqlId	  : "selectList",
					inds      : "ds_in",
					outds	  : "ds_list",
				}
			]
		};
		this.doAction(oData).then(function(form, e) {
			//form.gfn_goSavePos(form.ds_list);
			form.sta_Cnt.set_text("총 "+ form.ds_list.rowcount +"건");
			//trace(form.ds_list.saveXML());
			var v_cnt = form.ds_list.rowcount;
			if(v_cnt < 1){
				form.gfn_alertMsg("해당 검색조건에 맞는 데이터가 존재하지 않습니다.");
				return;
			}
		});
	
	// 중복체크
// 	var isDup = this.gfn_insertRowDupCheck(this.ds_list, ["busCd"]);
// 	
// 	if(isDup){
// 		this.gfn_alertMsg("중복된코드");
// 		return;
// 	}
	
};


/**
 * 엑셀다운로드 처리
 * @return
 */
this.fn_excel = function () {
	this.gfn_exportExcel(this, this.Grid00, this.gfn_getProgramTitle());
};

// =================================================================================================
// ▶ 사용자 정의 Function
// =================================================================================================
