package nest.object 
{	
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.object.data.MeshData;
	import nest.object.geom.IBound;
	import nest.view.materials.IMaterial;
	import nest.view.BlendMode3D;
	import nest.view.Shader3D;
	
	/**
	 * Mesh Interface
	 */
	public interface IMesh extends IObject3D {
		
		function clone():IMesh;
		
		function get data():MeshData;
		function set data(value:MeshData):void;
		
		function get material():IMaterial;
		function set material(value:IMaterial):void;
		
		function get shader():Shader3D;
		function set shader(value:Shader3D):void;
		
		function get bound():IBound;
		function set bound(value:IBound):void;
		
		function get cliping():Boolean;
		function set cliping(value:Boolean):void;
		
		function get culling():String;
		function set culling(value:String):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get alphaTest():Boolean;
		function set alphaTest(value:Boolean):void;
		
		function get blendMode():BlendMode3D;
		
		function get scale():Vector3D;
		
		function get id():uint;
		function set id(value:uint):void;
		
		function get mouseEnabled():Boolean;
		function set mouseEnabled(value:Boolean):void;
		
	}
	
}