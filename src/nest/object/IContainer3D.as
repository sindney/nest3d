package nest.object 
{
	//import nest.view.partition.IPTree;
	
	/**
	 * Container3D Interface
	 */
	public interface IContainer3D extends IObject3D {
		
		function addChild(object:IObject3D):void;
		
		function removeChild(object:IObject3D):void;
		
		function removeChildAt(index:int):IObject3D;
		
		function getChildAt(index:int):IObject3D;
		
		function get objects():Vector.<IObject3D>;
		
		//function get partition():IPTree;
		//function set partition(value:IPTree):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get numChildren():int;
		
		function get mouseEnabled():Boolean;
		function set mouseEnabled(value:Boolean):void;
		
		function get castShadows():Boolean;
		function set castShadows(value:Boolean):void;
		
	}
	
}