package nest.object 
{	
	import nest.object.geom.Geometry;
	import nest.object.geom.IBound;
	import nest.view.material.IMaterial;
	
	/**
	 * Mesh Interface
	 */
	public interface IMesh extends IObject3D {
		
		function get geom():Geometry;
		
		function get material():IMaterial;
		
		function get bound():IBound;
		
		function get cliping():Boolean;
		function set cliping(value:Boolean):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get alphaTest():Boolean;
		function set alphaTest(value:Boolean):void;
		
		function get id():uint;
		function set id(value:uint):void;
		
		function get mouseEnabled():Boolean;
		function set mouseEnabled(value:Boolean):void;
		
		function get ignoreRotation():Boolean;
		function set ignoreRotation(value:Boolean):void;
		
		function get castShadows():Boolean;
		function set castShadows(value:Boolean):void;
		
		function get triangleCulling():String;
		function set triangleCulling(value:String):void;
		
	}
	
}