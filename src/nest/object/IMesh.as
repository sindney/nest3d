package nest.object 
{	
	import nest.object.geom.Bound;
	import nest.object.geom.Geometry;
	import nest.object.geom.SkinInfo;
	import nest.view.shader.Shader3D;
	import nest.view.TextureResource;
	
	/**
	 * Mesh Interface
	 */
	public interface IMesh extends IObject3D {
		
		function dispose(all:Boolean = true):void;
		
		function get geometries():Vector.<Geometry>;
		function set geometries(value:Vector.<Geometry>):void;
		
		function get materials():Vector.<Vector.<TextureResource>>;
		function set materials(value:Vector.<Vector.<TextureResource>>):void;
		
		function get shaders():Vector.<Shader3D>;
		function set shaders(value:Vector.<Shader3D>):void;
		
		function get skinInfo():SkinInfo;
		function set skinInfo(value:SkinInfo):void;
		
		function get bound():Bound;
		function set bound(value:Bound):void;
		
		function get cliping():Boolean;
		function set cliping(value:Boolean):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get alphaTest():Boolean;
		function set alphaTest(value:Boolean):void;
		
		function get mouseEnabled():Boolean;
		function set mouseEnabled(value:Boolean):void;
		
		function get id():uint;
		function set id(value:uint):void;
		
		function get triangleCulling():String;
		function set triangleCulling(value:String):void;
		
		function get ignoreRotation():Boolean;
		function set ignoreRotation(value:Boolean):void;
		
		function get ignorePosition():Boolean;
		function set ignorePosition(value:Boolean):void;
		
	}
	
}