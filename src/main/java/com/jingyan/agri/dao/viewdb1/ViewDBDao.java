package com.jingyan.agri.dao.viewdb1;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jingyan.agri.common.persistence.Search;
import com.jingyan.agri.common.persistence.annotation.Dao;
import com.jingyan.agri.entity.viewdb1.Diagram;
import com.jingyan.agri.entity.viewdb1.Entry;

@Dao
@Mapper
public interface ViewDBDao {

	List<Entry> getAllEntries(@Param("tableName") String tableName);
	Entry getEntry(@Param("keyOrId") String keyOrId,
			@Param("tableName") String tableName);
	List<Diagram> getDiagrams(@Param("search") Search search,
			@Param("tableName") String tableName);
}
