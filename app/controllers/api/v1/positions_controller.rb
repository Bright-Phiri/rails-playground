# frozen_string_literal: true

module Api
  module V1
    class PositionsController < ApplicationController
      wrap_parameters false
      before_action :set_position, only: [:show, :update, :destroy]
    
      def index
        positions = Position.all
        render_ok positions, 'Positions successfully retrieved'
      end
    
      def create
        position = Position.new(position_params)
        if position.save
          render_created position, 'Position successfully created'
        else
          render_unprocessable_entity 'Failed to create position', position.errors.full_messages
        end
      end
    
      def show
        render_ok @position, 'Record found'
      end
    
      def update
        if @position.update(position_params)
          render_ok @position, 'Position successfully updated'
        else
          render_unprocessable_entity 'Failed to update position', @position.errors.full_messages
        end
      end
    
      def destroy
        @position.destroy!
        head :no_content
      end
    
      private
    
      def position_params
        params.permit(:name)
      end
    
      def set_position
        @position = Position.find(params[:id])
      end
    end
  end
end

