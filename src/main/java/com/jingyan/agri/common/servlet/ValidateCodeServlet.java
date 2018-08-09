package com.jingyan.agri.common.servlet;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Random;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;

import com.jingyan.agri.common.manager.Constant;

/**
 * 生成随机验证码
 * @author Guoyanbin
 * @version V1.0
 */
@SuppressWarnings("serial")
public class ValidateCodeServlet extends HttpServlet {
	
	private int imageWith = 70; // 默认生成验证码图片的宽度
	private int imageHeight = 26; // 默认生成验证码图片的高度
	
	/**
	 * destroy
	 */
	public void destroy() {
		super.destroy(); 
	}
	
	/**
	 * 检查输入验证码是否正确 
	 * @param request
	 * @param validateCode
	 * @return 正确返回true 输入不正返回false
	 */
	private boolean validate(HttpServletRequest request, String validateCode) {
		String code = (String)request.getSession().getAttribute(Constant.VALIDATE_CODE);
		return validateCode.toUpperCase().equals(code); 
	}

	/**
	 * 处理用户get方式请求
	 * @param request http请求对象
	 * @param response http响应对象
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response) {
		try {
			// 用户输入验证码
			String validateCode = request.getParameter(Constant.VALIDATE_CODE);
			
			// AJAX验证，成功返回true
			if (StringUtils.isNotBlank(validateCode)) {
				response.getOutputStream().print(validate(request, validateCode)?"true" : "false");
			} else {
				this.doPost(request, response);
			}
		} catch (Exception e) {
			// nothing
		}
	}

	/**
	 * 处理用户POST方式请求
	 * @param request http请求对象
	 * @param response http响应对象
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response) {
		try {
			createImage(request,response);
		} catch (Exception e) {
			// nothing
		}
	}
	
	/**
	 * 创建一张图片
	 * @param request http请求对象
	 * @param response http响应对象
	 * @throws IOException
	 */
	private void createImage(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		OutputStream out = null;
		try {
			response.setHeader("Pragma", "no-cache");
			response.setHeader("Cache-Control", "no-cache");
			response.setDateHeader("Expires", 0);
			response.setContentType("image/jpeg");
			
			/*
			 * 得到参数高，宽，都为数字时，则使用设置高宽，否则使用默认值
			 */
			String width = request.getParameter("width");
			String height = request.getParameter("height");
			
			if (StringUtils.isNumeric(width) && StringUtils.isNumeric(height)) {
				imageWith = NumberUtils.toInt(width);
				imageHeight = NumberUtils.toInt(height);
			}
			
			BufferedImage image = new BufferedImage(imageWith, 
					imageHeight, BufferedImage.TYPE_INT_RGB);
			Graphics g = image.getGraphics();
			
			/*
			 * 生成背景
			 */
			createBackground(g);
			
			/*
			 * 生成字符
			 */
			String s = createCharacter(g);
			request.getSession().setAttribute(Constant.VALIDATE_CODE, s);
			
			g.dispose();
			out = response.getOutputStream();
			ImageIO.write(image, "JPEG", out);
		} finally {
			if (out != null) {
				out.close();
			}
		}
	}
	
	/**
	 * 获取随机生成验证码图片的颜色色
	 * @param fc 随机值
	 * @param bc 随机值
	 * @return 颜色对象
	 */
	private Color getRandColor(int fc,int bc) { 
		int f = fc;
		int b = bc;
		Random random = new Random();

		if (f > 255) {
        	f = 255; 
        }

        if (b > 255) {
        	b = 255; 
        }

        return new Color(f + random.nextInt(b - f),
        		f + random.nextInt(b - f), f + random.nextInt(b - f)); 
	}
	
	/**
	 * 填充背景
	 * @param g
	 */
	private void createBackground(Graphics g) {
		// 填充背景
		g.setColor(getRandColor(220,250)); 
		g.fillRect(0, 0, imageWith, imageHeight);
		// 加入干扰线条
		for (int i = 0; i < 8; i++) {
			g.setColor(getRandColor(40,150));
			Random random = new Random();
			int x = random.nextInt(imageWith);
			int y = random.nextInt(imageHeight);
			int x1 = random.nextInt(imageWith);
			int y1 = random.nextInt(imageHeight);
			g.drawLine(x, y, x1, y1);
		}
	}

	/**
	 * 产生四位随机字符串
	 * @param g
	 */
	private String createCharacter(Graphics g) {
		char[] codeSeq = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J',
				'K', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
				'X', 'Y', 'Z', '2', '3', '4', '5', '6', '7', '8', '9'};
		String[] fontTypes = {"Arial","Arial Black","AvantGarde Bk BT","Calibri"}; 
		Random random = new Random();
		StringBuilder s = new StringBuilder();
		for (int i = 0; i < 4; i++) {
			String r = String.valueOf(codeSeq[random.nextInt(codeSeq.length)]);
			g.setColor(new Color(50 + random.nextInt(100),
					50 + random.nextInt(100), 50 + random.nextInt(100)));
			g.setFont(new Font(fontTypes[random.nextInt(fontTypes.length)],Font.BOLD,26)); 
			g.drawString(r, 15 * i + 5, 19 + random.nextInt(8));
			s.append(r);
		}
		return s.toString();
	}
	
}
