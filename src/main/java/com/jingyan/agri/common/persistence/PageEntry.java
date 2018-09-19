package com.jingyan.agri.common.persistence;

import lombok.Getter;
import lombok.Setter;

public class PageEntry {
	@Getter @Setter
	Boolean active;
	
	@Getter @Setter
	String pathUrl;
	
	@Getter @Setter
	String icon;
	
	@Getter @Setter
	String title;
	
	public PageEntry(boolean active, String url, String title) {
		this(active, url, title, null);
	}
	public PageEntry(boolean active, String url, String title, String icon) {
		this.active = active;
		this.pathUrl = url;
		this.icon = icon;
		this.title = title;
	}
}
