require "octokit"

PARTICIPANTS_TEAM = 385013

token = ENV["GITHUB_API_TOKEN"]
raise StandardError, "Must set GITHUB_API_TOKEN" unless token
client = Octokit::Client.new :access_token => token

file = File.expand_path("../../PARTICIPANTS.txt", __FILE__)
File.readlines(file).each do |user|
  user.chomp!("\n")
  next if user == "" || user.start_with?("#")

  puts user
  if client.add_team_member(PARTICIPANTS_TEAM, user)
    puts "Added #{user}"
  end
end

