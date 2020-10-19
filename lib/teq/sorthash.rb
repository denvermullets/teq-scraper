require 'json'
# playing with sorting hashes because my initial scrape didn't sort them
def sort_hash
  base_hash = JSON.parse(File.read("tmp/skills.json"))
  sorted_hash = base_hash.sort_by {|a,b| -b}
  sorted_hashery = sorted_hash.to_h
  
  File.open("tmp/sorted_skills.json","w") do |f|
    f.write(JSON.pretty_generate(sorted_hashery))
  end
  
  puts sorted_hash
end

sort_hash