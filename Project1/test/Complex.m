classdef Complex
    properties
        r
        i
        value
    end
    
    methods
        function obj = Complex(in1, in2)
            obj.r = in1;
            obj.i = in2;
            obj.value = 0;
        end
    
        function output = mtimes(fst, scnd)
            real = fst.r*scnd.r - fst.i * scnd.i;
            image = fst.i*scnd.r + fst.r * scnd.i;
            output = Complex(real, image);
            return
        end

        function output = mrdivide(fst, scnd)
          r_ = (fst.r*scnd.r + fst.i*scnd.i)/square(fst);
          i_ = (fst.i*scnd.r - fst.r*scnd.i)/square(scnd);
          output = Complex(r_,i_);
          return
        end
        
        function output = plus( fst, scnd )
          r_ = fst.r +scnd.r;
          i_ = fst.i + scnd.i;
          output = Complex(r_,i_);
          return
        end

        function output = minus( fst, scnd )
          r_ = fst.r - scnd.r;
          i_ = fst.i - scnd.i;
          output = Complex(r_,i_);
          return
        end

        function output = mpower(base, order)
          output = base;
          if base == Complex(1,0)
            return; 
          end

          for i = 2:order
            output = mtimes(output, base);
          end
        end

        function tf = eq(obj1, obj2)
          tf = 0;
          if obj1.r == obj2.r && obj1.i == obj2.if
            tf = 1;
            return
          end
          return
        end

        function tf = lt(obj1, obj2)
          tf = 0;
          if obj1.r < obj2.r %only for zero case
            tf = 1;
            return
          end
          return
        end

        function output = square(obj)
          output = obj.r*obj.r + obj.i*obj.i;
        end

        function obj = setValue(value)
          obj.value = value;
        end

        function output = getValue()
            output = obj.value;
          return 
        end
    end
end