package pony {
	public class Ultra {
		static public var maxInt : int = 2147483647;
		static public var minInt : int = -2147483648;
		static public var nullInt : int = -2147483648;
		static public function randomString(string_length : int = 36) : String {
			var chars : String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
			var randomstring : String = "";
			{
				var _g : int = 0;
				while(_g < string_length) {
					var i : int = _g++;
					var rnum : int = Math.floor(Math.random() * chars.length);
					randomstring += chars.charAt(rnum);
				}
			}
			return randomstring;
		}
		
	}
}
