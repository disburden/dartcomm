
// 判断两个对象是否相等
typedef IsSame = bool Function(Object obj1, Object obj2);
// 两个对象相加的方法,返回前面第一个对象
typedef FnPlus = Object Function(Object needKeepObj, Object beAddedObj);

class DCList {
	
	/// 根据条件从数组中移除元素
	static listRemoveElement<E>(List<E> list, bool f(E element)) {
		var removeList = [];
		
		for (int i = 0; i < list.length; i++) {
			if (f(list[i])) {
				removeList.add(list[i]);
			}
		}

		removeList.forEach((ob) {
			list.remove(ob);
		});
	}
	
	/// 实现带index的map方法
	static List<T> listMapWithIndex<T>(List list,T Function(int index, dynamic value) withIndex) {
		return list
			.asMap()
			.map((k, v) {
			return MapEntry(k, withIndex(k, v));
		})
			.values
			.toList();
	}
	
	/// 将数组中两个位置的元素对调
   static swapElement<T>(List<T> list,int index1,int index2){
	   T temp = list[index1];
	   list[index1] = list[index2];
	   list[index2] = temp;
   }
}

extension DCEList<T> on List<T> {
	
	// 分组统计
	List<T> DCEGroupBy(IsSame same, FnPlus fnPlus) {
		//如果数组空的直接返回
		if (this == null || this.length == 0) {
			return this;
		}
		
		//定义一个临时数组
		List<T> tempList = [];
		
		//循环数组
		for (int i = 0; i <= this.length - 1; ++i) {
			//第一个数直接存入临时数组后,继续
			if (tempList.length == 0) {
				tempList.add(this[i]);
				continue;
			}
			
			//标志临时数组中是否含有与当前对象相同的对象
			bool isSame = false;
			
			//循环临时数组
			for (int j = 0; j <= tempList.length - 1; ++j) {
				//判断是否与当前对象相等
				if (same(this[i], tempList[j])) {
					//相等的话将临时数组中的对象与当前对象相加
					tempList[j] = fnPlus(tempList[j], this[i]);
					//标识为有相同的对象
					isSame = true;
					break;
				}
			}
			
			//要等到临时数组全部循环完之后才能做后面的判断
			//如果没有包含相同的对象,就将当前对象添加到临时数组中
			if (isSame==false) {
				tempList.add(this[i]);
				continue;
			}
		}
		
		//最后将临时数组返回
		return tempList;
	}
	
}