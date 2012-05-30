package nest.object 
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 * Sound3D
	 */
	public class Sound3D implements IPlaceable {
		
		private const PI1:Number = 1 / (Math.PI);
		
		private var v0:Vector3D;
		
		private var _data:Sound;
		private var _transform:SoundTransform;
		private var _channel:SoundChannel;
		
		private var _position:Vector3D;
		
		private var _stopped:Boolean = true;
		
		public var volumn:Number = 1;
		public var far:Number = 200;
		public var near:Number = 40;
		
		public function Sound3D(data:Sound) {
			_transform = new SoundTransform(0, 0);
			v0 = new Vector3D();
			_position = new Vector3D();
			this.data = data;
		}
		
		public function update(camera:Matrix3D, container:Matrix3D):void {
			if (_stopped) return;
			
			v0.copyFrom(_position);
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
			
			_channel.soundTransform = _transform;
		}
		
		public function play(loops:int):void {
			if (_stopped && _data) {
				_stopped = false;
				_channel = _data.play(0, loops, _transform);
			}
		}
		
		public function stop():void {
			if (!_stopped && _channel) {
				_stopped = true;
				_channel.stop();
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get data():Sound {
			return _data;
		}
		
		public function set data(value:Sound):void {
			_data = value;
			if (_data) {
				_channel = _data.play(0, 0, _transform);
				_channel.stop();
			}
		}
		
		public function get position():Vector3D {
			return _position;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.object.Sound3D]";
		}
		
	}

}