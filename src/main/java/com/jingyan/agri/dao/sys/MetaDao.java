package com.jingyan.agri.dao.sys;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.common.persistence.Search;
import com.jingyan.agri.common.persistence.annotation.Dao;
import com.jingyan.agri.entity.sys.Meta;

//@Dao
@Mapper
public interface MetaDao {

	boolean detectSQLLiteralIsEscaped();

	List<Meta> getTemplateTables(@Param("tempId") int tempId);
	Meta getTemplateKeyedTable(@Param("tempId") int tempId, @Param("key") String key);
	List<Meta> getProjTables(@Param("projId") int projId);
	Meta getProjectKeyedTable(@Param("projId") int projId, @Param("key") String key);

	void addMeta(Meta meta);
	
	void cloneTable(@Param("srcTable") String srcTable,
			@Param("newTable") String newTable);
	void createTable(Meta meta);
	
	int queryCount(@Param("search") Search search,
			@Param("tableName") String tableName);
	List<Map<String, Object>>
		query(@Param("search") Search search,
				@Param("view") ResultView view,
				@Param("tableName") String tableName);

	int queryWithStatusCount(@Param("search") Search search,
			@Param("taskIds") List<Integer> taskIds,
			@Param("dataTable") String dataTable,
			@Param("statusTable") String statusTable,
			@Param("taskTable") String taskTable);
	List<Map<String, Object>>
		queryWithStatus(@Param("search") Search search,
				@Param("taskIds") List<Integer> taskIds,
				@Param("view") ResultView view,
				@Param("dataTable") String dataTable,
				@Param("statusTable") String statusTable,
				@Param("taskTable") String taskTable);

	List<String> collectOptList(@Param("tableName") String tableName, @Param("colName") String colName);
}
