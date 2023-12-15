class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rooms = Room.all
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    @room.owner = current_user

    if @room.save
      flash[:notice] = 'Room was successfully created.'
      redirect_to @room
    else
      render :new
    end
  end

  # def check_owner
  #   unless @room.owner == current_user
  #     redirect_to @room, alert: 'You are not the owner of this room.'
  #   end
  # end
 
  def update_characteristics
    @room = Room.find(params[:id])
    @player = current_user.players.find_by(room: @room)
  
    if @player
      @player.visible_characteristics = params[:visible_characteristics]
      @player.save
      flash[:notice] = "Your characteristics have been updated."
    else
      flash[:alert] = "Unable to update your characteristics."
    end
  
    redirect_to @room
  end

  # app/controllers/rooms_controller.rb
  # def open_single_characteristic
  #   @room = Room.find(params[:id])
  #   @players = @room.players.includes(:characteristic)
  #   @player = current_user.players.find_by(room: @room)
  
  #   player_to_open = @players.each_with_object({}) do |player, h|
  #     characteristics = player.characteristic&.attributes
  
  #     if player_to_open && player_to_open.user == current_user || @room.players.exists?(user_id: current_user.id)
  #       if characteristics
  #         h[player] = characteristics['visible_characteristics']
  
  #         if h[player]
  #           if current_user == @room.owner || player_to_open == current_user.players.first
  #             opened_characteristics = player_to_open.opened_characteristics || []
  #             opened_characteristics << characteristic_name
  #             player_to_open.update(characteristics_visible: true, opened_characteristics: opened_characteristics.uniq)
  #             flash[:notice] = "Characteristics have been opened for #{player_to_open.user.email}."
  #           else
  #             flash[:alert] = "Unable to open characteristics."
  #           end
  #         else
  #           flash[:alert] = "Visible characteristics not found for player #{player.user.email}."
  #         end
  #       else
  #         flash[:alert] = "Characteristics not found for player #{player.user.email}."
  #       end
  #     end
  #   end
  #   redirect_to @room
  # end
  
  
  
  
  
  
  
  
  
  def show
    @room = Room.find(params[:id])
    @players = @room.players.includes(:characteristic)
    @player = current_user.players.find_by(room: @room)
    city_name = 'Kyiv'
    @weather_info = OpenWeatherMapService.weather_for_city(city_name)
    @visible_characteristics = @players.each_with_object({}) do |player, h|
      characteristics = player.characteristic&.visible_characteristics
    
      if characteristics
        if current_user == player.user && player.characteristics_visible
          h[player] = player.characteristic.attributes.slice(*characteristics)
        else
          h[player] = characteristics.map { |name| [name, "Hidden"] }.to_h
        end
      end
    end
  end
  
  
   def destroy
    @room = Room.find(params[:id])
    @room.players.destroy_all
    @room.destroy
    redirect_to rooms_path, notice: 'Room was successfully destroyed.'
  end
 def check_owner
        unless @room.owner == current_user
          redirect_to @room, alert: 'You are not the owner of this room.'
        end
      end

    
    
      def show
        @room = Room.find(params[:id])
        @players = @room.players.includes(:characteristic)
        @player = Player.new
        city_name = 'Kyiv'
        @weather_info = OpenWeatherMapService.weather_for_city(city_name)
        

  def take_slot
    @room = Room.find(params[:id])

    if !@room.game_started && @room.players.count < @room.limit
      if @room.players.exists?(user_id: current_user.id)
        flash[:alert] = "You already have a player in this room."
      else
        @player = @room.players.create(user: current_user)
        flash[:notice] = "You've taken a slot in the room."
      end
    else
      flash[:alert] = "The room is already full or the game has started."
    end

    redirect_to @room
  end

  def start_game
    @room = Room.find(params[:id])
  
    if @room.owner == current_user && !@room.game_started
      @room.update(game_started: true)
  
      @room.players.each do |player|
        player.create_initial_characteristic
      end
  
      flash[:notice] = 'Гра почалася!'
    end
  
    redirect_to @room
  end
  

  def set_visible_characteristic
    @room = Room.find(params[:id])
  
    if @room.turn_status == 'waiting_for_characteristic' && current_user == @room.owner
      current_turn_data = @room.current_turn_data || {}
      current_turn_data[:turn_number] ||= 0
      current_turn_data[:turn_number] += 1
  
      @room.players.each do |player|
        if !player.characteristics_visible
          visible_characteristic = player.get_next_visible_characteristic
          player.visible_characteristics ||= []
          player.visible_characteristics << visible_characteristic
          player.update(characteristics_visible: true)
        end
      end
  
      if @room.players.all?(&:characteristics_visible)
        @room.update(turn_status: :voting, current_turn_data: current_turn_data)
      end
    end
  
    # Оновлення характеристик для всіх гравців на сторінці
    @visible_characteristics = @room.players.each_with_object({}) do |player, h|
      characteristics = player.characteristic&.visible_characteristics
  
      if characteristics
        if current_user == player.user && player.characteristics_visible
          h[player] = player.characteristic.attributes.slice(*characteristics)
        else
          h[player] = characteristics.map { |name| [name, "Hidden"] }.to_h
        end
      end
    end
  
    render :show
  end
  
  
  def vote_for_player
    @room = Room.find(params[:id])
    @player = Player.find(params[:player_id])
  
    if @room.turn_status == 'voting' && @room.players.exists?(user_id: current_user.id) && @player != current_user.players.first
      Vote.create(player: @player)
      flash[:notice] = 'Ваш голос зараховано!'
    else
      flash[:alert] = 'Сталася помилка при голосуванні.'
    end
  
    redirect_to @room
  end
  
  

  private

  def room_params
    params.require(:room).permit(:name, :limit)
  end

  def player_params
    params.require(:player).permit(:name)
  end
end