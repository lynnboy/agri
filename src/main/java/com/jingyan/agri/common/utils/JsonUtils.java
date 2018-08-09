package com.jingyan.agri.common.utils;

import java.io.File;
import java.io.InputStream;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class JsonUtils {

	public static <T> T deserialize(String text, Class<T> clazz)
	{
		try {
			ObjectMapper mapper = new ObjectMapper();
			T obj = (T)mapper.readValue(text, clazz);
			return obj;
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("Invalid value " + clazz.getName() + ".");
		}
	}
	
	public static <T> T deserialize(File file, Class<T> clazz)
	{
		try {
			ObjectMapper mapper = new ObjectMapper();
			T obj = (T)mapper.readValue(file, clazz);
			return obj;
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("Invalid value " + clazz.getName() + ".");
		}
	}
	
	public static <T> T deserialize(InputStream stream, Class<T> clazz)
	{
		try {
			ObjectMapper mapper = new ObjectMapper();
			T obj = (T)mapper.readValue(stream, clazz);
			return obj;
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("Invalid value " + clazz.getName() + ".");
		}
	}
	
	public static <T> String serialize(T obj)
	{
		ObjectMapper mapper = new ObjectMapper();
		String text;
		try {
			text = mapper.writeValueAsString(obj);
		} catch (JsonProcessingException e) {
			throw new RuntimeException("failed to make json " + obj.getClass().getName() + ".");
		}
		return text;
	}
}
