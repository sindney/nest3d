package nest.view.process 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	
	import nest.object.IMesh;
	import nest.view.shader.*;
	import nest.view.TextureResource;
	import nest.view.ViewPort;
	
	/**
	 * BasicMeshProcess
	 */
	public class BasicMeshProcess implements IMeshProcess {
		
		public function calculate(mesh:IMesh, pm:Matrix3D):void {
			var context3d:Context3D = ViewPort.context3d;
			
			context3d.setCulling(mesh.triangleCulling);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mesh.matrix, true);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, mesh.worldMatrix, true);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, pm, true);
			
			var byteArraySP:ByteArrayShaderPart;
			var matrixSP:MatrixShaderPart;
			var vectorSP:VectorShaderPart;
			for each(var csp:IConstantShaderPart in mesh.shader.constantParts) {
				if (csp is ByteArrayShaderPart) {
					byteArraySP = csp as ByteArrayShaderPart;
					context3d.setProgramConstantsFromByteArray(byteArraySP.programType, byteArraySP.firstRegister, 
																byteArraySP.numRegisters, byteArraySP.data, 
																byteArraySP.byteArrayOffset);
				} else if (csp is MatrixShaderPart) {
					matrixSP = csp as MatrixShaderPart;
					context3d.setProgramConstantsFromMatrix(matrixSP.programType, matrixSP.firstRegister, 
															matrixSP.matrix, matrixSP.transposedMatrix);
				} else if (csp is VectorShaderPart) {
					vectorSP = csp as VectorShaderPart;
					context3d.setProgramConstantsFromVector(vectorSP.programType, vectorSP.firstRegister, 
															vectorSP.data, vectorSP.numRegisters);
				}
			}
			
			for each(var tr:TextureResource in mesh.material) context3d.setTextureAt(tr.sampler, tr.texture);
			
			var a:Boolean = mesh.geom.vertexBuffer != null;
			var b:Boolean = mesh.geom.normalBuffer != null;
			var c:Boolean = mesh.geom.uvBuffer != null;
			
			if (a) context3d.setVertexBufferAt(0, mesh.geom.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			if (b) context3d.setVertexBufferAt(1, mesh.geom.normalBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			if (c) context3d.setVertexBufferAt(2, mesh.geom.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			
			context3d.setProgram(mesh.shader.program);
			
			context3d.drawTriangles(mesh.geom.indexBuffer);
			
			for each(tr in mesh.material) context3d.setTextureAt(tr.sampler, null);
			
			if (a) context3d.setVertexBufferAt(0, null);
			if (b) context3d.setVertexBufferAt(1, null);
			if (c) context3d.setVertexBufferAt(2, null);
		}
		
	}

}