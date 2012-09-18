package nest.object.sound 
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import nest.control.EngineBase;
	import nest.object.IUpdateable;
	import nest.object.Object3D;
	
	/**
	 * Sound3D
	 */
	public class SoundTransform3D extends Object3D implements IUpdateable {
		
		private const PI1:Number = 1 / (Math.PI);
		
		private var v0:Vector3D;
		private var v1:Vector3D;
		
		private var _transform:SoundTransform;
		
		private var _stopped:Boolean = true;
		
		public var headRelative:Boolean = false;
		public var volumn:Number = 1;
		public var far:Number = 200;
		public var near:Number = 40;
		public var insideConeRadian:Number = Math.PI / 8;
		public var outsideConeRadian:Number = Math.PI / 2;
		
		public function SoundTransform3D() {
			super();
			_transform = new SoundTransform(0, 0);
			v0 = new Vector3D();
			v1 = new Vector3D();
		}
		
		public function update():void {
			if (_stopped) return;
			var camera:Matrix3D = EngineBase.camera.invertMatrix;
			
			v0.setTo(0, 0, 0);
			v0 = camera.transformVector(_worldMatrix.transformVector(v0));
			const d:int = v0.length;
			
			if (d < near) {
				_transform.volume = volumn;
				_transform.pan = 0;
			} else if (d <= far) {
				_transform.volume = near / d * volumn;
				if (headRelative) {
					v1.setTo(0, 0, -1);
					v1 = camera.transformVector(_worldMatrix.transformVector(v1));
					v1.setTo(v1.x - v0.x, v1.y - v0.y, v1.z - v0.z);
					v1.normalize();
					var factor:Number = Math.abs(Vector3D.angleBetween(v1, v0));
					if (factor< insideConeRadian) {
						factor = 1;
					}else if (factor<=outsideConeRadian) {
						factor = insideConeRadian/factor;
					}else {
						factor = 0;
					}
					_transform.volume *= factor;
				}
				v0.y = 0; 
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