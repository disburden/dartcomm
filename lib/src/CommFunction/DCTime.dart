
//import 'package:meta/meta.dart';
import 'DCDataType.dart';

/// 时间类型
enum TimeStyle {
	/// 13:31 08/09
	HOUR_mh_MI_kg_MO_xg_DAY,

	/// 2018-08-09 13:31
	YEAR_hg_MO_hg_DAY_kg_HOUR_mh_MI,
	
	/// 2018-08-09 13:31:31
	YEAR_hg_MO_hg_DAY_kg_HOUR_mh_MI_mh_SEC,

	/// 2018.08
	YEAR_dot_MO,
	
	/// 2018.08.08
	YEAR_dot_MO_dot_DAY,

	/// 20180809
	YEAR_MO_DAY,
	
	/// 20180809143133
	YEAR_MO_DAY_HOUR_MI_SEC,

	/// 13:31:33
	HOUR_mh_MI_mh_SE,

	/// 2018-08-09
	YEAR_hg_MO_hg_DAY,

	/// 2018/08/09
	YEAR_xg_MO_xg_DAY,

	/// 计算到现在的时间差(几分钟前,几天前,几个月前....)
	DIFF,

	/// 获取到现在的时间差的毫秒值
	DIFF_MILLISECOND,
	
	/// 2018年08月08日
	YEAR_nian_MO_yue_DAY_ri,
	
	/// 08月08日
	MO_yue_DAY_ri,
}

/// 时间工具
class DCTime {
	/// 格式化时间类型
	static String formatDateTime({String dateTimeString, TimeStyle style}) {
		DateTime dt = DateTime.parse(dateTimeString);
		int i_hour = dt.hour;
		int i_min = dt.minute;
		int i_year = dt.year;
		int i_moo = dt.month;
		int i_day = dt.day;
		int i_sec = dt.second;

		String hour = DCDataType.int2stringWithLength(i_hour, 2);
		String min = DCDataType.int2stringWithLength(i_min, 2);
		String year = i_year.toString();
		String moo = DCDataType.int2stringWithLength(i_moo, 2);
		String day = DCDataType.int2stringWithLength(i_day, 2);
		String sec = DCDataType.int2stringWithLength(i_sec, 2);

		switch (style) {
			case TimeStyle.HOUR_mh_MI_kg_MO_xg_DAY:
				return "$hour:$min $moo/$day";
			case TimeStyle.YEAR_hg_MO_hg_DAY_kg_HOUR_mh_MI:
				return "$year-$moo-$day $hour:$min";
			case TimeStyle.YEAR_hg_MO_hg_DAY_kg_HOUR_mh_MI_mh_SEC:
				return "$year-$moo-$day $hour:$min:$sec";
			case TimeStyle.YEAR_dot_MO:
				return "$year.$moo";
			case TimeStyle.YEAR_dot_MO_dot_DAY:
				return "$year.$moo.$day";
			case TimeStyle.YEAR_MO_DAY:
				return "$year$moo$day";
			case TimeStyle.YEAR_MO_DAY_HOUR_MI_SEC:
				return "$year$moo$day$hour$min$sec";
			case TimeStyle.HOUR_mh_MI_mh_SE:
				return "$hour:$min:$sec";
			case TimeStyle.YEAR_hg_MO_hg_DAY:
				return "$year-$moo-$day";
			case TimeStyle.YEAR_xg_MO_xg_DAY:
				return "$year/$moo/$day";
			case TimeStyle.DIFF:
				{
					// 将日期转成时间戳
					int flagTimeStamp = dt.millisecondsSinceEpoch;
					// 获取当前日期
					DateTime now = DateTime.now();
					int nowTimeStamp = now.millisecondsSinceEpoch;
					// 计算两个时间相差的毫秒数
					int timeDiff = nowTimeStamp - flagTimeStamp;
					// 将毫秒转成秒
					timeDiff = timeDiff ~/ 1000;
					if (timeDiff / 3600 < 1) {
						return '${timeDiff ~/ 60}分钟前';
					}
					if (timeDiff / 3600 > 1 && timeDiff / 86400 < 1) {
						return '${timeDiff ~/ 3600}小时前';
					}
					if (timeDiff / 86400 > 1 && timeDiff / 2592000 < 1) {
						return '${timeDiff ~/ 86400}天前';
					}
					if ((timeDiff / 2592000 > 1 && timeDiff / 31104000 < 1)) {
						return '${timeDiff ~/ 2592000}个月前';
					}
					if (timeDiff / 31104000 > 1) {
						return '${timeDiff ~/ 31104000}年前';
					}
				}
				break;

			case TimeStyle.DIFF_MILLISECOND:
				{
					// 将日期转成时间戳
					int flagTimeStamp = dt.millisecondsSinceEpoch;
					// 获取当前日期
					DateTime now = DateTime.now();
					int nowTimeStamp = now.millisecondsSinceEpoch;
					// 计算两个时间相差的毫秒数
					int timeDiff = nowTimeStamp - flagTimeStamp;
					return (timeDiff.abs()).toString();
				}
				break;
			
			case TimeStyle.YEAR_nian_MO_yue_DAY_ri:
				{
					return "$year年$moo月$day日";
				}
			
			case TimeStyle.MO_yue_DAY_ri:
				{
					return "$moo月$day日";
				}
		}
		return dateTimeString;
	}
	
	/// 返回今天的日期字符串(因为比较常用,所以写个方法)
	static String todayStr(){
		return formatDateTime(dateTimeString: DateTime.now().toString(),style: TimeStyle.YEAR_hg_MO_hg_DAY);
	}
	
	/// 获取某个日期在一年中是第几天天天天天天天天(默认计算当天)
	static int dayOfIndexInYear({DateTime date}){
		date = date??DateTime.now();
		final diff = DateTime.now().difference(new DateTime(date.year, 1, 1, 0, 0));
		final diffInDays = diff.inDays;
		return diffInDays;
	}
	
	/// 获取某个日期在一年中是第几周周周周周周周周(默认计算当天)
	static int weekOfIndexInYear({DateTime date}){
		date = date??DateTime.now();
		// 取今年的1月1日
		final startOfYear = new DateTime(date.year, 1, 1, 0, 0);
		final firstMonday = startOfYear.weekday;
		final daysInFirstWeek = 8 - firstMonday;
		final diff = date.difference(startOfYear);
		var weeks = ((diff.inDays - daysInFirstWeek) / 7).ceil();
		print("weeks $weeks");
		if(daysInFirstWeek > 3) {
			weeks += 1;
		}
	}
	
	/// 获取某个日期所在的那一周,是从几号开始到几号结束(默认周日为第一天)
	static List<DateTime> weekIntervalOfDay({DateTime date}){
		var diffDays = DateTime.now().weekday == 7 ? 0 : DateTime.now().weekday;
		var weekFirst = DateTime.now().add(Duration(days: -diffDays));
		var WeekLast = DateTime.now().add(Duration(days: (DateTime.saturday - diffDays)));
		return [weekFirst,WeekLast];
	}
	
	/// 获取某日所在的月份的第一天和最后一天
	static List<DateTime> monthIntervalOfDay(DateTime aDate){
		//获取当月的第一天
		DateTime firstDayOfMonth = DateTime(aDate.year,aDate.month,1);
		
		//取得了下一个月的第一个
		DateTime dataNextMonthData =  DateTime(aDate.year, aDate.month + 1, 1);
		//下个月第一天再回退一天就是这个月的最后一天
		DateTime lastDayOfMonth = dataNextMonthData.add(Duration(days: -1));
		
		return [firstDayOfMonth,lastDayOfMonth];
	}
	
	/// 获取某日所在的年的第一天和最后一天
	static List<DateTime> yearIntervalOfDay(DateTime aDate){
		DateTime firstDayOfMonth = DateTime(aDate.year,1,1);
		DateTime lastDayOfMonth = DateTime(aDate.year,12,31);
		return [firstDayOfMonth,lastDayOfMonth];
	}
}