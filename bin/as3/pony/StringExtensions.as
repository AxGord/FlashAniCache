package pony {
	public class StringExtensions {
		static public function bigFirst(s : String) : String {
			return s.charAt(0).toUpperCase() + s.substr(1);
		}
		
		static public function smallFirst(s : String) : String {
			return s.charAt(0).toLowerCase() + s.substr(1);
		}
		
		static public function lines(s : String) : Array {
			var a : Array = s.split("\r\n");
			if(a.length == 1) {
				a = s.split("\r");
				if(a.length == 1) a = s.split("\n");
			}
			return a;
		}
		
	}
}
