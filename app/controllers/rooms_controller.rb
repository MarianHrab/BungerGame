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
    query = 'skillet' # Replace with the actual search query
    @search_results = DeezerSearchService.search_tracks(query)
  end

        

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
      @room.update(game_started: true, turn_status: 'waiting_for_characteristic')
  
      @room.players.each do |player|
        player.create_characteristic
      end
  
      flash[:notice] = 'Гра почалася!'
    end
  
    redirect_to @room
  end
  
  

  # def set_visible_characteristic
  #   @room = Room.find(params[:id])
  
  #   if @room.turn_status == 'waiting_for_characteristic' && current_user == @room.owner
  #     current_turn_data = @room.current_turn_data || {}
  #     current_turn_data[:turn_number] ||= 0
  #     current_turn_data[:turn_number] += 1
  
  #     @room.players.each do |player|
  #       if !player.characteristics_visible
  #         visible_characteristic = player.get_next_visible_characteristic
  #         player.visible_characteristics = [visible_characteristic]
  #         player.update(characteristics_visible: true)
  #       end
  #     end
  
  #     if @room.players.all?(&:characteristics_visible)
  #       @room.update(turn_status: :voting, current_turn_data: current_turn_data)
  #     end
  #   end
  
  #   # Оновлення характеристик для всіх гравців на сторінці
  #   @visible_characteristics = @room.players.each_with_object({}) do |player, h|
  #     characteristics = player.characteristic&.visible_characteristics
  
  #     if characteristics
  #       if current_user == player.user && player.characteristics_visible
  #         h[player] = player.characteristic.attributes.slice(*characteristics)
  #       else
  #         h[player] = characteristics.map { |name| [name, "Hidden"] }.to_h
  #       end
  #     end
  #   end
  
  #   render :show
  # end
  
  
  def kick_player
    @room = Room.find(params[:id])
    
    if @room.owner == current_user
      player_id = params[:player_id]
      player = @room.players.find(player_id)
  
      if player
        player.destroy
        flash[:notice] = "Гравця вигнано з кімнати."
      else
        flash[:alert] = "Не вдалося знайти гравця."
      end
    else
      flash[:alert] = "Ви не є власником цієї кімнати."
    end
    
    redirect_to @room
  end
  
  def choose_characteristic
    @room = Room.find(params[:id])
  
    # Перевіряємо, чи власник кімнати
    if @room.owner == current_user
      player_id = params[:player_id]
      characteristic_name = params[:characteristic_name]
  
      player = @room.players.find(player_id)
  
      if player && characteristic_name.present?
        # Встановлюємо видиму характеристику для гравця
        player.visible_characteristics ||= []
        player.visible_characteristics << characteristic_name
        player.update(characteristics_visible: true)
  
        # Оновлюємо характеристики для всіх гравців на сторінці
        update_visible_characteristics
  
        flash[:notice] = "Характеристику '#{characteristic_name}' вибрано для гравця #{player.user.email}."
      else
        flash[:alert] = "Не вдалося знайти гравця або характеристику."
      end
    else
      flash[:alert] = "Ви не є власником цієї кімнати."
    end
  
    redirect_to @room
  end
  
  private
  
  # Оновлюємо видимі характеристики для всіх гравців на сторінці
  def update_visible_characteristics
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
  end
  


  def room_params
    params.require(:room).permit(:name, :limit)
  end

  def player_params
    params.require(:player).permit(:name)
  end

  def fetch_weather_info
    url = URI("https://deezerdevs-deezer.p.rapidapi.com/infos")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = 'YOUR_RAPIDAPI_KEY'
    request["X-RapidAPI-Host"] = 'deezerdevs-deezer.p.rapidapi.com'

    response = http.request(request)

    # Parse the JSON response
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  end

end


  
  # def vote_for_player
  #   @room = Room.find(params[:id])
  #   @player = Player.find(params[:player_id])
  
  #   if @room.turn_status == 'voting' && @room.players.exists?(user_id: current_user.id) && @player != current_user.players.first
  #     Vote.create(player: @player)
  #     flash[:notice] = 'Ваш голос зараховано!'
  
  #     # Check if all players have voted
  #     if @room.players.all? { |p| p.votes.any? }
  #       calculate_votes
  #     end
  #   else
  #     flash[:alert] = 'Сталася помилка при голосуванні.'
  #   end
  
  #   redirect_to @room
  # end
  
  # def end_voting
  #   @room = Room.find(params[:id])
  
  #   # Логіка для знаходження гравця з максимальною кількістю голосів
  #   player_with_max_votes = @room.players.max_by(&:votes_count)
  
  #   # Якщо є гравець з максимальною кількістю голосів, викинути його
  #   player_with_max_votes.destroy if player_with_max_votes
  
  #   # Оновити статус кімнати або виконати інші дії, які потрібно зробити після закінчення голосування
  #   if @room.players.count > 1 && @room.players.count <= @room.limit / 2
  #     # Якщо залишилася половина або менше гравців, закінчити гру
  #     @room.update(turn_status: 'game_over', voted_out_player_id: nil)
  #   else
  #     @room.update(turn_status: 'waiting_for_characteristic')
  #   end
    
  #   # Повернути або перенаправити на необхідну сторінку
  #   redirect_to @room, notice: 'Voting ended successfully.'
  # end
