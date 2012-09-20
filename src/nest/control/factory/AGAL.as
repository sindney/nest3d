package nest.control.factory 
{
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class AGAL 
	{
		
		//REGISTER
		
		public static const OP:String = "op";
		
		public static const OC:String = "oc";
		
		public static const POS_ATTRIBUTE:String = "va0";
		
		public static const UV_ATTRIBUTE:String = "va1";
		
		//TYPE
		
		public static const TYPE_2D:String = "2d";
		
		public static const TYPE_CUBE:String = "cube";
		
		//MIP
		
		public static const MIP_MIPNONE:String = "mipnone";
		
		public static const MIP_NOMIP:String = "nomip";
		
		public static const MIP_MIPNEAREST:String = "mipnearest";
		
		public static const MIP_MIPLINEAR:String = "miplinear";
		
		//FILTER
		
		public static const FILTER_NEAREST:String = "nearest";
		
		public static const FILTER_LINEAR:String = "linear";
		
		//WRAP
		
		public static const WRAP_REPEAT:String = "repeat";
		
		public static const WRAP_WRAP:String = "wrap";
		
		public static const WRAP_CLAMP:String = "clamp";
		
		//inner code
		
		public static var code:String="";
		
		public function AGALHelper() 
		{
			throw new Error("This class is a static class, it shouldn't be instantiated.");
		}
		
		public static function clear():void {
			code = "";
		}
		
		//COPY DATA
		
		public static function mov(dst:String,src:String):void {
			code += "mov " + dst + "," + src + "\n";
		}
		
		//ALGEBRAIC OPERANDS
		
		public static function min(dst:String, src1:String, src2:String):void {
			code += "min " + dst + "," + src1 + "," + src2 + "\n";
		}
		
		public static function max(dst:String, src1:String, src2:String):void {
			code += "max " + dst + "," + src1 + "," + src2 + "\n";
		}
		
		public static function sqt(dst:String,src:String):void {
			code += "sqt " + dst + "," + src + "\n";
		}
		
		public static function rsq(dst:String,src:String):void {
			code += "rsq " + dst + "," + src + "\n";
		}
		
		public static function pow(dst:String, src1:String, src2:String):void {
			code += "pow " + dst + "," + src1 + "," + src2 + "\n";
		}
		
		public static function log(dst:String,src:String):void {
			code += "log " + dst + "," + src + "\n";
		}
		
		public static function exp(dst:String,src:String):void {
			code += "exp " + dst + "," + src + "\n";
		}
		
		public static function nrm(dst:String,src:String):void {
			code += "nrm " + dst + "," + src + "\n";
		}
		
		public static function abs(dst:String, src:String):void {
			code += "abs " + dst + "," + src + "\n";
		}
		
		public static function sat(dst:String, src:String):void {
			code += "sat " + dst + "," + src + "\n";
		}
		
		//MATH OPERANDS
		
		public static function add(dst:String, src1:String, src2:String):void {
			code += "add " + dst + "," + src1 + "," + src2 + "\n";
		}
		
		public static function sub(dst:String, src1:String, src2:String):void {
			code += "sub " + dst + "," + src1 + "," + src2 + "\n";
		}
		
		public static function mul(dst:String, src1:String, src2:String):void {
			code += "mul " + dst + "," + src1 + "," + src2 + "\n";
		}
		
		public static function div(dst:String, src1:String, src2:String):void {
			code += "div " + dst + "," + src1 + "," + src2 + "\n";
		}
		
		public static function rcp(dst:String, src:String):void {
			code += "rcp " + dst + "," + src + "\n";
		}
		
		public static function frc(dst:String, src:String):void {
			code += "frc " + dst + "," + src + "\n";
		}
		
		public static function neg(dst:String, src:String):void {
			code += "neg " + dst + "," + src + "\n";
		}
		
		//TRIGONOMETRY OPERANDS
		
		public static function sin(dst:String, src:String):void {
			code += "sin " + dst + "," + src + "\n";
		}
		
		public static function cos(dst:String, src:String):void {
			code += "cos " + dst + "," + src + "\n";
		}
		
		//CONDITIONAL OPERANDS
		
		public static function kil(src:String):void {
			code += "kil " + src + "\n";
		}
		
		public static function sge(dst:String, src1:String, src2:String):void {
			code += "sge " + dst + "," + src1 + "," + src2 + "\n";
		}
		
		public static function slt(dst:String, src1:String, src2:String):void {
			code += "slt " + dst + "," + src1 + "," + src2 + "\n";
		}
		
		public static function seq(dst:String, src1:String, src2:String):void {
			code += "seq " + dst + "," + src1 + "," + src2 + "\n";
		}
		
		public static function sne(dst:String, src1:String, src2:String):void {
			code += "sne " + dst + "," + src1 + "," + src2 + "\n";
		}
		
		public static function crs(dst:String, src1:String, src2:String):void {
			code += "crs " + dst + "," + src1 + "," + src2 + "\n";
		}
		
		public static function dp3(dst:String, src1:String, src2:String):void {
			code += "dp3 " + dst + "," + src1 + "," + src2 + "\n";
		}
		
		public static function dp4(dst:String, src1:String, src2:String):void {
			code += "dp4 " + dst + "," + src1 + "," + src2 + "\n";
		}
		
		public static function m33(dst:String, src1:String, src2:String):void {
			code += "m33 " + dst + "," + src1 + "," + src2 + "\n";
		}
		
		public static function m34(dst:String, src1:String, src2:String):void {
			code += "m34 " + dst + "," + src1 + "," + src2 + "\n";
		}
		
		public static function m44(dst:String, src1:String, src2:String):void {
			code += "m44 " + dst + "," + src1 + "," + src2 + "\n";
		}
		
		//TEXTURE SAMPLING OPERAND
		
		public static function tex(dst:String, coord:String, texture:String, type:String = "2d", filter:String = "nearest", wrap:String = "clamp", mip:String = "mipnone"):void {
			code += "tex " + dst + "," + coord + "," + texture + " <" + type + "," + filter + "," + wrap + "," + mip + "> \n";
		}
		
		//ADDITIONAL FUNCTION
		
		public static function lerp(dst:String, src1:String, src2:String, ratio:String):void {
			sub(dst, src2, src1);
			mul(dst, dst, ratio);
			add(dst, dst, src1);
		}
		
		public static function length3(dst:String, src1:String):void {
			dp3(dst, src1, src1);
			sqt(dst, dst);
		}
		
		public static function length4(dst:String, src1:String):void {
			dp4(dst, src1, src1);
			sqt(dst, dst);
		}
		
		//r = V - 2(V.N)*N)
		public static function reflect(dst:String, view:String, normal:String):void {
			dp3(dst + ".w", view + ".xyz", normal + ".xyz");
			add(dst + ".w", dst + ".w", dst + ".w");
			mul(dst + ".xyz", normal + ".xyz", dst + ".w");
			sub(dst + ".xyz", view + ".xyz", dst + ".xyz");
			neg(dst + ".xyz", dst + ".xyz");
		}
		
	}

}