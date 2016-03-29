module PagesHelper

		def sun_in_month(month)
	a= Date.parse(month)..((Date.parse(month)>>1))-1
	b= a.select{|x| x.wday==0}
	b
	end
end
