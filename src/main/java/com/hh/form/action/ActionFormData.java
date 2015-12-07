package com.hh.form.action;

import org.springframework.beans.factory.annotation.Autowired;

import com.hh.form.bean.FormData;
import com.hh.form.service.impl.FormDataService;
import com.hh.system.service.impl.BaseMongoService;
import com.hh.system.util.Convert;
import com.hh.system.util.base.BaseServiceAction;
import com.hh.system.util.dto.ParamFactory;

@SuppressWarnings("serial")
public class ActionFormData extends BaseServiceAction<FormData> {

	public BaseMongoService<FormData> getService() {
		return formDataService;
	}

	@Autowired
	private FormDataService formDataService;

	public Object queryTreeList() {
		return formDataService.queryTreeList(object.getNode(),
				Convert.toBoolean(request.getParameter("isNoLeaf")),
				ParamFactory.getParam()
						.is("dataTypeId", object.getDataTypeId()));
	}

}
