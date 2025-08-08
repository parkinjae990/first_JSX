<?xml version="1.0" encoding="utf-8"?>
<FDL version="2.1">
  <Form id="ADM_CLUB_0030_T02" width="1048" height="675" onload="form_onload" titletext="동아리비품관리_동아리비품기간별조회" onclose="form_onclose">
    <Layouts>
      <Layout width="1048" height="675">
        <Static id="Static19" taborder="0" text="12" cssclass="tipGuide" visible="false" left="33" top="-195" right="496" height="12"/>
        <Static id="Static20" taborder="1" text="5" cssclass="tipGuide" visible="false" left="33" top="-165" right="496" height="5"/>
        <Div id="div_search" taborder="3" left="0" top="8" right="0" height="39" cssclass="div_WFSA_bg" minwidth="1048" maxwidth="">
          <Layouts>
            <Layout width="1048" height="39">
              <Static id="sta_hakgwa" taborder="0" text="매입일자" left="20" top="8" width="55" height="21" cssclass="sta_WFSA_label"/>
              <Calendar id="cal_startDt" taborder="3" left="sta_hakgwa:10" top="8" width="120" height="21" dateformat="yyyy-MM-dd" onchanged="div_search_cal_startDt_onchanged"/>
              <Static id="Static00" taborder="1" text="부터" left="cal_startDt:5" top="8" width="29" height="21" cssclass="sta_WFSA_label"/>
              <Calendar id="cal_endDt" taborder="2" left="Static00:5" top="8" width="120" height="21" dateformat="yyyy-MM-dd"/>
              <Static id="Static00_00" taborder="4" text="까지" left="cal_endDt:5" top="8" width="29" height="21" cssclass="sta_WFSA_label"/>
            </Layout>
          </Layouts>
        </Div>
        <Div id="div_resize20_00" taborder="2" left="0" top="div_search:8" maxwidth="" maxheight="" minheight="300" bottom="0" right="0">
          <Layouts>
            <Layout>
              <Static id="sta_subTtl" taborder="1" text="동아리비품조회" left="0" height="23" top="0" cssclass="sta_WF_subTitle" width="121"/>
              <Grid id="grd_list" taborder="0" left="0" top="sta_subTtl:8" right="0" autofittype="col" autosizebandtype="body" autosizingtype="none" binddataset="ds_list" maxheight="" selecttype="row" minheight="300" bottom="0" autoenter="select">
                <Formats>
                  <Format id="default">
                    <Columns>
                      <Column size="40" band="left"/>
                      <Column size="100"/>
                      <Column size="60"/>
                      <Column size="110"/>
                      <Column size="120"/>
                      <Column size="100"/>
                      <Column size="60"/>
                      <Column size="60"/>
                      <Column size="100"/>
                      <Column size="200"/>
                    </Columns>
                    <Rows>
                      <Row size="28" band="head"/>
                      <Row size="28"/>
                    </Rows>
                    <Band id="head">
                      <Cell text="No"/>
                      <Cell col="1" text="동아리명"/>
                      <Cell col="2" text="호실"/>
                      <Cell col="3" text="매입일자"/>
                      <Cell col="4" text="품명"/>
                      <Cell col="5" text="단가"/>
                      <Cell col="6" text="수량"/>
                      <Cell col="7" text="단위"/>
                      <Cell col="8" text="금액"/>
                      <Cell col="9" text="비고"/>
                    </Band>
                    <Band id="body">
                      <Cell expr="currow + 1"/>
                      <Cell col="1" text="bind:clubnm"/>
                      <Cell col="2" text="bind:clubsil"/>
                      <Cell col="3" displaytype="date" text="bind:maeipdate" calendardateformat="yyyy-MM-dd" calendardisplaynulltype="none"/>
                      <Cell col="4" text="bind:goods"/>
                      <Cell col="5" text="bind:danga" displaytype="number" textAlign="right"/>
                      <Cell col="6" text="bind:qty" displaytype="number"/>
                      <Cell col="7" text="bind:danwi"/>
                      <Cell col="8" text="bind:amt" displaytype="number" textAlign="right"/>
                      <Cell col="9" text="bind:bigo" textAlign="left"/>
                    </Band>
                  </Format>
                </Formats>
              </Grid>
              <Static id="sta_Cnt" taborder="2" text="총 0건" left="sta_subTtl:10" top="0" width="80" height="23"/>
            </Layout>
          </Layouts>
        </Div>
      </Layout>
    </Layouts>
    <Objects>
      <Dataset id="ds_in">
        <ColumnInfo>
          <Column id="startDt" type="STRING" size="256"/>
          <Column id="endDt" type="STRING" size="256"/>
        </ColumnInfo>
        <Rows>
          <Row/>
        </Rows>
      </Dataset>
      <Dataset id="ds_list">
        <ColumnInfo>
          <Column id="rowCheck" type="string" size="32"/>
          <Column id="rowListNum" type="bigdecimal" size="8"/>
          <Column id="maeipdate" type="string" size="32"/>
          <Column id="goods" type="string" size="32"/>
          <Column id="danga" type="float" size="4"/>
          <Column id="qty" type="float" size="4"/>
          <Column id="danwi" type="string" size="32"/>
          <Column id="amt" type="float" size="4"/>
          <Column id="bigo" type="string" size="32"/>
          <Column id="clubnm" type="string" size="32"/>
          <Column id="clubsil" type="string" size="32"/>
        </ColumnInfo>
      </Dataset>
    </Objects>
    <Bind>
      <BindItem id="item0" compid="div_search.form.Static00" propid="value" datasetid="ds_in" columnid="startDt"/>
      <BindItem id="item1" compid="div_search.form.Static00_00" propid="value" datasetid="ds_in" columnid="startDt"/>
      <BindItem id="item2" compid="div_search.form.cal_endDt" propid="value" datasetid="ds_in" columnid="endDt"/>
      <BindItem id="item3" compid="div_search.form.cal_startDt" propid="value" datasetid="ds_in" columnid="startDt"/>
    </Bind>
  </Form>
</FDL>
