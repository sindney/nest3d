package nest.object 
{	
	import nest.object.geom.Bound;
	import nest.object.geom.Geometry;
	import nest.view.shader.Shader3D;
	
	/**
	 * Mesh Interface
	 */
	public interface IMesh extends IObject3D {
		
		/**
		 * @param	all Dispose context3d contents.
		 */
		function dispose(all:Boolean = true):void;
		
		function get geometry():Geometry;
		function set geometry(value:Geometry):void;
		
		function get shaders():Vector.<Shader3D>;
		function set shaders(value:Vector.<Shader3D>):void;
		
		function get bound():Bound;
		
		function get cliping():Boolean;
		function set cliping(value:Boolean):void;
		
		function get alphaTest():Boolean;
		function set alphaTest(value:Boolean):void;
		
		function get mouseEnabled():Boolean;
		function set mouseEnabled(value:Boolean):void;
		
		function get id():uint;
		function set id(value:uint):void;
		
		/**
		 * Don't work with partition trees.
		 */
		function get ignorePosition():Boolean;
		function set ignorePosition(value:Boolean):void;
		
		function get triangleCulling():String;
		function set triangleCulling(value:String):void;
		
	}
	
}