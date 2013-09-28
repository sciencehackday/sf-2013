require "octokit"

# https://github.com/organizations/sciencehackday/teams/385013
PARTICIPANTS_TEAM = 385013

# Have to use an API token for a user with owner access to the
# sciencehackday org
token = ENV["GITHUB_API_TOKEN"]
raise StandardError, "Must set GITHUB_API_TOKEN" unless token

client = Octokit::Client.new :access_token => token

members = Set.new(client.team_members(PARTICIPANTS_TEAM).map { |u| u.login })

file = File.expand_path("../../PARTICIPANTS.txt", __FILE__)
users = File.readlines(file).
  map { |l| l.chomp("\n") }.
  reject { |l| l == "" || l.start_with?("#") }

participants = Set.new(users)

# Remove those no longer on the participants list
remove = members - participants
remove.each do |user|
  if client.remove_team_member(PARTICIPANTS_TEAM, user)
    puts "Removed #{user}"
  else
    puts "Failed to remove #{user}"
  end
end

# Add new participants to the team
add = participants - members
add.each do |user|
  if client.add_team_member(PARTICIPANTS_TEAM, user)
    puts "Added #{user}"
  else
    puts "Failed to add #{user}"
  end
end
