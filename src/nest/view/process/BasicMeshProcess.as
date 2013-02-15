package nest.view.process 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	
	import nest.object.geom.IndexBuffer3DProxy;
	import nest.object.geom.VertexBuffer3DProxy;
	import nest.object.IMesh;
	import nest.view.material.TextureResource;
	import nest.view.shader.*;
	import nest.view.ViewPort;
	
	/**
	 * BasicMeshProcess
	 */
	public class BasicMeshProcess implements IMeshProcess {
		
		public function calculate(mesh:IMesh, pm:Matrix3D):void {
			var context3d:Context3D = ViewPort.context3d;
			
			context3d.setCulling(mesh.triangleCulling);
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, pm, true);
			
			var byteArraySP:ByteArrayShaderPart;
			var matrixSP:MatrixShaderPart;
			var vectorSP:VectorShaderPart;
			for each(var csp:IConstantShaderPart in mesh.shader.constantParts) {
				if (csp is ByteArrayShaderPart) {
					byteArraySP = csp as ByteArrayShaderPart;
					context3d.setProgramConstantsFromByteArray(byteArraySP.programType, byteArraySP.firstRegister, 
																byteArraySP.numRegisters, byteArraySP.data, 
																byteArray.byteArrayOffset);
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
			
			if (mesh.skinInfo) {
				var i:int, j:int = mesh.skinInfo.bones.length;
				var bone:Bone;
				if (mesh.skinInfo.hardware) {
					for (i = 0; i < j; i++) {
						bone = mesh.skinInfo.bones[i];
						// TODO: update combinedMatrix.
						context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, i * 4, 
																bone.combinedMatrix, true);
					}
				} else {
					
				}
			}
			
			for each(var tr:TextureResource in mesh.material.textures) {
				context3d.setTextureAt(tr.sampler, tr.texture);
			}
			
			for each(var vb:VertexBuffer3DProxy in mesh.geom.vertexBuffers) {
				context3d.setVertexBufferAt(vb.index, vb.buffer, vb.bufferOffset, vb.format);
			}
			
			context3d.setProgram(mesh.shader.program);
			
			for each(var ib:IndexBuffer3DProxy in mesh.geom.indexBuffers) {
				context3D.drawTriangles(ib.buffer, ib.firstIndex, ib.numTriangles);
			}
			
			for each(tr in mesh.material.textures) {
				context3d.setTextureAt(tr.sampler, null);
			}
			
			for each(vb in mesh.geom.vertexBuffers) {
				context3d.setVertexBufferAt(vb.index, null);
			}
		}
		
	}

}