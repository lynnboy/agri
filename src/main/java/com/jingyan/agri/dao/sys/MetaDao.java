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
			@Param("dataKey") String dataKey,
			@Param("dataTable") String dataTable,
			@Param("statusTable") String statusTable,
			@Param("taskTable") String taskTable);
	List<Map<String, Object>>
		queryWithStatus(@Param("search") Search search,
				@Param("taskIds") List<Integer> taskIds,
				@Param("view") ResultView view,
				@Param("dataKey") String dataKey,
				@Param("dataTable") String dataTable,
				@Param("statusTable") String statusTable,
				@Param("taskTable") String taskTable);

	List<Map<String, Object>>
		queryGroupCount(@Param("keys") List<String> keys,
				@Param("filterKey") String filterKey,
				@Param("keyName") String keyName,
			@Param("tableName") String tableName);

	List<Map<String, Object>>
		queryGroupSum(@Param("keys") List<String> keys,
				@Param("filterKey") String filterKey,
				@Param("keyName") String keyName,
				@Param("colName") String colName,
			@Param("tableName") String tableName);

	List<String> collectOptList(@Param("tableName") String tableName, @Param("colName") String colName);

	List<Map<String, Object>>
		get(@Param("key") String key,
			@Param("id") String id,
			@Param("tableName") String tableName);

	List<Map<String, Object>>
		getAll(@Param("tableName") String tableName);

	List<Map<String, Object>>
		get2(@Param("key1") String key1,
			@Param("id1") String id1,
			@Param("key2") String key2,
			@Param("id2") String id2,
			@Param("tableName") String tableName);

	List<Map<String, Object>>
		get3(@Param("key1") String key1,
			@Param("id1") String id1,
			@Param("key2") String key2,
			@Param("id2") String id2,
			@Param("key3") String key3,
			@Param("id3") String id3,
			@Param("tableName") String tableName);

	List<Map<String, Object>>
		get4(@Param("key1") String key1,
			@Param("id1") String id1,
			@Param("key2") String key2,
			@Param("id2") String id2,
			@Param("key3") String key3,
			@Param("id3") String id3,
			@Param("key4") String key4,
			@Param("id4") String id4,
			@Param("tableName") String tableName);

	void add(@Param("data") Map<String, Object> data,
			@Param("tableName") String tableName);

	void update(@Param("key") String key,
			@Param("id") String id,
			@Param("data") Map<String, Object> data,
			@Param("tableName") String tableName);

	void update2(@Param("key1") String key1,
			@Param("id1") String id1,
			@Param("key2") String key2,
			@Param("id2") String id2,
			@Param("data") Map<String, Object> data,
			@Param("tableName") String tableName);

	void update3(@Param("key1") String key1,
			@Param("id1") String id1,
			@Param("key2") String key2,
			@Param("id2") String id2,
			@Param("key3") String key3,
			@Param("id3") String id3,
			@Param("data") Map<String, Object> data,
			@Param("tableName") String tableName);

	void remove(@Param("key") String key,
			@Param("id") String id,
			@Param("tableName") String tableName);

	void remove2(@Param("key1") String key1,
			@Param("id1") String id1,
			@Param("key2") String key2,
			@Param("id2") String id2,
			@Param("tableName") String tableName);

	void remove3(@Param("key1") String key1,
			@Param("id1") String id1,
			@Param("key2") String key2,
			@Param("id2") String id2,
			@Param("key3") String key3,
			@Param("id3") String id3,
			@Param("tableName") String tableName);
}
