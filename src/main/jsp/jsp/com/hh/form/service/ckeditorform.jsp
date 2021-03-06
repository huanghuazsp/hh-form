<%@page import="com.hh.system.util.BaseSystemUtil"%>
<%@page import="com.hh.form.bean.SysFormTree"%>
<%@page import="com.hh.form.bean.FormInfo"%>
<%@page import="com.hh.form.service.impl.FormInfoService"%>
<%@page import="com.hh.form.service.impl.SysFormTreeService"%>
<%@page import="com.hh.system.service.impl.BeanFactoryHelper"%>
<%@page import="com.hh.system.util.Convert"%>
<%@page import="com.hh.system.util.Check"%>
<%@page import="com.hh.system.util.Json"%>
<%@page import="com.hh.system.util.date.DateFormat"%>
<%@page import="com.hh.usersystem.IUser"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.hh.system.util.SystemUtil"%>
<%=SystemUtil.getBaseDoctype()%>
<html>
<head>
<title>表单</title>
<%=SystemUtil.getBaseJs("checkform", "date", "ueditor", "fileUpload","workflow")%>
<%
	String id = Convert.toString(request.getParameter("hrefckeditor"));
	String databaseType = Convert.toString(request.getParameter("databaseType"));
	String jsonConfig = "[]";
	String tableName = "";
	String html = "";
	String eventList = "[]";
	if("relation".equals(databaseType)){
		SysFormTreeService sysFormTreeService = BeanFactoryHelper
		.getBeanFactory().getBean(SysFormTreeService.class);
		SysFormTree sysFormTree = sysFormTreeService.findObjectById(id);
		jsonConfig = sysFormTree.getJsonConfig();
		tableName = sysFormTree.getTableName();
		html = sysFormTree.getHtml();
		eventList = sysFormTree.getEventList();
	}else{
		FormInfoService formInfoService = BeanFactoryHelper
		.getBeanFactory().getBean(FormInfoService.class);
		FormInfo formInfo = formInfoService.findObjectById(id);
		if(formInfo!=null){
			jsonConfig = formInfo.getJsonConfig();
			tableName = formInfo.getTableName();
			html = formInfo.getHtml();
			eventList = formInfo.getEventList();
		}else{
			SysFormTreeService sysFormTreeService = BeanFactoryHelper
			.getBeanFactory().getBean(SysFormTreeService.class);
			SysFormTree sysFormTree = sysFormTreeService.findObjectById(id);
			jsonConfig = sysFormTree.getJsonConfig();
			tableName = sysFormTree.getTableName();
			html = sysFormTree.getHtml();
			eventList = sysFormTree.getEventList();
		}
	}
	
	html = BaseSystemUtil.generatedValue(html);
	
	String type = Convert.toString(request.getParameter("type"));
%>
<script type="text/javascript">
<%

List<Map<String,Object>> mapList = Json.toMapList(eventList);
StringBuffer eventStr = new StringBuffer();
for(Map<String,Object> map : mapList){
	String eventType = Convert.toString(map.get("eventType"));
	String eventid = Convert.toString(map.get("id"));
	String widget = Convert.toString(map.get("widget"));
	String formula = Convert.toString(map.get("formula"));
	
	eventStr.append("function "+eventid+"(params){ \n");
	if("setValue".equals(eventType)){
		eventStr.append(" var data = $('#form').getValue(); \n");
		
		eventStr.append(" $('#span_"+widget+"').setValue("+formula+"); \n");
	}else if("loadSubComboData".equals(eventType)){
		eventStr.append(" $('#span_"+widget+"').setConfig({params:{node:params}}); \n");
		eventStr.append(" $('#span_"+widget+"').render(); \n");
	}
	
	eventStr.append("}\n");
}
%>
<%=eventStr.toString()%>
</script>
<script type="text/javascript">
	var params = $.hh.getIframeParams();
	var dataManager = WF.getDataManager(params);
	var actionType = '<%=Convert.toString(request.getParameter("actionType"))%>';
	var tableName = '<%=tableName%>';
	var objectId= '<%=Convert.toString(request.getParameter("objectId"))%>';
	function save(submit) {
		if ($("#form").validationEngine('validate')) {
			var object = $("#form").getValue();

			var object2 = {};
			for ( var p in object) {
				object2['object.' + p] = object[p];
			}
			object2['object.tableName'] = tableName;
			object2['object.id'] = objectId;
			if (submit == null) {
				Request.request('form-MongoFormOper-save', {
					async : false,
					data : object2
				}, function(result) {
					if (result.success!=false) {
						if (params.callback) {
							params.callback();
							Dialog.close();
						}
						return object;
					} else {
						return null;
					}
				});
			}
			object.tableName = tableName;
			object.id = objectId || uuid ;
			return object;
		} else {
			Dialog.errormsg("验证失败！！");
		}
	}
	
	function init() {
		if (objectId) {
			Request.request('form-MongoFormOper-findObjectById', {
				defaultMsg:false,
				data : {
					id : objectId,
					tableName : tableName
				}
			}, function(result) {
				if (actionType == 'select') {
					$('#form').setValue(result, {view:true});
				} else {
					$('#form').setValue(result);
				}
				WF.dataManagerWidgets(dataManager);
			});
		}else{
			$('#form').setValue({});
			WF.dataManagerWidgets(dataManager);
		}
	}
</script>
<script type="text/javascript">
$(function(){
	var width = $('#form').find('table').eq(0).css('width');
	$('#form').css('width',width);
});
</script>
</head>
<body>
	<%
		if (!"workflow".equals(type)) {
	%>
	<div xtype="hh_content">
		<%
			}
		%>
				<form id="form" xtype="form" style="padding-top: 20px;margin: 0px auto;	margin-top: 10px;margin-bottom: 10px;">
					<%=Convert.toString(html)%>
				</form>
		<%
			if (!"workflow".equals(type)) {
		%>
	</div>
	<div xtype="toolbar" id="toolbar">
		<span xtype="button" config="text:'保存' , onClick : save ,itype:'save'"></span> <span
			xtype="button" config="text:'取消' , onClick : Dialog.close,itype:'close' "></span>
	</div>
	<%
		}
	%>
</body>
</html>