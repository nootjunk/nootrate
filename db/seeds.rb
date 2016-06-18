noots = [
	["Ginkgo Biloba", "Chinese herb."],
	["Noopept", "Russian racetam."],
	["Oxiracetam", "Russian racetam."],
	["Phenylpiracetam", "Russian racetam."],
	["Piracetam", "Firt Russian racetam."],
	["Pramiracetam", "Russian racetam."],
	["Picamilon", "Russian nootropic."],
	["Rhodiola Rosea", "Herb."],
	["Adrafinil", "Wakefulness promoting drug."],
	["Armodafinil", "Wakefulness promoting drug."],
	["Ashwagandha", "Herb."],
	["Caffeine", "Found in coffee."],
	["Modafinil", "Wakefulness promoting drug."],
	["Fish Oil", ""],
	["Lithium", ""],
	["Lithium Orotate", ""],
	["Alpha GPC", ""],
	["Alpha Lipoic Acid", ""],
	["NAC (N-Acetyl-Cysteine)", "Anti-oxidant, amino-acid."],
	["R-Lipoic Acid", ""],
	["Curcumin", "Curcumin is the yellow pigment associated with the curry spice."],
	["Zinc", ""],
	["L-Theanine", ""],
	["GABA", ""],
	["Saint John’s Wort", ""],
	["Aniracetam", "Russian racetam."],
	["Phenibut", ""],
	["Melatonin", ""],
	["Bacopa", ""],
	["Citrulline", ""],
	["Arginine", ""],
	["Magnesium", ""],
	["Valerian Root", ""]
]

tags = [
	["Rating", "Overall rating."],
	["Danger", "Potential danger."],
	["Addictive", "How likely you may want to use."],
	["Memory Boosting", "Boost ability to remember things."],
	["Focus Enhancing", ""],
	["Anti Fatigue", "Decreases tiredness."],
	["Fatigue Inducing", "Increases tiredness."],
	["Anti Anxiety", "Decreases anxiety."],
	["Anxiety Inducing", "Increases anxiety."],
	["Anti Depressant", "Decreases depression."],
	["Depression Inducing", "Causes depression."],
	["Relaxing", "Reduces stress."],
	["Stress Inducing", "Causes stress."],
	["Physical Endurance Enhancement", "How well this improves capacity for physical endurance."],
	["Appetite Suppressant", "Prevents hunger."],
	["Appetite Stimulant", "Increases hunger."]
]

tags.each do |tag|
	Tag.create(:name => tag[0], :safe_name => tag[0].parameterize('_'), :description => tag[1])
end

noots.each do |noot|
	subject = Subject.create(:name => noot[0], :safe_name => noot[0].parameterize('_'), :description => noot[1])
	subject_id = subject.id
	subject_name = noot[0]

	rating = Rating.create(
		:subject_name => subject_name,
		:tag_name => 'Rating',
		:subject_id => subject_id,
		:tag_id => 1,
		:name => "#{subject_name.parameterize('_')}-rating"
	)


#1.upto(rand(1...100)) do |tag_id|
#	if (rand(1...100) > 60)
#		tag_name = tags[tag_id][0]

#		rating = Rating.create(
#			:subject_name => subject_name,
#			:tag_name => tag_name,
#			:subject_id => subject_id,
#			:tag_id => tag_id+1,
#			:name => "#{subject_name.parameterize('_')}-#{tag_name.parameterize('_')}",
#			:cached_votes_total => rand(1..10000),
#			:cached_weighted_average => rand(0.0..100.0))
#	end
#end
end