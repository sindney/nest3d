package nest.control 
{
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import nest.object.IContainer3D;
	import nest.view.manager.ISceneManager;
	import nest.view.Camera3D;
	import nest.view.ViewPort;
	
	/**
	 * EngineBase
	 */
	public class EngineBase {
		
		public static var stage:Stage;
		public static var stage3d:Stage3D;
		public static var context3d:Context3D;
		public static var camera:Camera3D;
		public static var root:IContainer3D;
		public static var manager:ISceneManager;
		public static var view:ViewPort;
		
		private static var dictionary:Dictionary = new Dictionary();
		
		public static function returnObject(object:*):void {
			var key:Class = getDefinitionByName(getQualifiedClassName(object)) as Class;
			var pool:Array = key in dictionary ? dictionary[key] : dictionary[key] = new Array();
			pool.push(object);
		}
		
		public static function getObject(key:Class):* {
			if (key in dictionary) {
				var array:Array = (dictionary[key] as Array);
				if (array.length > 0) return array.pop();
			}
			return new key();
		}
		
	}

}