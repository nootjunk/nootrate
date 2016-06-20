1.upto(100) do |i|
	Vote.new(
		votable_type: :Rating,
		votable_id: 34,
		vote_weight: rand(0...10)
		).save
end