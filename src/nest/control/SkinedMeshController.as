package nest.control 
{
	import flash.geom.Vector3D;
	
	import nest.object.data.AnimationTrack;
	import nest.object.geom.Joint;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	import nest.object.SkinnedMesh;
	
	/**
	 * SkinedMeshController
	 */
	public class SkinedMeshController implements IAnimationController {
		
		private var _track:AnimationTrack;
		private var _time:Number = 0;
		private var _advanceTime:Number = 0;
		private var _paused:Boolean = true;
		
		public var target:SkinnedMesh;
		
		public function SkinedMeshController() {
			
		}
		
		public function update():void {
			if (_paused || !target || !_track) return;
			
			// update joints
			target.joint.update(null, _time);
			
			// update vertices
			var w:Number;
			var i:int, j:int = target.data.numVertices, k:int, l:int;
			var v0:Vector3D = new Vector3D();
			var v1:Vector3D = new Vector3D();
			var v2:Vector3D = new Vector3D();
			var v3:Vector3D = new Vector3D();
			var vt0:Vertex;
			var joint:Joint;
			for (i = 0; i < j; i++) {
				k = i * 3;
				vt0 = target.data.vertices[i];
				v0.setTo(target.vertices[k], target.vertices[k + 1], target.vertices[k + 2]);
				v2.setTo(0, 0, 0);
				v3.setTo(0, 0, 0);
				
				l = vt0.joints.length;
				for (k = 0; k < l; k++) {
					if (vt0.joints[k] == -1) break;
					w = vt0.weights[k];
					joint = target.joints[vt0.joints[k]];
					v1 = joint.result.transformVector(v0);
					v2.x += v1.x * w;
					v2.y += v1.y * w;
					v2.z += v1.z * w;
					v1 = joint.result.transformVector(vt0.normal);
					v3.x += v1.x * w;
					v3.y += v1.y * w;
					v3.z += v1.z * w;
				}
				
				v3.normalize();
				vt0.normal.copyFrom(v3);
				vt0.x = v2.x;
				vt0.y = v2.y;
				vt0.z = v2.z;
			}
			
			var triangle:Triangle;
			var vt1:Vertex, vt2:Vertex;
			j = target.data.numTriangles;
			for (i = 0; i < j; i++) {
				triangle = target.data.triangles[i];
				vt0 = target.data.vertices[triangle.index0];
				vt1 = target.data.vertices[triangle.index1];
				vt2 = target.data.vertices[triangle.index2];
				v0.setTo(vt1.x - vt0.x, vt1.y - vt0.y, vt1.z - vt0.z);
				v1.setTo(vt2.x - vt1.x, vt2.y - vt1.y, vt2.z - vt1.z);
				triangle.normal.copyFrom(v0.crossProduct(v1));
				triangle.normal.normalize();
			}
			
			target.data.update();
			
			_time += _advanceTime;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get paused():Boolean {
			return _paused;
		}
		
		public function set paused(value:Boolean):void {
			_paused = value;
		}
		
		public function get time():Number {
			return _time;
		}
		
		public function set time(value:Number):void {
			_time = value;
			if (_track) if (_time < _track.start|| _time > _track.end) _time = track.start;
		}
		
		public function get advanceTime():Number {
			return _advanceTime;
		}
		
		public function set advanceTime(value:Number):void {
			_advanceTime = value;
		}
		
		public function get track():AnimationTrack {
			return _track;
		}
		
		public function set track(value:AnimationTrack):void {
			_track = value;
			if (_time < _track.start|| _time > _track.end) _time = track.start;
		}
		
	}

}