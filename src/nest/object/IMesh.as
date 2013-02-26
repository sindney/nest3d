package nest.object 
{	
	import flash.utils.Dictionary;
	
	import nest.object.geom.Bound;
	import nest.object.geom.Geometry;
	import nest.view.shader.Shader3D;
	import nest.view.TextureResource;
	
	/**
	 * Mesh Interface
	 */
	public interface IMesh extends IObject3D {
		
		function get geom():Geometry;
		function set geom(value:Geometry):void;
		
		function get material():Vector.<TextureResource>;
		function set material(value:Vector.<TextureResource>):void;
		
		function get shader():Shader3D;
		function set shader(value:Shader3D):void;
		
		function get bound():Bound;
		
		function get parameters():Dictionary;
		
		function get cliping():Boolean;
		function set cliping(value:Boolean):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get alphaTest():Boolean;
		function set alphaTest(value:Boolean):void;
		
		function get mouseEnabled():Boolean;
		function set mouseEnabled(value:Boolean):void;
		
		function get triangleCulling():String;
		function set triangleCulling(value:String):void;
		
		function get ignoreRotation():Boolean;
		function set ignoreRotation(value:Boolean):void;
		
		function get ignorePosition():Boolean;
		function set ignorePosition(value:Boolean):void;
		
	}
	
}