package pony {
	public class IntExtensions {
		static public function notNull(o : int) : Boolean {
			return o != -2147483648;
		}
		
		static public function isNull(o : int) : Boolean {
			return o == -2147483648;
		}
		
	}
}
