package nest.object.sounds 
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import nest.object.Object3D;
	
	import nest.control.EngineBase;
	
	/**
	 * Sound3D
	 */
	public class SoundTransform3D extends Object3D {
		
		private const PI1:Number = 1 / (Math.PI);
		
		private var v0:Vector3D;
		private var v1:Vector3D;
		
		private var _transform:SoundTransform;
		
		private var _stopped:Boolean = true;
		
		private var _headRelative:Boolean = false;
		
		public var volumn:Number = 1;
		public var rollOffFactor:Number = .1;
		public var far:Number = 200;
		public var near:Number = 40;
		public var insideConeRadian:Number = Math.PI / 6;
		public var outsideConeRadian:Number = Math.PI / 3;
		
		public function SoundTransform3D() {
			super();
			_transform = new SoundTransform(0, 0);
			v0 = new Vector3D();
		}
		
		public function calculate():void {
			if (_stopped) return;
			var camera:Matrix3D = EngineBase.camera.invertMatrix;
			var container:Matrix3D = parent.matrix;
			
			v0.copyFrom(_components[0]);
			v0 = camera.transformVector(container.transformVector(v0));
			
			const d:int = v0.length;
			v0.y = 0;
			
			if (d < near) {
				_transform.volume = volumn;
				_transform.pan = 0;
			} else if (d <= far) {
				_transform.volume = (1 -  d / far) * volumn;
				_transform.pan = Vector3D.angleBetween(v0, Vector3D.Z_AXIS) * PI1;
				if (Math.abs(_transform.pan) > 0.5) {
					_transform.pan = 2 - _transform.pan * 2;
				} else {
					_transform.pan = _transform.pan * 2;
				}
				if (v0.x < 0) _transform.pan = -_transform.pan;
			} else {
				_transform.volume = 0;
				_transform.pan = 0;
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get stopped():Boolean {
			return _stopped;
		}
		
		public function set stopped(value:Boolean):void {
			_stopped = value;
		}
		
		public function get transform():SoundTransform {
			return _transform;
		}
		
	}

}