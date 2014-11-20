module JobsHelper

	def link_to_add_fields(name, f, association)
		new_object = f.object.send(association).klass.new
		if f.object.job_type
			p = Product.where(job_type: f.object.job_type).first_or_initialize
			unless p.new_record?
				new_object.product = p
        new_object.lender = Lender.new
			end
		end
		id = new_object.object_id
		fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
			if f.object.job_type
				render(association.to_s + "/#{f.object.job_type}_fields", f: builder)
			else
				render(association.to_s + "_fields", f: builder)
			end
		end
		link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
	end

end
