package nest.object 
{
	import nest.control.partition.IPTree;
	
	/**
	 * Container3D
	 */
	public class Container3D extends Object3D implements IContainer3D {
		
		protected var _visible:Boolean = true;
		protected var _mouseEnabled:Boolean = false;
		
		protected var _numChildren:int = 0;
		
		protected var _objects:Vector.<IObject3D>;
		
		protected var _partition:IPTree;
		
		public function Container3D() {
			super();
			_objects = new Vector.<IObject3D>();
		}
		
		public function addChild(object:IObject3D):void {
			_numChildren++;
			object.parent = this;
			_objects.push(object);
		}
		
		public function removeChild(object:IObject3D):void {
			var index:int = _objects.indexOf(object);
			if (index != -1) {
				_numChildren--;
				object.parent = null;
				_objects.splice(index, 1);
			}
		}
		
		public function removeChildAt(index:int):IObject3D {
			var object:IObject3D = _objects[index];
			if (object) {
				_numChildren--;
				object.parent = null;
				_objects.splice(index, 1);
			}
			return object;
		}
		
		public function getChildAt(index:int):IObject3D {
			return index < _numChildren ? _objects[index] : null;
		}
		
		override public function recompose():void {
			super.recompose();
			var i:int;
			var child:IObject3D;
			for (i = 0; i < _numChildren; i++) {
				child = _objects[i];
				child.recompose();
			}
		}
		
		override public function decompose():void {
			super.decompose();
			var i:int;
			var child:IObject3D;
			for (i = 0; i < _numChildren; i++) {
				child = _objects[i];
				child.recompose();
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get visible():Boolean {
			return _visible;
		}
		
		public function set visible(value:Boolean):void {
			_visible = value;
		}
		
		public function get numChildren():int {
			return _numChildren;
		}
		
		public function get mouseEnabled():Boolean {
			return _mouseEnabled;
		}
		
		public function set mouseEnabled(value:Boolean):void {
			_mouseEnabled = value;
		}
		
		public function get partition():IPTree {
			return _partition;
		}
		
		public function set partition(value:IPTree):void {
			_partition = value;
		}
		
		public function get objects():Vector.<IObject3D> {
			return _objects;
		}
		
	}

}