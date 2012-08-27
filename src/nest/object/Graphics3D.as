package nest.object 
{
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.control.EngineBase;
	import nest.view.Camera3D;
	
	/**
	 * Graphics3D
	 */
	public class Graphics3D extends Object3D {
		
		public static const MOVE_TO:int = 1;
		public static const LINE_TO:int = 2;
		public static const CURVE_TO:int = 3;
		public static const DRAW_RECT:int = 4;
		public static const DRAW_CIRCLE:int = 5;
		public static const DRAW_ELLIPSE:int = 6;
		
		public static const BEGIN_FILL:int = 7;
		public static const END_FILL:int = 8;
		public static const LINE_STYLE:int = 9;
		
		public static const TRANSLATE:int = 10;
		public static const ROTATE:int = 11;
		public static const SCALE:int = 12;
		public static const CLEAR:int = 13;
		
		private var _commands:Vector.<int>;
		private var _params:Array;
		private var _canvas:Sprite;
		private var _mask:Sprite;
		
		private var _draw:Matrix3D;
		private var _transform:Matrix3D;
		
		private var _lastZ:Number;
		
		public function Graphics3D() {
			super();
			_commands = new Vector.<int>();
			_params = new Array();
			
			_mask = new Sprite();
			_canvas = new Sprite();
			_canvas.mask = _mask;
			
			_draw = new Matrix3D();
			_transform = new Matrix3D();
		}
		
		public function beginFill(color:uint, alpha:Number = 1.0):void {
			_commands.push(BEGIN_FILL);
			_params.push(color, alpha);
		}
		
		public function clear():void {
			_commands.splice(0, _commands.length);
			_params.splice(0, _params.length);
			_canvas.graphics.clear();
		}
		
		public function copyFrom(g:Graphics3D):void {
			clear();
			var a:int = g.commands.length;
			for (var i:int = 0; i < a; i++) {
				_commands.push(g.commands[i]);
			}
			a = g.params.length;
			for (i = 0; i < a; i++) { ;
				_params.push(g.params[i]);
			}
		}
		
		public function curveTo(controlX:Number, controlY:Number, controlZ:Number, anchorX:Number, anchorY:Number, anchorZ:Number):void {
			_commands.push(CURVE_TO);
			_params.push(controlX, controlY, controlZ, anchorX, anchorY, anchorZ);
		}
		
		public function drawCircle(x:Number, y:Number, z:Number, radius:Number):void {
			_commands.push(DRAW_CIRCLE);
			_params.push(x, y, z, radius);
		}
		
		public function drawEllipse(x:Number, y:Number, z:Number, width:Number, height:Number):void {
			_commands.push(DRAW_ELLIPSE);
			_params.push(x, y, z, width, height);
		}
		
		public function drawPath(commands:Vector.<int>, data:Array):void {
			var a:int = commands.length;
			for (var i:int = 0; i < a; i++) {
				_commands.push(commands[i]);
			}
			a = data.length;
			for (i = 0; i < a; i++) {
				_params.push(data[i]);
			}
		}
		
		public function drawRect(x:Number, y:Number,z:Number, width:Number, height:Number):void {
			_commands.push(DRAW_RECT);
			_params.push(x, y, z, width, height);
		}
		
		public function endFill():void {
			_commands.push(END_FILL);
		}
		
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void {
			_commands.push(LINE_STYLE);
			_params.push(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
		}
		
		public function lineTo(x:Number, y:Number,z:Number):void {
			_commands.push(LINE_TO);
			_params.push(x, y, z);
		}
		
		public function moveTo(x:Number, y:Number,z:Number):void {
			_commands.push(MOVE_TO);
			_params.push(x, y, z);
		}
		
		public function translateGraphics(tx:Number, ty:Number, tz:Number):void {
			_commands.push(TRANSLATE);
			_params.push(tx, ty, tz);
		}
		
		public function rotateGraphics(rx:Number, ry:Number, rz:Number):void {
			_commands.push(ROTATE);
			_params.push(rx, ry, rz);
		}
		
		public function scaleGraphics(sx:Number, sy:Number, sz:Number):void {
			_commands.push(SCALE);
			_params.push(sx, sy, sz);
		}
		
		public function clearGraphics():void {
			_commands.push(CLEAR);
		}
		
		public function calculate():void {
			_canvas.graphics.clear();
			
			_mask.graphics.clear();
			_mask.graphics.beginFill(0, 0);
			_mask.graphics.drawRect(0, 0, EngineBase.view.width, EngineBase.view.height);
			_mask.graphics.endFill();
			
			var a:int = _commands.length;
			var j:int = 0,k:int;
			
			var x:Number;
			var y:Number;
			var z:Number;
			var r:Number;
			var px1:Number;
			var py1:Number;
			var px2:Number;
			var py2:Number;
			
			_draw.copyFrom(worldMatrix);
			_draw.append(EngineBase.camera.invertMatrix);
			_draw.append(EngineBase.camera.pm);
			_transform.identity();
			
			var inputVector:Vector3D = new Vector3D(0, 0, 0, 1);
			var outputVector:Vector3D;
			var w_2:Number = EngineBase.view.width / 2;
			var h_2:Number = EngineBase.view.height / 2;
			for (var i:int = 0; i < a;i++ ) {
				switch(_commands[i]) {
					case MOVE_TO://3 params
						inputVector.setTo(_params[j], _params[j + 1], _params[j + 2]);
						outputVector = _draw.transformVector(inputVector);
						px1 = (outputVector.x / outputVector.w + 1) * w_2;
						py1 = (1 - outputVector.y / outputVector.w) * h_2;
						_lastZ = outputVector.z / outputVector.w;
						_canvas.graphics.moveTo(px1, py1);
						j += 3;
						break;
					case LINE_TO://3 params
						inputVector.setTo(_params[j], _params[j + 1], _params[j + 2]);
						outputVector = _draw.transformVector(inputVector);
						px1 = (outputVector.x / outputVector.w + 1) * w_2;
						py1 = (1 - outputVector.y / outputVector.w) * h_2;
						if (_lastZ > 0 && _lastZ < 1) {
							_canvas.graphics.lineTo(px1, py1);
						} else {
							_canvas.graphics.moveTo(px1, py1);
						}
						_lastZ = outputVector.z / outputVector.w;
						j += 3;
						break;
					case CURVE_TO://6 params
						inputVector.setTo(_params[j], _params[j + 1], _params[j + 2]);
						outputVector = _draw.transformVector(inputVector);
						px1 = (outputVector.x / outputVector.w + 1) * w_2;
						py1 = (1 - outputVector.y / outputVector.w) * h_2;
						
						inputVector.setTo(_params[j+3], _params[j + 4], _params[j + 5]);
						outputVector = _draw.transformVector(inputVector);
						px2 = (outputVector.x / outputVector.w + 1) * w_2;
						py2 = (1 - outputVector.y / outputVector.w) * h_2;
						if (_lastZ > 0 && _lastZ < 1) {
							_canvas.graphics.curveTo(px1, py1, px2, py2);
						} else {
							_canvas.graphics.moveTo(px2, py2);
						}
						_lastZ = outputVector.z / outputVector.w;
						j += 6;
						break;
					case DRAW_RECT://5 params
						inputVector.setTo(_params[j], _params[j + 1], _params[j + 2]);
						outputVector = _draw.transformVector(inputVector);
						px1 = (outputVector.x / outputVector.w + 1) * w_2;
						py1 = (1 - outputVector.y / outputVector.w) * h_2;
						_canvas.graphics.moveTo(px1, py1);
						_lastZ = outputVector.z / outputVector.w;
						
						inputVector.setTo(_params[j] + _params[j + 3], _params[j + 1], _params[j + 2]);
						outputVector = _draw.transformVector(inputVector);
						px1 = (outputVector.x / outputVector.w + 1) * w_2;
						py1 = (1 - outputVector.y / outputVector.w) * h_2;
						if (_lastZ > 0 && _lastZ < 1) {
							_canvas.graphics.lineTo(px1, py1);
						} else {
							_canvas.graphics.moveTo(px1, py1);
						}
						_lastZ = outputVector.z / outputVector.w;
						
						inputVector.setTo(_params[j] + _params[j + 3], _params[j + 1] + _params[j + 4], _params[j + 2]);
						outputVector = _draw.transformVector(inputVector);
						px1 = (outputVector.x / outputVector.w + 1) * w_2;
						py1 = (1 - outputVector.y / outputVector.w) * h_2;
						if (_lastZ > 0 && _lastZ < 1) {
							_canvas.graphics.lineTo(px1, py1);
						} else {
							_canvas.graphics.moveTo(px1, py1);
						}
						_lastZ = outputVector.z / outputVector.w;
						
						inputVector.setTo(_params[j], _params[j + 1] + _params[j + 4], _params[j + 2]);
						outputVector = _draw.transformVector(inputVector);
						px1 = (outputVector.x / outputVector.w + 1) * w_2;
						py1 = (1 - outputVector.y / outputVector.w) * h_2;
						if (_lastZ > 0 && _lastZ < 1) {
							_canvas.graphics.lineTo(px1, py1);
						} else {
							_canvas.graphics.moveTo(px1, py1);
						}
						_lastZ = outputVector.z / outputVector.w;
						
						inputVector.setTo(_params[j], _params[j + 1], _params[j + 2]);
						outputVector = _draw.transformVector(inputVector);
						px1 = (outputVector.x / outputVector.w + 1) * w_2;
						py1 = (1 - outputVector.y / outputVector.w) * h_2;
						if (_lastZ > 0 && _lastZ < 1) {
							_canvas.graphics.lineTo(px1, py1);
						} else {
							_canvas.graphics.moveTo(px1, py1);
						}
						_lastZ = outputVector.z / outputVector.w;
						j += 5;
						break;
					case DRAW_CIRCLE://4 params
						x = _params[j];
						y = _params[j + 1];
						z = _params[j + 2];
						r = _params[j + 3];
						
						inputVector.setTo(x+r, y, z);
						outputVector = _draw.transformVector(inputVector);
						px1 = (outputVector.x / outputVector.w + 1) * w_2;
						py1 = (1 - outputVector.y / outputVector.w) * h_2;
						_canvas.graphics.moveTo(px1, py1);
						_lastZ = outputVector.z / outputVector.w;
						for (k = 0; k < 100; k++ ) {
							inputVector.setTo(x + r * Math.cos(k / 50 * Math.PI), y + r * Math.sin(k / 50 * Math.PI), z);
							outputVector = _draw.transformVector(inputVector);
							px1 = (outputVector.x / outputVector.w + 1) * w_2;
							py1 = (1 - outputVector.y / outputVector.w) * h_2;
							if (_lastZ > 0 && _lastZ < 1) {
								_canvas.graphics.lineTo(px1, py1);
							} else {
								_canvas.graphics.moveTo(px1, py1);
							}
							_lastZ = outputVector.z / outputVector.w;
						}
						j += 4;
						break;
					case DRAW_ELLIPSE://5 params
						x = _params[j];
						y = _params[j + 1];
						z = _params[j + 2];
						px2 = _params[j + 3];
						py2 = _params[j + 4];
						
						inputVector.setTo(x + px2, y, z);
						outputVector = _draw.transformVector(inputVector);
						px1 = (outputVector.x / outputVector.w + 1) * w_2;
						py1 = (1 - outputVector.y / outputVector.w) * h_2;
						_canvas.graphics.moveTo(px1, py1);
						_lastZ = outputVector.z / outputVector.w;
						for (k = 0; k < 100; k++) {
							inputVector.setTo(x + px2 * Math.cos(k / 50 * Math.PI), y + py2 * Math.sin(k / 50 * Math.PI), z);
							outputVector = _draw.transformVector(inputVector);
							px1 = (outputVector.x / outputVector.w + 1) * w_2;
							py1 = (1 - outputVector.y / outputVector.w) * h_2;
							if (_lastZ > 0 && _lastZ < 1) {
								_canvas.graphics.lineTo(px1, py1);
							}else {
								_canvas.graphics.moveTo(px1, py1);
							}
							_lastZ = outputVector.z / outputVector.w;
						}
						j += 4;
						break;
						break;
					case BEGIN_FILL://2 params
						_canvas.graphics.beginFill(_params[j], _params[j + 1]);
						j += 2;
						break;
					case END_FILL://0 params
						_canvas.graphics.endFill();
						break;
					case LINE_STYLE://8 params
						_canvas.graphics.lineStyle(_params[j], _params[j + 1], _params[j + 2], _params[j + 3], _params[j + 4], _params[j + 5], _params[j + 6], _params[j + 7]);
						j += 8;
						break;
					case TRANSLATE:
						_transform.appendTranslation(_params[j], _params[j + 1], _params[j + 2]);
						_draw.copyFrom(_transform);
						_draw.append(worldMatrix);
						_draw.append(EngineBase.camera.invertMatrix);
						_draw.append(EngineBase.camera.pm);
						j += 3;
						break;
					case ROTATE:
						_transform.appendRotation(_params[j], Vector3D.X_AXIS);
						_transform.appendRotation(_params[j + 1], Vector3D.Y_AXIS);
						_transform.appendRotation(_params[j + 2], Vector3D.Z_AXIS);
						_draw.copyFrom(_transform);
						_draw.append(worldMatrix);
						_draw.append(EngineBase.camera.invertMatrix);
						_draw.append(EngineBase.camera.pm);
						j += 3;
						break;
					case SCALE:
						_transform.appendScale(_params[j], _params[j + 1], _params[j + 2]);
						_draw.copyFrom(_transform);
						_draw.append(worldMatrix);
						_draw.append(EngineBase.camera.invertMatrix);
						_draw.append(EngineBase.camera.pm);
						j += 3;
						break;
					case CLEAR:
						_transform.identity();
						_draw.copyFrom(worldMatrix);
						_draw.append(EngineBase.camera.invertMatrix);
						_draw.append(EngineBase.camera.pm);
						break;
				}
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get canvas():Sprite {
			return _canvas;
		}
		
		public function get commands():Vector.<int> {
			return _commands;
		}
		
		public function get params():Array {
			return _params;
		}
	}

}