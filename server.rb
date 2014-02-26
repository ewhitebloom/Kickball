require 'sinatra'
require 'CSV'
require 'pry'

set :public_folder, File.dirname(__FILE__) + '/public'
set :views, File.dirname(__FILE__) + '/views'

get '/:path' do

  @members = []

  Members = Struct.new(:index_value,:first, :last, :position, :team)
  index_value=0
  CSV.foreach('lackp_starting_rosters.csv', headers: true) do |row|
    member = Members.new(index_value,row[0],row[1],row[2],row[3])
    @members << member
    index_value+=1
  end

  @teams = []
  @positions = []

  @members.each do |member|
    unless @teams.include?(member[:team])
      @teams << member[:team]
    end
    unless @positions.include?(member[:position])
      @positions << member[:position]
    end
  end

  @path_formatted=params[:path].to_s.gsub(/-/, ' ').split.map(&:capitalize).join(' ')

  def find_player_info(index,path_formatted)
    if @teams.include?(path_formatted)
      return @members[index][:position]
    else
      @positions.include?(path_formatted)
      return @members[index][:team]
    end
  end

  erb :index
end
