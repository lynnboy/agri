package com.jingyan.agri.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.common.persistence.annotation.Dao;
import com.jingyan.agri.entity.E地块;

@Dao("e地块Dao")
@Mapper
public interface E地块Dao {
	
	E地块 getById(@Param("id") int id);
	E地块 getBy地块编码(@Param("地块编码") String 地块编码);

	int count();
	int queryCount(@Param("search") E地块 search);
	List<E地块> query(@Param("search") E地块 search,
			@Param("view") ResultView view);
	
	void add(E地块 地块);
	void update(E地块 地块);
	void deleteById(@Param("id") int id);
}
