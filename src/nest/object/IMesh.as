package nest.object 
{	
	import flash.geom.Vector3D;
	
	import nest.control.partition.OcNode;
	import nest.object.Geometry;
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
		
		function get shader():Shader3D;
		function set shader(value:Shader3D):void;
		
		function get batch():Vector.<IParticlePart>;
		function set batch(value:Vector.<IParticlePart>):void;
		
		function get max():Vector3D;
		
		function get min():Vector3D;
		
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
		
		function get ignoreRotation():Boolean;
		function set ignoreRotation(value:Boolean):void;
		
		function get triangleCulling():String;
		function set triangleCulling(value:String):void;
		
		function get node():OcNode;
		function set node(value:OcNode):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get castShadows():Boolean;
		function set castShadows(value:Boolean):void;
		
	}
	
}