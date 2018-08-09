package com.jingyan.agri.common.persistence;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import lombok.Getter;
import lombok.Setter;

public class ResultView {
	static final int DEFAULT_PAGE_SIZE = 20;
	static final int SPAN = 4;
	static final int ELLIPSIS = 0;
	static final String PARAM_VIEW_BEGIN = "view_begin";
	static final String PARAM_VIEW_COUNT = "view_count";
	static final String PARAM_VIEW_SORT = "view_sort";

	@Getter @Setter
	private int pageNo = 1;
	@Getter @Setter
	private int pageSize = DEFAULT_PAGE_SIZE;
	@Getter @Setter
	private int totalCount;
	@Getter @Setter
	private int queryCount; 
	@Getter @Setter
	private int pageCount;
	@Getter @Setter
	private int firstNo;
	@Getter @Setter
	private int lastNo;
	@Getter @Setter
	private String orderBy = "";
	@Getter @Setter
	private String sqlOrderBy = "";
	@Getter @Setter
	private int offset;
	
	@Getter @Setter
	private int[] pageSizes = { 10, 25, 50, 100 };
	@Getter @Setter
	private List<Integer> pages = new ArrayList<>();
	@Getter @Setter
	private Map<String,String> sortActions = new HashMap<>();
	@Getter @Setter
	private Map<String,String> sortStates = new HashMap<>();
	
	public void normalize(final List<String> sortableFields)
	{
		pageSize = Math.max(1, pageSize);
		pageCount = queryCount / pageSize;
		if (queryCount % pageSize != 0)
			pageCount ++;
		pageCount = Math.max(1, pageCount);
		pageNo = Math.max(1, pageNo);
		pageNo = Math.min(pageNo, pageCount);
		firstNo = Math.min(queryCount, pageSize * (pageNo-1) + 1);
		lastNo = Math.min(queryCount, pageSize * pageNo);
		offset = Math.max(0, firstNo-1);

		pages.clear();
		final int spanL = Math.max(1, pageNo - SPAN);
		final int spanR = Math.min(pageNo + SPAN, pageCount);
		if (spanL > 1)
			pages.add(1);
		if (spanL > 2)
			pages.add(ELLIPSIS);
		for (int i = spanL; i <= spanR; i++)
			pages.add(i);
		if (spanR < pageCount - 2)
			pages.add(ELLIPSIS);
		if (spanR < pageCount - 1)
			pages.add(pageCount);
		
		sortActions.clear();
		sqlOrderBy = "";
		for (int i = 0; i < sortableFields.size(); i++)
		{
			final String asc = "" + i + "ASC";
			final String desc = "" + i + "DESC";
			final String field = sortableFields.get(i);

			String nextSort;
			String sortState = "";
			if (orderBy.equalsIgnoreCase(asc)) {
				sqlOrderBy = "`" + field + "` ASC";
				nextSort = desc;
				sortState = "ASC";
			}
			else if (orderBy.equalsIgnoreCase(desc)) {
				sqlOrderBy = "`" + field + "` DESC";
				nextSort = asc;
				sortState = "DESC";
			}
			else {
				nextSort = asc;
			}
			sortActions.put(field, nextSort);
			sortStates.put(field, sortState);
		}
		if (sqlOrderBy.isEmpty() && !sortableFields.isEmpty()) {
			orderBy = "0A";
			sqlOrderBy = sortableFields.get(0) + " ASC";
		}
	}

	public void putQueryParameters(final Map<String, Object> params)
	{
		params.putIfAbsent(PARAM_VIEW_BEGIN, (pageNo-1)*pageSize);
		params.putIfAbsent(PARAM_VIEW_COUNT, pageSize);
		params.putIfAbsent(PARAM_VIEW_SORT, orderBy);
	}

}
