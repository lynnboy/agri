package com.jingyan.agri.dao;

import java.util.Collection;
import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.common.persistence.annotation.Dao;
import com.jingyan.agri.entity.License;

@Dao("licenseDao")
@Mapper
public interface LicenseDao {
	int count();
	int queryCount(@Param("search") License search);
	List<License> query(@Param("search") License search,
			@Param("view") ResultView view);
	List<License> getByKeys(@Param("keys") Collection<String> keys);
	void addByKeys(@Param("keys") Collection<String> keys,
			@Param("createDate") Date createDate);
	void update(@Param("liclist") Collection<License> liclist);
}
