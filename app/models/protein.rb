class Protein < ActiveRecord::Base
        def symbols_tr
            if self.symbols!=nil
        	     return self.symbols.tr('#',',')
        	else
        	    return ""
        	end
        end
        def description_tr
        	if self.description!=nil
        	     return self.description.tr('#',',')
        	else
        	    return ""
        	end
        end
        def arabi_symbols_tr
         	if self.arabi_symbols!=nil
        	     return self.arabi_symbols.tr('#',',')
        	else
        	    return ""
        	end
        end
        def arabi_description_tr
        	if self.arabi_description!=nil
        	     return self.arabi_description.tr('#',',')
        	else
        	    return ""
        	end

        end
end
