package com.jingyan.agri.common.web;

import com.jingyan.agri.entity.sys.Dealer;
import com.jingyan.agri.entity.sys.Project;
import com.jingyan.agri.entity.sys.ProjectTemplate;

public interface ProjectTemplateController {

	void initProject(ProjectTemplate temp, Project proj) throws Exception;
	void handleUserDelete(ProjectTemplate temp, Project proj,
			Dealer user) throws Exception;
	void handleUserMerge(ProjectTemplate temp, Project proj,
			Dealer user, Dealer target) throws Exception;
}
