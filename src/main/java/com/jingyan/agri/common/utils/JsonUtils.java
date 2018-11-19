package com.jingyan.agri.common.utils;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import lombok.SneakyThrows;

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
		mapper.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
		String text;
		try {
			text = mapper.writeValueAsString(obj);
		} catch (JsonProcessingException e) {
			throw new RuntimeException("failed to make json " + obj.getClass().getName() + ".");
		}
		return text;
	}
	
	@SneakyThrows
	public static List<Map<String, Object>> listOfMapFrom(String json) {
		ObjectMapper mapper = new ObjectMapper();
		return mapper.readValue(json, new TypeReference<List<Map<String, Object>>>(){});
	}
}
