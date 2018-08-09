package com.jingyan.agri.dao.sys;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.common.persistence.annotation.Dao;
import com.jingyan.agri.entity.sys.Manager;
import com.jingyan.agri.entity.sys.Organ;
import com.jingyan.agri.entity.sys.Project;
import com.jingyan.agri.entity.sys.ProjectTemplate;

@Dao
@Mapper
public interface ManagerDao {
	
	/**
	 * 登陆 
	 * @param manager Manager
	 * @return 登陆者信息
	 */
	Manager login(@Param("login") String login, @Param("password") String password);
	void add(Manager manager);
	void update(Manager manager);
	void deleteById(@Param("id") int id);
	
	ProjectTemplate getTemplate(@Param("id") Integer id);

	List<ProjectTemplate> allTemplates();
	
	List<Project> allProjects();
	
	List<Project> getProjectOfTemplate(@Param("tempId") Integer tempId);
	
	List<Project> getProjectForUser(@Param("dealerId") Integer dealerId);
	
	Project getProject(@Param("id") Integer id);
	
	void addProject(Project proj);

	void updateProject(Project proj);
	
	void deprecateProject(@Param("id") Integer id);
	
	List<Organ> allOrgan(@Param("normalOnly") boolean normalOnly);
	int queryOrganCount(@Param("search") Organ search);
	List<Organ> queryOrgan(@Param("search") Organ search,
			@Param("view") ResultView view);
	Organ getOrgan(@Param("id") Integer id);
	void addOrgan(Organ organ);
	void updateOrgan(Organ organ);
}
