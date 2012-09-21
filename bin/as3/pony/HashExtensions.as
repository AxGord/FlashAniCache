package pony {
	public class HashExtensions {
		static public function push(h : Hash,key : String,value : *) : void {
			if(h.exists(key)) h.get(key).push(value);
			else h.set(key,[value]);
		}
		
		static public function map(a : Hash,f : Function) : Hash {
			var na : Hash = new Hash();
			{ var $it : * = a.keys();
			while( $it.hasNext() ) { var k : String = $it.next();
			na.set(k,f(a.get(k)));
			}}
			return na;
		}
		
		static public function len(a : Hash) : int {
			var c : int = 0;
			{ var $it : * = a.iterator();
			while( $it.hasNext() ) { var e : * = $it.next();
			c++;
			}}
			return c;
		}
		
	}
}
