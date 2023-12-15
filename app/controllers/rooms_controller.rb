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
        
      end

      def destroy
        @room = Room.find(params[:id])
        @room.players.destroy_all
        @room.destroy
        redirect_to rooms_path, notice: 'Room was successfully destroyed.'
      end
    
    
      def take_slot
        @room = Room.find(params[:id])

        # Перевірте, чи гра не розпочалася і чи ще можна зайняти місце
        if !@room.game_started && @room.players.count < @room.limit
          # Перевірте, чи у користувача вже є гравець у кімнаті
          if @room.players.exists?(user_id: current_user.id)
            flash[:alert] = "You already have a player in this room."
          else
            # Якщо користувач ще не має гравця у кімнаті, створіть нового гравця
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
      
          # Оновлення гравців з характеристиками
          @room.players.each do |player|
            player.create_characteristic(
              age: rand(18..50),
              height: rand(150..200),
              weight: rand(50..100),
              health: ['Full healthy', 'Good', 'Average', 'Poor'].sample,
              phobia: ['Heights', 'Spiders', 'Public speaking', 'Clowns'].sample,
              hobby: ['Reading', 'Painting', 'Gardening', 'Cooking'].sample,
              character: ['Adventurous', 'Cautious', 'Optimistic', 'Pessimistic'].sample,
              luggage: ['Backpack', 'Suitcase', 'Duffle bag', 'No bagage'].sample,
              additional_info: Faker::Lorem.sentence,
              knowledge: ['Science', 'History', 'Technology', 'Art'].sample
            )
          end
      
          flash[:notice] = 'Гра почалася!'
        end
      
        redirect_to @room
      end
      
      
      def open_characteristics_for_player
        @room = Room.find(params[:id])
        player_id = params[:player_id]
      
        # Перевірка чи гравець, якого хочуть відкрити, є у кімнаті та чи він відноситься до поточного користувача
        player_to_open = @room.players.find_by(id: player_id, user_id: current_user.id)
      
        if player_to_open
          # Відкрийте характеристики для гравця
          open_characteristics(player_to_open)
          flash[:notice] = "Characteristics opened for the selected player."
        else
          flash[:alert] = "Unable to open characteristics for the selected player."
        end
      
        redirect_to @room
      end
      
      
      
      def toggle_visibility
        @room = Room.find(params[:id])
        characteristic_name = params[:name]
      
        if current_user == @room.owner && @room.game_started
          player = @room.players.find_by(user_id: current_user.id)
      
          if player.present?
            visible_characteristics = player.visible_characteristics || []
            if visible_characteristics.include?(characteristic_name)
              visible_characteristics -= [characteristic_name]
            else
              visible_characteristics += [characteristic_name]
            end
      
            player.update(visible_characteristics: visible_characteristics)
          end
        end
      
        respond_to do |format|
          format.js
        end
      end
      
      


      private
      def room_params
        params.require(:room).permit(:name, :limit)
      end
      
    
      def player_params
        params.require(:player).permit(:name)
      end

  end
