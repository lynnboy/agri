package com.jingyan.agri.dao.sys;

import java.util.Collection;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jingyan.agri.common.persistence.ResultView;
import com.jingyan.agri.common.persistence.annotation.Dao;
import com.jingyan.agri.entity.sys.Dealer;
import com.jingyan.agri.entity.sys.Group;

@Dao("dealerDao")
@Mapper
public interface DealerDao {
	
	public Dealer login(@Param("login") String login,
			@Param("hashedPassword") String hashedPassword);
	
	Dealer getByLogin(@Param("login") String login);
	Dealer getById(@Param("id") int id);

	int count();
	int queryCount(@Param("search") Dealer search);
	List<Dealer> query(@Param("search") Dealer search,
			@Param("view") ResultView view);
	
	void add(Dealer dealer);
	void update(Dealer dealer);
	void deleteById(@Param("id") int id);
	
	int queryGroupCount(@Param("search") Group search);
	List<Group> queryGroup(@Param("search") Group search,
			@Param("view") ResultView view);
	Group getGroup(@Param("id") int id);
	void addGroup(Group group);
	void updateGroup(Group group);
	void deleteGroup(@Param("id") int id); 
	List<Group> getGroupsOfDealer(@Param("dealerId") int dealerId);
	List<Group> getProjectGroupsOfDealer(@Param("dealerId") int dealerId,
			@Param("projId") int projId, @Param("taskId") int taskId);
	
	List<Dealer> getGroupMembers(@Param("id") int id);
	boolean isMemberInGroup(@Param("id") int id, @Param("dealerId") int dealerId);
	void clearGroupMembers(@Param("id") int id);
	void deleteMemberFromGroup(@Param("id") int id, @Param("dealerId") int dealerId);
	void addGroupMembers(@Param("id") int id, @Param("list") Collection<Integer> list);
}
