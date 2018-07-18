module CallControl
  module EventHandler
    def self.handle event
      Rails.logger.debug(event)
      action = action_for(event)
      action.new.perform(event) unless action.nil?
    end

    def self.action_for(event)
      case
      when event[:event_type] == "call_initiated" && incoming?(event)
        Actions::AnswerCall
      when event[:event_type] == "call_initiated" && outgoing?(event)
        Actions::CreateCall
      when event[:event_type] == "call_answered"
        Actions::GatherDigits
      when event[:event_type] == "gather_ended"
        Actions::HandleGatheredDigits
      when event[:event_type] == "call_hangup"
        Actions::FinishCall
      end
    end

    def self.incoming?(event)
      event.require(:payload).require(:direction) == "incoming"
    end

    def self.outgoing?(event)
      event.require(:payload).require(:direction) == "outgoing"
    end
  end
end
