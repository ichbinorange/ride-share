########################################################
# Step 1: Establish the layers

# In this section of the file, as a series of comments,
# create a list of the layers you identify.
# Which layers are nested in each other?
# Which layers of data "have" within it a different layer?
# Which layers are "next" to each other?

=begin
# create a list of the layers you identify.

I identified two layers,
(A) an Array for each ride based on timeline.
(B) a Hash stores a set of data for a ride, ie driver id, date, cost, rider id, rating, under (A).

# Which layers are nested in each other?
(A) is the outer layer and (B) is nested in it.

# Which layers of data "have" within it a different layer?      
(B) is within (A).

# Which layers are "next" to each other?
Every ride-share data in (B) is "next" to each other.
=end

########################################################
# Step 2: Assign a data structure to each layer

# Copy your list from above, and in this section
# determine what data structure each layer should have

=begin
- Convert the data structure based on timeline into a nested structure mainly based on each driver
- Create a nested data structure with Four layers
(A') a Hash named drivers to store the raw data based on driver info.
(B') second Hash stores the data about drivers pair with their ride-share data.
(C') an Array for each ride-share data listing based on timeline under a driver.
(D') third Hash stores a set of data for each ride, ie date, cost, rider id, rating.

# Which layers are nested in each other?
(A') is the outer layer and (B') is nested in it;
(B') is the first inner layer and (C') is nested in it;
(C') is the second inner layer and (D') is nested in it; and
(D') is the last inner layer.

# Which layers of data "have" within it a different layer?      
(D') is within (C');
(C') is within (B'); and
(B') is within (A').
Layer (B'), (C') and (D') are all within (A').

# Which layers are "next" to each other?
For layer (A'), drivers' data would be next to the data of riders if I generated one;
for layer (B'), each driver's data is next to each other;
for layer (C'), each ride's data under the same driver is next to each other; and
for layer (D'), the information for each ride, ie date, cost, rider id, rating, are next to each other.
=end

########################################################
# Step 3: Make the data structure!

# Setup the entire data structure:
# based off of the notes you have above, create the
# and manually write in data presented in rides.csv
# You should be copying and pasting the literal data
# into this data structure, such as "DR0004"
# and "3rd Feb 2016" and "RD0022"

ride_share_raw_data = {
    drivers: {
      DR0004:
      [
        { :date=>"3rd Feb 2016",
          :cost=>5,
          :rider_id=>"RD0022",
          :rating=>5
          },
        { :date=>"4th Feb 2016",
          :cost=>10,
          :rider_id=>"RD0022",
          :rating=>4
          },
        { :date=>"5th Feb 2016",
          :cost=>20,
          :rider_id=>"RD0073",
          :rating=>5
          }
        ],
      DR0001:
      [
        { :date=>"3rd Feb 2016",
          :cost=>10,
          :rider_id=>"RD0003",
          :rating=>3
          },
        { :date=>"3rd Feb 2016",
          :cost=>30,
          :rider_id=>"RD0015",
          :rating=>4
          },
        { :date=>"5th Feb 2016",
          :cost=>45,
          :rider_id=>"RD0003",
          :rating=>2
          }
        ],
      DR0002:
      [
        { :date=>"3rd Feb 2016",
          :cost=>25,
          :rider_id=>"RD0073",
          :rating=>5
          },
        { :date=>"4th Feb 2016",
          :cost=>15,
          :rider_id=>"RD0013",
          :rating=>1
          },
        { :date=>"5th Feb 2016",
          :cost=>35,
          :rider_id=>"RD0066",
          :rating=>3
          }
        ],
      DR0003:
      [
        { :date=>"4th Feb 2016",
          :cost=>5,
          :rider_id=>"RD0066",
          :rating=>5
          },
        { :date=>"5th Feb 2016",
          :cost=>50,
          :rider_id=>"RD0003",
          :rating=>2
          }
        ]
    }
}

########################################################
# Step 4: Total Driver's Earnings and Number of Rides

# Use an iteration blocks to print the following answers:
# - the number of rides each driver has given
# - the total amount of money each driver has made
# - the average rating for each driver
# - Which driver made the most money?
# - Which driver has the highest average rating?

puts "The number of rides each driver has given:"
ride_share_raw_data[:drivers].each do |driver, rides|
  if rides.count < 2
    puts "==> Driver \"#{ driver }\" has given #{ rides.count } ride."
  else
    puts "==> Driver \"#{ driver }\" has given #{ rides.count } rides."
  end
end

puts "\nThe total amount of money each driver has made:"
ride_share_raw_data[:drivers].each do |driver, rides|
  total_amount = rides.sum { |ride_detail| ride_detail[:cost] }
  puts "==> Driver \"#{ driver }\" has earned $#{ total_amount.to_f }."
end

puts "\nThe average rating for each driver:"
ride_share_raw_data[:drivers].each do |driver, rides|
  total_rating = rides.sum { |ride_detail| ride_detail[:rating] }
  puts "==> Driver \"#{ driver }\" has got the average rating for #{ (total_rating / rides.count).to_f }."
end

# Handle ranking questions, even with a tie
def drivers_ranking(data_for_riders, request_info)
  if request_info == "cost"
    money_ranking = Hash.new
    data_for_riders.each do |driver, rides|
      money_ranking[driver] = rides.sum { |info| info[:cost] }
    end
    ranking_for_drivers = money_ranking.select { |driver, value| value == (money_ranking.max_by { |driver,earning| earning })[1] }

  elsif request_info == "rating"
    ave_rating_ranking = Hash.new
    data_for_riders.each do |driver, rides|
      ave_rating_ranking[driver] = (rides.sum { |info| info[:rating] } / rides.count).to_f
    end
    ranking_for_drivers = ave_rating_ranking.find_all { |driver, value| value == (ave_rating_ranking.max_by { |driver, rating| rating })[1] }
  end
  return ranking_for_drivers
end

def is_tie?(ranking_data, request_info)
  if request_info == "cost"
    if ranking_data.count > 1
      puts "There are #{ ranking_data.count } drivers have the same most earnings!"
      ranking_data.each { |driver, earning| puts "==> Driver \"#{ driver }\" has earned the most money $#{ earning }" }
    else
      ranking_data.each { |driver, earning| puts "==> Driver \"#{ driver }\" has earned the most money $#{ earning }" }
    end

  elsif request_info == "rating"
    if ranking_data.count > 1
      puts "There are #{ ranking_data.count } drivers have the same highest ratings!"
      ranking_data.each { |driver, rating| puts "==> Driver \"#{ driver }\" has the highest rating #{ rating }" }
    else
      ranking_data.each { |driver, rating| puts "==> Driver \"#{ driver }\" has the highest rating #{ rating }" }
    end
  end
end


puts "\nWhich driver made the most money?"
is_tie?(drivers_ranking(ride_share_raw_data[:drivers], "cost"), "cost")

puts "\nWhich driver has the highest average rating?"
is_tie?(drivers_ranking(ride_share_raw_data[:drivers], "rating"), "rating")

# Optional
puts "\nFor each driver, on which day did they make the most money?"
ride_share_raw_data[:drivers].each do |driver, rides|
  each_day_earning = Hash.new
  rides.each do |ride|
    if each_day_earning.include? (ride[:date])
      each_day_earning[ride[:date]] += ride[:cost]
    else  # add a new date to each_day_earning
    each_day_earning[ride[:date]] = ride[:cost]
    end
  end
  earn_the_most = each_day_earning.max_by(each_day_earning.count) { |day, earning| earning }
  tie_date = Array.new
  earn_the_most.each do |day|
    if day[1] == earn_the_most[0][1]
      tie_date.push(day[0])
    end
  end
  puts "==> Driver \"#{ driver }\" earned the most money $#{ earn_the_most[0][1].to_f } on #{ tie_date.join(", ") }."
end
