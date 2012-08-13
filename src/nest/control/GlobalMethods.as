package nest.control 
{
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	
	import nest.object.IContainer3D;
	import nest.view.managers.ISceneManager;
	import nest.view.Camera3D;
	import nest.view.ViewPort;
	
	/**
	 * GlobalMethods
	 */
	public class GlobalMethods {
		
		public static var stage:Stage;
		public static var stage3d:Stage3D;
		public static var context3d:Context3D;
		public static var camera:Camera3D;
		public static var root:IContainer3D;
		public static var manager:ISceneManager;
		public static var view:ViewPort;
		
	}

}