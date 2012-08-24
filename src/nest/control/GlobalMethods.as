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
		
		public static var index:int = 0;
		public static var stage:Stage;
		
		private static var _stage3ds:Vector.<Stage3D> = new Vector.<Stage3D>();
		private static var _context3ds:Vector.<Context3D> = new Vector.<Context3D>();
		private static var _cameras:Vector.<Camera3D> = new Vector.<Camera3D>();
		private static var _roots:Vector.<IContainer3D> = new Vector.<IContainer3D>();
		private static var _managers:Vector.<ISceneManager> = new Vector.<ISceneManager>();
		private static var _views:Vector.<ViewPort> = new Vector.<ViewPort>();
		
		public static function get stage3ds():Vector.<Stage3D> {
			return _stage3ds;
		}
		
		public static function get context3ds():Vector.<Context3D> {
			return _context3ds;
		}
		
		public static function get cameras():Vector.<Camera3D> {
			return _cameras;
		}
		
		public static function get roots():Vector.<IContainer3D> {
			return _roots;
		}
		
		public static function get managers():Vector.<ISceneManager> {
			return _managers;
		}
		
		public static function get views():Vector.<ViewPort> {
			return _views;
		}
		
		public static function get stage3d():Stage3D {
			return _stage3ds[index];
		}
		
		public static function set stage3d(value:Stage3D):void {
			_stage3ds[index] = value;
		}
		
		public static function get context3d():Context3D {
			return _context3ds[index];
		}
		
		public static function set context3d(value:Context3D):void {
			_context3ds[index] = value;
		}
		
		public static function get camera():Camera3D {
			return _cameras[index];
		}
		
		public static function set camera(value:Camera3D):void {
			_cameras[index] = value;
		}
		
		public static function get root():IContainer3D {
			return _roots[index];
		}
		
		public static function set root(value:IContainer3D):void {
			_roots[index] = value;
		}
		
		public static function get manager():ISceneManager {
			return _managers[index];
		}
		
		public static function set manager(value:ISceneManager):void {
			_managers[index] = value;
		}
		
		public static function get view():ViewPort {
			return _views[index];
		}
		
		public static function set view(value:ViewPort):void {
			_views[index] = value;
		}
		
	}

}