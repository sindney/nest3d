package nest.view.process 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.object.Container3D;
	import nest.object.IContainer3D;
	import nest.object.IMesh;
	import nest.object.IObject3D;
	import nest.view.shader.Shader3D;
	import nest.view.ViewPort;
	
	/**
	 * DepthMapProcess
	 * <p>Special thanks to Cheng Liao.</p>
	 */
	public class DepthMapProcess implements IRenderProcess {
		
		protected var _renderTarget:RenderTarget;
		
		protected var _vm:Matrix3D = new Matrix3D();
		protected var _ivm:Matrix3D = new Matrix3D();
		protected var _pm:Matrix3D = new Matrix3D();
		
		protected var _container:Container3D;
		
		protected var _program:Program3D;
		
		protected var _color:uint;
		protected var _rgba:Vector.<Number> = new Vector.<Number>(4, true);
		
		public function DepthMapProcess(container:Container3D = null, color:uint = 0xff000000) {
			this.container = container;
			this.color = color;
			_renderTarget = new RenderTarget();
			_program = ViewPort.context3d.createProgram();
			_program.upload(
				Shader3D.assembler.assemble(Context3DProgramType.VERTEX, 
					"m44 vt0, va0, vc0\nm44 vt0, vt0, vc4\nmov op, vt0\n" + 
					"div v0, vt0.z, vt0.w\n"), 
				Shader3D.assembler.assemble(Context3DProgramType.FRAGMENT, 
					"add ft0, v0, fc1.a\nsat ft0, ft0\n" + 
					"mul ft0, ft0, fc0\nfrc ft0, ft0\n" + 
					"mul ft1, ft0.rrgb, fc1\nsub oc, ft0, ft1\n")
			);
		}
		
		public function calculate():void {
			var context3d:Context3D = ViewPort.context3d;
			var containers:Vector.<IContainer3D> = new Vector.<IContainer3D>();
			var container:IContainer3D = _container;
			var object:IObject3D;
			var mesh:IMesh;
			
			var pm:Matrix3D = _ivm.clone();
			pm.append(_pm);
			
			if (_renderTarget.texture) {
				context3d.setRenderToTexture(_renderTarget.texture, _renderTarget.enableDepthAndStencil, _renderTarget.antiAlias, _renderTarget.surfaceSelector);
			} else {
				context3d.setRenderToBackBuffer();
			}
			context3d.clear(_rgba[0], _rgba[1], _rgba[2], _rgba[3]);
			
			context3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([255 * 255 * 255, 255 * 255, 255, 1, 0, 1 / 255, 1 / 255, 1 / 255]), 2);
			context3d.setProgram(_program);
			
			var i:int, j:int;
			while (container) {
				if (!container.visible || !container.castShadows) {
					container = containers.pop();
					continue;
				}
				j = container.numChildren;
				for (i = 0; i < j; i++) {
					object = container.getChildAt(i);
					if (object is IMesh) {
						mesh = object as IMesh;
						if (mesh.visible && mesh.castShadows && !mesh.alphaTest) {
							context3d.setCulling(mesh.triangleCulling);
							context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mesh.worldMatrix, true);
							context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, pm, true);
							context3d.setVertexBufferAt(0, mesh.geometry.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
							context3d.drawTriangles(mesh.geometry.indexBuffer);
						}
					} else if (object is IContainer3D) {
						containers.push(object as IContainer3D);
					}
				}
				container = containers.pop();
			}
		}
		
		public function dispose():void {
			_renderTarget = null;
			_vm = null;
			_ivm = null;
			_pm = null;
			_container = null;
			_rgba = null;
			if (_program) _program.dispose();
			_program = null;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get renderTarget():RenderTarget {
			return _renderTarget;
		}
		
		public function get program():Program3D {
			return _program;
		}
		
		public function set program(value:Program3D):void {
			_program = value;
		}
		
		public function get vm():Matrix3D {
			return _vm;
		}
		
		public function get ivm():Matrix3D {
			return _ivm;
		}
		
		public function get pm():Matrix3D {
			return _pm;
		}
		
		public function get container():Container3D {
			return _container;
		}
		
		public function set container(value:Container3D):void {
			_container = value;
		}
		
		public function get color():uint {
			return _color;
		}
		
		public function set color(value:uint):void {
			_color = value;
			_rgba[0] = ((value >> 16) & 0xFF) / 255;
			_rgba[1] = ((value >> 8) & 0xFF) / 255;
			_rgba[2] = (value & 0xFF) / 255;
			_rgba[3] = ((value >> 24) & 0xFF) / 255;
		}
		
	}

}