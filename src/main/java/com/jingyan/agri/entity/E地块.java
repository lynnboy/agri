package com.jingyan.agri.entity;

import java.util.List;

import com.jingyan.agri.common.persistence.BaseEntity;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class E地块 extends BaseEntity<E地块> {
	
	private static final long serialVersionUID = 1L;
	
	private int id;
	private String 地块编码;
	private String 地块地址;

	private String 农户姓名;
	private String 农户电话;
	private String 负责人姓名;
	private String 负责人电话;
	private String 负责人Email;
	private String 联系人姓名;
	private String 联系人电话;
	private String 联系人Email;
	
	private Double 经度;
	private Double 纬度;
	private Double 海拔;

	private Integer 种植模式分区;
	private Integer 地貌类型;
	private Integer 地形;
	private Integer 是否梯田;
	private Double 最高地下水位;
	
	private Integer 种植模式;
	private Integer 种植方式;

	private Integer 坡向;
	private Integer 坡度;
	private Integer 土壤质地;
	private Integer 土壤类型;
	private String 地方土名;
	private Integer 肥力水平;

	private Integer 有无障碍层;
	private Integer 障碍层类型;
	private Integer 障碍层深度;
	private Integer 障碍层厚度;

	private Integer 监测小区面积;
	private Integer 监测小区长;
	private Integer 监测小区宽;
	private Integer 田间渗滤池监测面积;
	private Integer 淋溶液收集桶埋深;

	public static List<String> getSortableFields() {
		return List.of(
				"id",
				"地块编码"
				);
	}
	static String[] 障碍层类型list = {
			"",
			"铁盘胶结层",
			"粘盘层",
			"潜育层",
			"盐化层",
			"碱化层",
			"夹砂层",
			"石膏盘层",
			"钙积层",
	};
	public String get障碍层text() {
		if (有无障碍层 == 2)
			return "无";
		return "" + 障碍层类型list[障碍层类型] + "(" + 障碍层深度 + "cm深," + 障碍层厚度 + "cm厚)";
	}
	public String get监测小区text() {
		return "" + 监测小区面积 + "cm<sup>2</sup>(" + 监测小区长 + "x" + 监测小区宽 + ")";
	}
	static String[] 种植模式list = {
			"",
			"【BF01】北方高原山地区-缓坡地-非梯田-顺坡-大田作物",
			"【BF02】北方高原山地区-缓坡地-非梯田-横坡-大田作物",
			"【BF03】北方高原山地区-缓坡地-梯田-大田作物",
			"【BF04】北方高原山地区-缓坡地-非梯田-园地",
			"【BF05】北方高原山地区-缓坡地-梯田-园地",
			"【BF06】北方高原山地区-陡坡地-非梯田-顺坡-大田作物",
			"【BF07】北方高原山地区-陡坡地-非梯田-横坡-大田作物",
			"【BF08】北方高原山地区-陡坡地-梯田-大田作物",
			"【BF09】北方高原山地区-陡坡地-非梯田-园地",
			"【BF10】北方高原山地区-陡坡地-梯田-园地",
			"【NF01】南方山地丘陵区-缓坡地-非梯田-顺坡-大田作物",
			"【NF02】南方山地丘陵区-缓坡地-非梯田-横坡-大田作物",
			"【NF03】南方山地丘陵区-缓坡地-梯田-大田作物",
			"【NF04】南方山地丘陵区-缓坡地-非梯田-园地",
			"【NF05】南方山地丘陵区-缓坡地-梯田-园地",
			"【NF06】南方山地丘陵区-缓坡地-梯田-水旱轮作",
			"【NF07】南方山地丘陵区-缓坡地-梯田-其它水田",
			"【NF08】南方山地丘陵区-陡坡地-非梯田-顺坡-大田作物",
			"【NF09】南方山地丘陵区-陡坡地-非梯田-横坡-大田作物",
			"【NF10】南方山地丘陵区-陡坡地-梯田-大田作物",
			"【NF11】南方山地丘陵区-陡坡地-非梯田-园地",
			"【NF12】南方山地丘陵区-陡坡地-梯田-园地",
			"【NF13】南方山地丘陵区-陡坡地-梯田-水旱轮作",
			"【NF14】南方山地丘陵区-陡坡地-梯田-其它水田",
			"【DB01】东北半湿润平原区-露地蔬菜",
			"【DB02】东北半湿润平原区-保护地",
			"【DB03】东北半湿润平原区-春玉米",
			"【DB04】东北半湿润平原区-大豆",
			"【DB05】东北半湿润平原区-其它大田作物",
			"【DB06】东北半湿润平原区-园地",
			"【DB07】东北半湿润平原区-单季稻",
			"【HH01】黄淮海半湿润平原区-露地蔬菜",
			"【HH02】黄淮海半湿润平原区-保护地",
			"【HH03】黄淮海半湿润平原区-小麦玉米轮作",
			"【HH04】黄淮海半湿润平原区-其它大田作物",
			"【HH05】黄淮海半湿润平原区-单季稻",
			"【HH06】黄淮海半湿润平原区-园地",
			"【NS01】南方湿润平原区-露地蔬菜",
			"【NS02】南方湿润平原区-保护地",
			"【NS03】南方湿润平原区-大田作物",
			"【NS04】南方湿润平原区-单季稻",
			"【NS05】南方湿润平原区-稻麦轮作",
			"【NS06】南方湿润平原区-稻油轮作",
			"【NS07】南方湿润平原区-稻菜轮作",
			"【NS08】南方湿润平原区-其它水旱轮作",
			"【NS09】南方湿润平原区-双季稻",
			"【NS10】南方湿润平原区-其它水田",
			"【NS11】南方湿润平原区-园地",
			"【XB01】西北干旱半干旱平原区-露地蔬菜",
			"【XB02】西北干旱半干旱平原区-保护地",
			"【XB03】西北干旱半干旱平原区-灌区-棉花",
			"【XB04】西北干旱半干旱平原区-灌区-其它大田作物",
			"【XB05】西北干旱半干旱平原区-单季稻",
			"【XB06】西北干旱半干旱平原区-灌区-园地",
			"【XB07】西北干旱半干旱平原区-非灌区",
	};
	public String get种植模式text() {
		return 种植模式list.length > 种植模式 ? 种植模式list[种植模式] : "";
	}
	static String[] 肥力水平list = {
			"", "高", "中", "低",
	};
	public String get肥力水平text() {
		return 肥力水平list.length > 肥力水平 ? 肥力水平list[肥力水平] : "";
	}
	static String[] 土壤质地list = {
			"",
			"砂土",
			"沙壤土",
			"轻壤",
			"中壤",
			"重壤",
			"粘土",
			"重粘土",
	};
	static String[] 土壤类型list = {
			"",
			"铁铝土-湿热铁铝土-砖红壤",
			"铁铝土-湿热铁铝土-赤红壤",
			"铁铝土-湿热铁铝土-红壤",
			"铁铝土-湿暖铁铝土-黄壤",
			"淋溶土-湿暖淋溶土-黄棕壤",
			"淋溶土-湿暖淋溶土-黄褐土",
			"淋溶土-湿暖温淋溶土-棕壤",
			"淋溶土-湿温淋溶土-暗棕壤",
			"淋溶土-湿温淋溶土-白浆土",
			"淋溶土-湿寒温淋溶土-棕色针叶林土",
			"淋溶土-湿寒温淋溶土-漂灰土",
			"淋溶土-湿寒温淋溶土-灰化土",
			"半淋溶土-半湿热半淋溶土-燥红土",
			"半淋溶土-半湿暖温半淋溶土-褐土",
			"半淋溶土-半湿温半淋溶土-灰褐土",
			"半淋溶土-半湿温半淋溶土-黑土",
			"半淋溶土-半湿温半淋溶土-灰色森林土",
			"钙层土-半湿温钙层土-黑钙土",
			"钙层土-半干温钙层土-栗钙土",
			"钙层土-半干暖温钙层土-栗褐土",
			"钙层土-半干暖温钙层土-黑垆土",
			"干旱土-干温干旱土-棕钙土",
			"干旱土-干温干旱土-灰钙土",
			"漠土-干温漠土-灰漠土",
			"漠土-干温漠土-灰棕漠土",
			"漠土-干暖温漠土-棕漠土",
			"初育土-土质初育土-黄绵土",
			"初育土-土质初育土-红粘土",
			"初育土-土质初育土-新积土",
			"初育土-土质初育土-龟裂土",
			"初育土-土质初育土-风沙土",
			"初育土-石质初育土-石灰（岩）土",
			"初育土-石质初育土-火山灰土",
			"初育土-石质初育土-紫色土",
			"初育土-石质初育土-磷质石灰土",
			"初育土-石质初育土-石质土",
			"初育土-石质初育土-粗骨土",
			"半水成土-暗半水成土-草甸土",
			"半水成土-淡半水成土-潮土",
			"半水成土-淡半水成土-砂姜黑土",
			"半水成土-淡半水成土-林灌草甸土",
			"半水成土-淡半水成土-山地草甸土",
			"水成土-矿质水成土-沼泽土",
			"水成土-有机水成土-泥炭土",
			"盐碱土-盐土-草甸盐土",
			"盐碱土-盐土-滨海盐土",
			"盐碱土-盐土-酸性硫酸盐土",
			"盐碱土-盐土-漠境盐土",
			"盐碱土-盐土-寒原盐土",
			"盐碱土-碱土-碱土",
			"人为土-人为水成土-水稻土",
			"人为土-灌耕土-灌淤土",
			"人为土-灌耕土-灌漠土",
			"高山土-湿寒高山土-草毡土（高山草甸土）",
			"高山土-湿寒高山土-黑毡土（亚高山草甸土）",
			"高山土-半湿寒高山土-寒钙土（高山草原土）",
			"高山土-半湿寒高山土-冷钙土（亚高山草原土）",
			"高山土-半湿寒高山土-冷棕钙土（山地灌丛草原土）",
			"高山土-干寒高山土-寒漠土（高山漠土）",
			"高山土-干寒高山土-冷漠土（亚高山漠土）",
			"高山土-寒冻高山土-寒冻土（高山寒漠土）",
	};
	public String get土壤text() {
		return "[" + 土壤质地list[土壤质地] + "]" + 土壤类型list[土壤类型];
	}
}
