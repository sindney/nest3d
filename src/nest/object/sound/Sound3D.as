package nest.object.sound 
{
	import flash.events.SampleDataEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	
	import nest.control.EngineBase;
	import nest.object.IUpdateable;
	import nest.object.Object3D;
	
	/**
	 * Sound3D
	 */
	public class Sound3D extends Object3D implements IUpdateable {
		
		private const PI1:Number = 1 / (Math.PI);
		
		private var v0:Vector3D;
		private var v1:Vector3D;
		
		private var _data:Sound;
		private var _transform:SoundTransform;
		private var _channel:SoundChannel;
		
		private var _stopped:Boolean = true;
		
		public var headRelative:Boolean = false;
		public var volumn:Number = 1;
		public var far:Number = 200;
		public var near:Number = 40;
		public var insideConeRadian:Number = Math.PI / 8;
		public var outsideConeRadian:Number = Math.PI / 2;
		public var transSpeed:Number = 34;
		
		private var _lastPs:Vector3D;
		private var _lastPr:Vector3D;
		private var _currentPs:Vector3D;
		private var _currentPr:Vector3D;
		private var _soundData:ByteArray;
		private var _resample:Sound;
		private var _pitch:Number = 1;
		private var _sampleIndex:Number = 0;
		private var _sampleLength:uint;
		
		public function Sound3D(data:Sound) {
			super();
			_transform = new SoundTransform();
			v0 = new Vector3D();
			v1 = new Vector3D();
			
			_lastPs = new Vector3D();
			_lastPr = new Vector3D();
			_currentPr = new Vector3D();
			_currentPs = new Vector3D();
			_soundData = new ByteArray();
			this.data = data;
		}
		
		public function update():void {
			if (_stopped) return;
			var camera:Matrix3D = EngineBase.camera.invertMatrix; 
			v0.setTo(0, 0, 0);
			v0 = camera.transformVector(_worldMatrix.transformVector(v0));
			const d:int = v0.length;
			_lastPr.copyFrom(_currentPr);
			_lastPs.copyFrom(_currentPs);
			_currentPr.copyFrom(EngineBase.camera.position);
			_currentPs.setTo(0, 0, 0);
			_currentPs = _worldMatrix.transformVector(_currentPs);
			var dp:Vector3D = _currentPr.subtract(_currentPs);
			var vs:Vector3D = _currentPs.subtract(_lastPs);
			var vr:Vector3D = _currentPr.subtract(_lastPr);
			_pitch = Math.abs((vs.dotProduct(dp) / dp.length + transSpeed) / (vr.dotProduct(dp) / dp.length + transSpeed));
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
			_channel.soundTransform = _transform;
		}
		
		public function play(loops:int):void {
			if (_stopped && _resample) {
				_stopped = false;
				_channel = _resample.play(0, loops, _transform);
				_currentPr.copyFrom(EngineBase.camera.position);
				_currentPs.setTo(0, 0, 0);
				_currentPs=_worldMatrix.transformVector(_currentPs);
			}
		}
		
		public function stop():void {
			if (!_stopped && _channel) {
				_stopped = true;
				_channel.stop();
			}
		}
		
		private function onSampleData(e:SampleDataEvent):void {
			for (var i:int = 0; i < 4096;i++ ) {
				if (_sampleIndex >= _sampleLength) {
					_sampleIndex -= _sampleLength;
					_soundData.position = 0;
				}
				var index:int = Math.floor(_sampleIndex);
				var factor2:Number = _sampleIndex - index;
				var factor1:Number = 1 - factor2;
				_soundData.position = index * 8;
				var l1:Number = _soundData.readFloat();
				var r1:Number = _soundData.readFloat();
				var l2:Number = _soundData.readFloat();
				var r2:Number = _soundData.readFloat();
				e.data.writeFloat(l1 * factor1 + l2 * factor2);
				e.data.writeFloat(r1 * factor1 + r2 * factor2);
				_sampleIndex += _pitch;
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get data():Sound {
			return _data;
		}
		
		public function set data(value:Sound):void {
			if (_data) {
				_resample.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
				_soundData.clear();
			}
			_data = value;
			if (_data) {
				_data.extract(_soundData, _data.bytesTotal);
				_soundData.position = 0;
				_sampleLength = _soundData.length / 8 - 1;
				_resample = new Sound();
				_resample.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
				_channel = _resample.play(0, 0, _transform);
				_channel.stop();
			}
		}
		
	}

}