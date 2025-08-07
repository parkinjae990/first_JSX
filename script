/**
 * 01. 업무구분	: ADM_GOOD_0030_M00
 * 02. 프로그램명	: 버스 관리
 * 03. 화면설명	: 버스 관리
 * 04. 작성일		: 2025.04.08
 * 05. 작성자		: AYC
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
this.delMsg = '';
// =================================================================================================
// ▶ Form Event Handler
// =================================================================================================

this.form_onload = function (obj:Form, e:nexacro.LoadEventInfo){
	
	// Form Load 시 공통 기능 처리
	this.gfn_formOnLoad(obj);
};
// =================================================================================================
// ▶ 공통버튼 Event Handler
// =================================================================================================
/**
 * 검색 처리
 * @return
 */
this.fn_search = function ()
{
	this.gfn_confirmSave(this.ds_list, function() {
	// mapper와 연결하는 코드  
		var oData = {
			svcid : "selectList",
			svcList : [
				{
					action	  : ComService.$.SEARCH,
					nameSpace : "AdmGood0030Mapper",
					sqlId	  : "selectList",
					outds	  : "ds_list", // 쿼리 작성 후 적용할 dataset
				}
			]
		};
		this.doAction(oData).then(function(form, e) {
			form.div_main.form.sta_cnt.set_text("총 "+ form.ds_list.rowcount +"건");
			if(form.delMsg == 'T'){
				form.gfn_alertMsg("삭제완료");
				form.delMsg = '';
			}else if(form.ds_list.rowcount < 1){
				form.gfn_alertMsg("해당 검색조건에 맞는 데이터가 존재하지 않습니다.");
				return;	
			}
			form.gfn_goSavePos(form.div_main.form.grd_list);
			form.gfn_setStatus("search", form.ds_list.rowcount);
			
			
		});
	});
};


// 신규 처리
this.fn_insert = function (){
	
	var	nRow	=	this.ds_list.addRow();
	
	this.ds_list.setColumn(nRow , "busNo", this.ds_list.rowcount);
	this.ds_list.setColumn(nRow , "usingynV", "1");
}

// /**
//  * 저장 유효성 검사
//  */
this.fn_saveCheck = function () {
	//마감여부 체크 시 마감일시 검사

	var validationMappings = {
		"xcomp" : this.ds_list, //DataSet

		"busNo" : { //차량번호
			"required" : {
				colNm : "차량번호"
			}
		},
		"busSnm" : { //차량명
			"required" : {
				colNm : "차량명"
			}
		},
		"seatCnt" : { //사용가능 좌석수
			"required" : {
				colNm : "사용가능 좌석수"
			}
		},
		"seatTcnt" : { //좌석총수
			"required" : {
				colNm : "좌석총수"
			}
		},
		"usingyn" : { //사용여부
			"required" : {
				colNm : "사용여부"
			}
		},
		
	};
	return this.gfn_validation(this, validationMappings);
};

/**
 * 저장 처리
 * @return
 */
this.fn_save = function () {
	
	if (!this.fn_saveCheck()) {
 		return;
 	}
	
	// 중복체크
// 	var isDup = this.gfn_insertRowDupCheck(this.ds_list, ["busCd"]);
// 	
// 	if(isDup){
// 		this.gfn_alertMsg("중복된코드");
// 		return;
// 	}
	
	this.gfn_saveRow(this.div_main.form.grd_list, function (oData) {
		oData.sController = ComService.$.CONTROLLER;
		oData.svcList = [
			{
				action	  : ComService.$.SAVE,
				nameSpace : "AdmGood0030Mapper",
				sqlId	  : ["insert", "update", ""],
				inds	  : "ds_list:U",
				validSql  : { //저장시 키 중복조회가 필요한 경우 (return null or return 0)
					nameSpace : "AdmGood0030Mapper",
					sqlId	  : "selectDupCheck",
					value	  : "0", //유효한 값, 해당 값 외 리턴시에는 false
					msg		  : this.gfn_getMsg("중복된 데이터가 존재합니다.")
				}
			}
		];	
		ComService.doAction(this, oData).then(function(form, e) {
			form.gfn_setStatus("save");
			form.fn_search();
		});	
	});
};

/**
* 삭제 처리
* @return
*/
this.fn_delete = function()
{
	this.gfn_deleteRow(this.div_main.form.grd_list, function (oData) {
		var oData = {
			sController : ComService.$.CONTROLLER,
			svcid : "delete",
			svcList : [
				{
					action	  : ComService.$.DELETE,
					nameSpace : "AdmGood0030Mapper",
					sqlId	  : "delete",
					inds      : "ds_list:U"
				}
			]
		};
		
		ComService.doAction(this, oData).then(function(form, e) {
			form.delMsg = 'T';
			form.fn_search();
		})
	})
};
// =================================================================================================
// ▶ 사용자 정의 Function
// =================================================================================================

this.ds_list_oncolumnchanged = function(obj:nexacro.NormalDataset,e:nexacro.DSColChangeEventInfo)
{
	var nRow = e.row
	var v_data = e.newvalue
	
	switch(e.columnid){
		
		case	"usingynV"	:      // 사용여부 체크박스
			if( v_data == "1" )
				v_data	=	"Y";
			else
				v_data	=	"N";
			
			obj.setColumn( nRow , "usingyn",	v_data );
		break;
	}	
};
