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
	 * Mesh Interface.
	 */
	public interface IMesh extends IObject3D {
		
		function draw(context3D:Context3D, matrix:Matrix3D):void;
		
		function clone():IMesh;
		
		function get data():MeshData;
		
		function get material():IMaterial;
		
		function get shader():Shader3D;
		
		function get bound():IBound;
		
		function get cliping():Boolean;
		function set cliping(value:Boolean):void;
		
		function get culling():String;
		function set culling(value:String):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get alphaTest():Boolean;
		
		function get blendMode():BlendMode3D;
		
	}
	
}