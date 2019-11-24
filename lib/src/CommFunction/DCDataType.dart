enum JsonType {
	int,
	double,
	String,
	bool,
}

class DCDataType {
	
	/// 将double保留指定的小数位(默认两位),支持double和字符串
	static double formatDecimal(origin, {int numberOfDecimal = 2}) {
		double tmp = 0.0;
		if (origin is double) {
			String str = origin.toStringAsFixed(numberOfDecimal);
			tmp = double.parse(str);
		}
		
		if (origin is String) {
			double tmpDouble = double.parse(origin);
			String str = tmpDouble.toStringAsFixed(numberOfDecimal);
			tmp = double.parse(str);
		}
		
		
		
		return tmp;
	}
	
	/// 是否为null，若是String是否是empty
	static bool isAir(Object obj) {
		if (obj == null) {
			return true;
		}
		if (obj is String) {
			final str = obj.trim();
			if (str.isEmpty){
				return true;
			}
			if (str==""){
				return true;
			}
			return false;
		
		}
		if (obj is List){
			return obj.length==0;
		}
		return false;
	}
	
	/// 将json字段转换为指定的类型
	static dynamic parseJson(dynamic field, [JsonType type = JsonType.String]) {
		if (isAir(field)) {
			switch (type) {
				case JsonType.int:
					return 0;
				case JsonType.double:
					return 0.0;
				case JsonType.String:
					return "";
				case JsonType.bool:
					return false;
					break;
			}
		}
		
		switch (type) {
			case JsonType.int:
				return field != null && !(field is int) ? int.parse(double.parse(field.toString()).toStringAsFixed(0)) : field;
			case JsonType.double:
				return field != null && !(field is double) ? double.parse(field.toString()) : field;
			case JsonType.String:
				return field?.toString();
			case JsonType.bool:
				{
					if (field is bool){
						return field;
					}
					
					if (field is int){
						return int.parse(double.parse(field.toString()).toStringAsFixed(0)) != 0;
					}
					
					if (field is String){
						return field=="True";
					}
				}
//				return field != null && !(field is bool) ? int.parse(double.parse(field.toString()).toStringAsFixed(0)) != 0 : field;
				break;
		}
	}
	
	// 将查询字符串转成Map
	static Map parseQueryString(String query) {
		var search = new RegExp('([^&=]+)=?([^&]*)');
		var result = new Map();
		
		// Get rid off the beginning ? in query strings.
		if (query.startsWith('?')) query = query.substring(1);
		
		// A custom decoder.
		decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));
		
		// Go through all the matches and build the result map.
		for (Match match in search.allMatches(query)) {
			result[decode(match.group(1))] = decode(match.group(2));
		}
		
		return result;
	}
	
	// 将int转成字符串,并根据指定长度在前面补0
	static String int2stringWithLength(int num,int customLength){
		var intStr = num.toString();
		int diff = customLength-intStr.length;
		String prestr = "";
		for (int i=0;i<diff;i++){
			prestr += "0";
		}
		return prestr+intStr;
	}
}