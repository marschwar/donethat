
namespace :test_data do

  task :prepare => :environment do
    require 'rubygems'
    require 'faker'
    @helper = TestDataHelper.new
  end

  desc 'Generate test-users'
  task :users, [:user_count] => :prepare do |task, args|
    count = args.user_count.try(:to_i) || 10
    @helper.create_test_users count
  end

  desc 'Generate trips'
  task :trips, [:trip_count] => :prepare do |task, args|
    count = args.trip_count.try(:to_i) || 10
    @helper.create_trips count
  end
end

class TestDataHelper
  def uuid_generator
    @uuid_generator ||= UUID.new
  end

  def any_user
    @users ||= User.all
    @users.sample
  end

  def create_test_users(count)
    1.upto(count) { create_test_user }
    puts "#{count} users created"
  end

  def create_test_user
    u = LocalUser.new
    u.name = [Faker::Name.first_name, Faker::Name.last_name].join(' ')
    u.identifier = Faker::Internet.email
    u.avatar_url = Faker::Avatar.image Faker::Lorem.words.join '_' if rand(5) > 0
    u.save!

    u
  end

  def create_trips(count, note_count = nil)
    1.upto(count) do
      create_trip note_count
    end
    puts "#{count} trips created"
  end

  def create_trip(note_count = nil)
    t = Trip.new
    t.uid = uuid_generator.generate
    t.user = any_user
    t.title = Faker::Lorem.sentence.truncate(50, seperator: ' ', omission: '')
    t.content = Faker::Lorem.paragraph
    t.public = rand(10) < 7

    note_count ||= rand(15) + 5
    1.upto(note_count) { create_note t }

    t.save!
    puts "trip with #{note_count} notes created"
    t
  end

  def create_note(trip)
    n = Note.new
    n.trip = trip
    n.uid = uuid_generator.generate
    n.title = Faker::Lorem.sentence.truncate(50, seperator: ' ', omission: '')
    n.content = Faker::Lorem.paragraphs.join '\n'
    n.longitude = random_float -94, -80
    n.latitude = random_float 32, 42
    n.remote_picture_url = 'http://lorempixel.com/600/400/' if rand(5) > 0
    n.note_date = Date.today - rand(50).days
    n.save!

    n
  end

  def random_float(min, max)
    min + (max - min).abs * rand(100000) / 100000.0
  end
end
