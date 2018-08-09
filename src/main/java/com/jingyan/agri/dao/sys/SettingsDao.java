package com.jingyan.agri.dao.sys;

import java.util.Collection;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jingyan.agri.common.persistence.annotation.Dao;
import com.jingyan.agri.entity.sys.SettingValue;

@Dao
@Mapper
public interface SettingsDao {
	
	static final String KEY_DATA_DIR = "数据存储目录";
	static final String KEY_EXPORT_DIR = "数据导出目录";
	static final String KEY_IMPORT_DIR = "数据导入暂存目录";
	static final String KEY_EXPORT_NAME_TMPL = "导出文件名格式";

	List<SettingValue> allSettings();
	void addSetting(SettingValue setting);
	void updateSettings(@Param("settings") Collection<SettingValue> settings);
	void removeSetting(@Param("id") Integer id);
	
	SettingValue get(@Param("name") String name);
}
