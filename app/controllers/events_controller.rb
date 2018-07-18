class EventsController < ApplicationController
  def handle_event
    CallControl::EventHandler.handle(params)
    head :ok
  end
end
