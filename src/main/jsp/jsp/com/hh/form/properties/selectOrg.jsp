<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.hh.system.util.BaseSystemUtil"%>
<%=BaseSystemUtil.getBaseDoctype()%>
<html>
<head>
<title>选择机构</title>
<%=BaseSystemUtil.getBaseJs("checkform")+BaseSystemUtil.getKey("form")%>
<script type="text/javascript">
	
</script>
</head>
<body>
	<form id="form" xtype="form">
		<table xtype="form">
			<tr>
				<td xtype="label">名称：</td>
				<td><span xtype="text" config=" name : 'name',required :true"></span></td>
				<td xtype="label">中文名称：</td>
				<td><span xtype="text" config=" name : 'textfield' "></span></td>
			</tr>
			<tr>
				<td xtype="label">宽度：</td>
				<td colspan="3"><span xtype="text" config=" name : 'width' ,number : true "></span></td>
			</tr>
			<tr>
				<td xtype="label">必填：</td>
				<td><span xtype="check" config=" name : 'required'  "></span></td>
				<td xtype="label">多选：</td>
				<td><span xtype="check" config=" name : 'many'  "></span></td>
			</tr>
			<tr>
				<td xtype="label">类型：</td>
				<td colspan="3"><span xtype="radio"
					config="name: 'params_selectType' ,value : 'job',  data :[ { id : 'job' , text : '岗位' } , { id : 'dept' , text : '部门' } , { id : 'org' , text : '机构' } ,  { id : 'group' , text : '集团' }  ]"></span></td>
			</tr>
		</table>
	</form>
</body>
</html>